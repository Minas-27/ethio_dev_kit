package com.abroid.amharic_stt

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

/**
 * Amharic speech-to-text plugin backed by Android's [SpeechRecognizer].
 *
 * Method channel `com.abroid.amharic_stt/methods` handles control calls;
 * event channel `com.abroid.amharic_stt/results` streams transcription updates.
 *
 * This wraps the platform recognizer with the `am-ET` locale — it does not
 * implement recognition itself. Whether Amharic actually resolves depends on
 * the on-device recognition service (typically Google) and its installed
 * language packs, which is exactly what [isAvailable] probes.
 */
class AmharicSttPlugin :
    FlutterPlugin,
    MethodCallHandler,
    ActivityAware,
    EventChannel.StreamHandler {

    private companion object {
        const val METHOD_CHANNEL = "com.abroid.amharic_stt/methods"
        const val EVENT_CHANNEL = "com.abroid.amharic_stt/results"
        const val LOCALE = "am-ET"
        const val PERMISSION_REQUEST_CODE = 0xA3A7
    }

    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private lateinit var appContext: Context

    private val mainHandler = Handler(Looper.getMainLooper())
    private var events: EventChannel.EventSink? = null
    private var recognizer: SpeechRecognizer? = null
    private var listening = false

    private var activityBinding: ActivityPluginBinding? = null
    private var pendingPermissionResult: Result? = null
    private var pendingPartialResults = true

    // region FlutterPlugin

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        appContext = binding.applicationContext
        methodChannel = MethodChannel(binding.binaryMessenger, METHOD_CHANNEL)
        methodChannel.setMethodCallHandler(this)
        eventChannel = EventChannel(binding.binaryMessenger, EVENT_CHANNEL)
        eventChannel.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        destroyRecognizer()
    }

    // endregion

    // region Method channel

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "isAvailable" -> isAvailable(result)
            "startListening" -> {
                val partial = call.argument<Boolean>("partialResults") ?: true
                startListening(partial, result)
            }
            "stopListening" -> {
                runOnMain { recognizer?.stopListening() }
                listening = false
                result.success(null)
            }
            "cancel" -> {
                runOnMain { recognizer?.cancel() }
                listening = false
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    /**
     * Reports whether Amharic (`am-ET`) recognition is usable right now.
     *
     * On Android 13+ (API 33) we ask the recognizer directly via
     * [SpeechRecognizer.checkRecognitionSupport] and confirm `am-ET` is in the
     * on-device *or* online supported-language list — an authoritative answer.
     * On older versions there is no reliable synchronous per-locale API, so we
     * fall back to "a recognition service exists"; the definitive check then
     * happens when [startListening] runs against am-ET and the platform reports
     * `ERROR_LANGUAGE_NOT_SUPPORTED` / `ERROR_LANGUAGE_UNAVAILABLE`.
     */
    private fun isAvailable(result: Result) {
        if (!SpeechRecognizer.isRecognitionAvailable(appContext)) {
            result.success(false)
            return
        }
        if (android.os.Build.VERSION.SDK_INT < android.os.Build.VERSION_CODES.TIRAMISU) {
            // Best-effort on API < 33: service present, locale verified at start.
            result.success(true)
            return
        }
        checkAmharicSupportApi33(result)
    }

    @androidx.annotation.RequiresApi(android.os.Build.VERSION_CODES.TIRAMISU)
    private fun checkAmharicSupportApi33(result: Result) {
        runOnMain {
            val rec = SpeechRecognizer.createSpeechRecognizer(appContext)
            val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
                putExtra(
                    RecognizerIntent.EXTRA_LANGUAGE_MODEL,
                    RecognizerIntent.LANGUAGE_MODEL_FREE_FORM,
                )
                putExtra(RecognizerIntent.EXTRA_LANGUAGE, LOCALE)
            }
            var replied = false
            fun reply(value: Boolean) {
                if (replied) return
                replied = true
                rec.destroy()
                result.success(value)
            }
            rec.checkRecognitionSupport(
                intent,
                appContext.mainExecutor,
                object : android.speech.RecognitionSupportCallback {
                    override fun onSupportResult(support: android.speech.RecognitionSupport) {
                        val supported = (support.supportedOnDeviceLanguages +
                            support.onlineLanguages +
                            support.installedOnDeviceLanguages)
                        reply(supported.any { it.startsWith("am") })
                    }

                    override fun onError(error: Int) {
                        // Could not determine support — treat as unavailable.
                        reply(false)
                    }
                },
            )
        }
    }

    private fun startListening(partialResults: Boolean, result: Result) {
        if (listening) {
            result.error("recognizer_busy", "A recognition session is already active.", null)
            return
        }
        if (!SpeechRecognizer.isRecognitionAvailable(appContext)) {
            result.error("not_available", "No speech recognition service on this device.", null)
            return
        }
        if (!hasMicPermission()) {
            requestMicPermission(partialResults, result)
            return
        }
        beginSession(partialResults, result)
    }

    private fun beginSession(partialResults: Boolean, result: Result) {
        runOnMain {
            try {
                destroyRecognizer()
                val rec = SpeechRecognizer.createSpeechRecognizer(appContext)
                rec.setRecognitionListener(sessionListener)
                recognizer = rec

                val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
                    putExtra(
                        RecognizerIntent.EXTRA_LANGUAGE_MODEL,
                        RecognizerIntent.LANGUAGE_MODEL_FREE_FORM,
                    )
                    putExtra(RecognizerIntent.EXTRA_LANGUAGE, LOCALE)
                    putExtra(RecognizerIntent.EXTRA_LANGUAGE_PREFERENCE, LOCALE)
                    putExtra(RecognizerIntent.EXTRA_ONLY_RETURN_LANGUAGE_PREFERENCE, LOCALE)
                    putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, partialResults)
                    // Prefer on-device where the OS/service supports it.
                    putExtra(RecognizerIntent.EXTRA_PREFER_OFFLINE, true)
                }
                listening = true
                rec.startListening(intent)
                result.success(null)
            } catch (t: Throwable) {
                listening = false
                result.error("unknown", t.message ?: "Failed to start recognition.", null)
            }
        }
    }

    // endregion

    // region RecognitionListener

    private val sessionListener = object : RecognitionListener {
        override fun onReadyForSpeech(params: Bundle?) {}
        override fun onBeginningOfSpeech() {}
        override fun onRmsChanged(rmsdB: Float) {}
        override fun onBufferReceived(buffer: ByteArray?) {}
        override fun onEndOfSpeech() {}

        override fun onPartialResults(partialResults: Bundle?) {
            val text = firstMatch(partialResults) ?: return
            emitResult(text, isFinal = false, confidence = null)
        }

        override fun onResults(results: Bundle?) {
            val text = firstMatch(results) ?: ""
            val confidence = firstConfidence(results)
            emitResult(text, isFinal = true, confidence = confidence)
            listening = false
        }

        override fun onError(error: Int) {
            listening = false
            val (code, message) = mapError(error)
            emitError(code, message)
        }

        override fun onEvent(eventType: Int, params: Bundle?) {}
    }

    private fun firstMatch(bundle: Bundle?): String? =
        bundle?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)?.firstOrNull()

    private fun firstConfidence(bundle: Bundle?): Double? {
        val scores = bundle?.getFloatArray(SpeechRecognizer.CONFIDENCE_SCORES)
        return scores?.firstOrNull()?.toDouble()
    }

    /** Maps an Android [SpeechRecognizer] error code to our stable string code. */
    private fun mapError(error: Int): Pair<String, String> = when (error) {
        SpeechRecognizer.ERROR_INSUFFICIENT_PERMISSIONS ->
            "permission_denied" to "Microphone permission denied."
        SpeechRecognizer.ERROR_LANGUAGE_NOT_SUPPORTED ->
            "locale_unavailable" to "Amharic ($LOCALE) is not supported by this recognizer."
        SpeechRecognizer.ERROR_LANGUAGE_UNAVAILABLE ->
            "locale_unavailable" to "Amharic ($LOCALE) language pack is not installed."
        SpeechRecognizer.ERROR_RECOGNIZER_BUSY ->
            "recognizer_busy" to "The recognizer is busy."
        SpeechRecognizer.ERROR_NO_MATCH ->
            "no_match" to "No matching speech was recognized."
        SpeechRecognizer.ERROR_SPEECH_TIMEOUT ->
            "speech_timeout" to "No speech input detected."
        SpeechRecognizer.ERROR_NETWORK, SpeechRecognizer.ERROR_NETWORK_TIMEOUT ->
            "network" to "A network error occurred during recognition."
        SpeechRecognizer.ERROR_AUDIO ->
            "audio" to "An audio recording error occurred."
        SpeechRecognizer.ERROR_CLIENT ->
            "canceled" to "Recognition was canceled."
        else ->
            "unknown" to "Speech recognition failed (code $error)."
    }

    // endregion

    // region EventChannel.StreamHandler

    override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
        events = sink
    }

    override fun onCancel(arguments: Any?) {
        events = null
    }

    private fun emitResult(transcript: String, isFinal: Boolean, confidence: Double?) {
        runOnMain {
            events?.success(
                mapOf(
                    "transcript" to transcript,
                    "isFinal" to isFinal,
                    "confidence" to confidence,
                ),
            )
        }
    }

    private fun emitError(code: String, message: String) {
        runOnMain { events?.error(code, message, null) }
    }

    // endregion

    // region Permissions / Activity

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
        binding.addRequestPermissionsResultListener(permissionListener)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) =
        onAttachedToActivity(binding)

    override fun onDetachedFromActivityForConfigChanges() = onDetachedFromActivity()

    override fun onDetachedFromActivity() {
        activityBinding?.removeRequestPermissionsResultListener(permissionListener)
        activityBinding = null
    }

    private fun hasMicPermission(): Boolean =
        ContextCompat.checkSelfPermission(appContext, Manifest.permission.RECORD_AUDIO) ==
            PackageManager.PERMISSION_GRANTED

    private fun requestMicPermission(partialResults: Boolean, result: Result) {
        val binding = activityBinding
        if (binding == null) {
            result.error(
                "permission_denied",
                "Microphone permission is required but no Activity is available to request it.",
                null,
            )
            return
        }
        if (pendingPermissionResult != null) {
            result.error("recognizer_busy", "A permission request is already in progress.", null)
            return
        }
        pendingPermissionResult = result
        pendingPartialResults = partialResults
        binding.activity.requestPermissions(
            arrayOf(Manifest.permission.RECORD_AUDIO),
            PERMISSION_REQUEST_CODE,
        )
    }

    private val permissionListener =
        PluginRegistry.RequestPermissionsResultListener { requestCode, _, grantResults ->
            if (requestCode != PERMISSION_REQUEST_CODE) {
                return@RequestPermissionsResultListener false
            }
            val result = pendingPermissionResult
            pendingPermissionResult = null
            val granted = grantResults.isNotEmpty() &&
                grantResults[0] == PackageManager.PERMISSION_GRANTED
            if (result == null) return@RequestPermissionsResultListener true
            if (granted) {
                beginSession(pendingPartialResults, result)
            } else {
                result.error("permission_denied", "Microphone permission was denied.", null)
            }
            true
        }

    // endregion

    private fun destroyRecognizer() {
        runOnMain {
            recognizer?.destroy()
            recognizer = null
            listening = false
        }
    }

    private fun runOnMain(block: () -> Unit) {
        if (Looper.myLooper() == Looper.getMainLooper()) {
            block()
        } else {
            mainHandler.post(block)
        }
    }
}
