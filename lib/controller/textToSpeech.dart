import 'package:flutter_tts/flutter_tts.dart';
import 'package:third_eye/util/enum.dart';

class TextToSpeech{
  FlutterTts _flutterTts = FlutterTts();
  TtsState _ttsState = TtsState.stopped;
  dynamic languages;
  String language;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;

  get ttsState => _ttsState;

  TextToSpeech() {
    _getLanguages();
    _flutterTts.setStartHandler(() {
      _ttsState = TtsState.playing;
    });

    _flutterTts.setCompletionHandler(() {
      _ttsState = TtsState.stopped;
    });

    _flutterTts.setErrorHandler((msg) {
      print("error: $msg");
      _ttsState = TtsState.stopped;
    });
  }

  Future _getLanguages() async {
    languages = await _flutterTts.getLanguages;
    print(language);
  }

  Future speak(String text) async {
    await _flutterTts.setVolume(volume);
    await _flutterTts.setSpeechRate(rate);
    await _flutterTts.setPitch(pitch);

    if (text != null) {
      if (text.isNotEmpty) {
        var result = await _flutterTts.speak(text);
        if (result == 1) {
          _ttsState = TtsState.playing;
        }
      }
    }
  }

  Future stop() async {
    var result = await _flutterTts.stop();
    if (result == 1) {
      _ttsState = TtsState.stopped;
    }
  }

  void dispose() {
    _flutterTts.stop();
  }
}
