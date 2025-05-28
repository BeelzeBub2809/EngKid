import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';


class AudioControl {
  static final AudioControl _audioControl = AudioControl._internal();
  static AudioControl get instance => _audioControl;

  AudioPlayer _audioPlayer = AudioPlayer();
  late StreamSubscription _subs;
  bool isPlaying = true;
  bool enablePlay = true;

  factory AudioControl() {
    return _audioControl;
  }

  AudioControl._internal() {
    // if(_audioPlayer!=null){
    //   _audioPlayer.dispose();
    // }
    _audioPlayer = AudioPlayer();
    // _audioPlayer.setAndroidAudioAttributes(const AndroidAudioAttributes(
    //     usage: AndroidAudioUsage.media
    // ));
  }

  void restartPlayer()async {
    // if(_audioPlayer.playing) {
    //
    // }
    await _audioPlayer.stop();
    await _audioPlayer.dispose();
    await Future.delayed(const Duration(milliseconds: 100));
    _audioPlayer = AudioPlayer();

    await _audioPlayer.setAndroidAudioAttributes(const AndroidAudioAttributes(
        usage: AndroidAudioUsage.media,
        contentType: AndroidAudioContentType.music,
        flags: AndroidAudioFlags.none));
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }

  Future<void> playLocalAudio({
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

  Future<void> playNetworkAudio(String url) async {
    try {
      isPlaying = true;
      if (!enablePlay) {
        return;
      }
      enablePlay = false;
      Future.delayed(const Duration(milliseconds: 200), () {
        enablePlay = true;
      });
      await _audioPlayer.stop();
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
      _subs = _audioPlayer.playerStateStream.listen((event) {
        //For network audio, the state will be idle when the audio reach to end.
        if (event.processingState == ProcessingState.completed) {
          isPlaying = false;
          _subs.cancel();
        }
      });
    } catch (error) {
      isPlaying = false;
      debugPrint('Error on play network audio: $error');
    }
  }

  Future<void> playAudioFile(String path) async {
    try {
      isPlaying = true;
      if (!enablePlay) {
        return;
      }
      enablePlay = false;
      Future.delayed(const Duration(milliseconds: 200), () {
        enablePlay = true;
      });
      if(isPlaying) {
        await _audioPlayer.stop();
      }
      await _audioPlayer.stop();
      await _audioPlayer.setFilePath(path);
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.play();

      _subs = _audioPlayer.playerStateStream.listen((event) {
        if (event.processingState == ProcessingState.completed) {
          isPlaying = false;
          _subs.cancel();
        }
      });
    } catch (error) {
      isPlaying = false;
      print("this error:${error}");
      debugPrint('Error on play cache audio: $error');
    }
  }

  Future<void> stopAudio() async {
    try {
      await _audioPlayer.stop();
      // await _audioPlayer.setLoopMode(LoopMode.off);
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

  Future<void> setEnable() async {
    try{
      enablePlay = true;
    }catch(error){
      debugPrint('Error on stop audio $error');
    }
  }
}
