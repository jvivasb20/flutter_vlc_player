import 'package:flutter/widgets.dart';
import 'package:flutter_vlc_player/src/vlc_player_controller.dart';

class VlcAppLifeCycleObserver extends Object with WidgetsBindingObserver {
  bool _wasPlayingBeforePause = false;
  final VlcPlayerController _controller;

  VlcAppLifeCycleObserver(this._controller);

  void initialize() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller.allowBackgroundPlayback) {
      return;
    }
    switch (state) {
      case AppLifecycleState.paused:
        _wasPlayingBeforePause = _controller.value.isPlaying;
        _controller.pause();
        break;
      case AppLifecycleState.resumed:
        if (_wasPlayingBeforePause) {
          _controller.play();
        }
        break;
      default:
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
