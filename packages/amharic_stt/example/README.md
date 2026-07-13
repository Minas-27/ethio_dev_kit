# amharic_stt_example

A minimal Flutter app demonstrating the [`amharic_stt`](../) plugin:

- an availability check on startup, with a clear message when Amharic isn't
  supported on the device;
- a mic button to start/stop listening;
- live partial + final transcription display;
- typed error display (permission denied, locale unavailable, etc.).

## Run

```bash
cd example
flutter run
```

On first launch the app requests microphone (and, on iOS, speech-recognition)
permission. If the device's platform recognizer does not support the `am-ET`
locale, the app shows "Amharic speech recognition is not available on this
device." instead of the mic UI — see the package
[README support matrix](../README.md#platform--locale-support) for why.
