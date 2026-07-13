/// A single transcription update emitted while listening.
///
/// The recognizer emits a stream of these: interim ([isFinal] `false`) updates
/// as the user speaks, followed by a [isFinal] `true` update when the platform
/// settles on its best transcription for the utterance.
class SpeechResult {
  const SpeechResult({
    required this.transcript,
    required this.isFinal,
    this.confidence,
  });

  /// The recognized text so far (partial) or the settled text (final).
  final String transcript;

  /// Whether this is the platform's final result for the current utterance.
  ///
  /// Partial results are best-effort and may change on subsequent updates;
  /// only a final result is stable.
  final bool isFinal;

  /// Platform-reported confidence in `[0.0, 1.0]`, when available.
  ///
  /// Android supplies this only on final results and only sometimes; iOS does
  /// not expose a per-utterance confidence the same way, so this is frequently
  /// `null`. Do not gate correctness on it.
  final double? confidence;

  @override
  String toString() =>
      'SpeechResult(isFinal: $isFinal, transcript: "$transcript")';
}
