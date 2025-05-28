import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';


class BackgroundAudioControl {
  static final BackgroundAudioControl _audioControl =
      BackgroundAudioControl._internal();
  static BackgroundAudioControl get instance => _audioControl;

  late AudioPlayer _audioPlayer;
  late StreamSubscription _subs;
  bool isPlaying = false;
  bool enablePlay = true;

  factory BackgroundAudioControl() {
    return _audioControl;
  }

  BackgroundAudioControl._internal() {
    _audioPlayer = AudioPlayer();
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> play() async {
    await _audioPlayer.play();
  }

  Future<void> playSound({
    required String url,
    bool isLoop = false,
  }) async {
    try {
      isPlaying = true;
      if (!enablePlay) {
        return;
      }
      setUsage();
      enablePlay = false;
      Future.delayed(const Duration(milliseconds: 500), () {
        enablePlay = true;
      });
      await _audioPlayer.stop();
      await _audioPlayer.setAsset(url);
      if (isLoop) {
        _audioPlayer.setLoopMode(LoopMode.one);
      }
      await _audioPlayer.play();
      _subs = _audioPlayer.playerStateStream.listen((event) {
        if (event.processingState == ProcessingState.completed) {
          _subs.cancel();
        }
      });
    } catch (error) {
      debugPrint('Error on play local audio: $error');
    }
  }

  Future<void> stopSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setLoopMode(LoopMode.off);
      isPlaying = false;
    } catch (error) {
      isPlaying = false;
      debugPrint('Error on stop audio $error');
    }
  }

  Future<void> setUsage() async {
    try{
      _audioPlayer.setAndroidAudioAttributes(const AndroidAudioAttributes(
          usage: AndroidAudioUsage.media
      ));
    }catch(error){
      debugPrint('Error on stop audio $error');
    }
  }
}
