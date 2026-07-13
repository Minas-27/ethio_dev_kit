package com.abroid.amharic_stt

import kotlin.test.Test
import kotlin.test.assertNotNull

/*
 * The Android side of amharic_stt is a thin wrapper over the platform
 * SpeechRecognizer. Its meaningful behaviour — locale resolution, permission
 * prompts, real transcription — only exercises on a device/emulator with an
 * on-device recognition service, and is therefore verified manually (see the
 * package README "Verification status" section), not in these JVM unit tests.
 *
 * The Dart test suite (`test/`) covers the public API contract against a mocked
 * platform channel. This file just asserts the plugin class is constructible so
 * the Kotlin sources stay compilable in CI.
 */
internal class AmharicSttPluginTest {
    @Test
    fun plugin_isConstructible() {
        assertNotNull(AmharicSttPlugin())
    }
}
