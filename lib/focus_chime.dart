import 'dart:async';

import 'package:just_audio/just_audio.dart';

class FocusChime {
  final AudioPlayer _player = AudioPlayer();
  bool _loaded = false;

  Future<void> play() async {
    try {
      if (!_loaded) {
        await _player.setAsset('assets/sounds/focus_done.wav');
        _loaded = true;
      }
      await _player.seek(Duration.zero);
      await _player.play();
    } catch (_) {
      // The visible completion message still works if a device blocks sound.
    }
  }

  void dispose() => unawaited(_player.dispose());
}
