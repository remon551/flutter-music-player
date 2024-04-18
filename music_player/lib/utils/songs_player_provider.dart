import 'dart:async';
import 'dart:developer';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongsPlayerProvider {
  SongsPlayerProvider._internal();
  static final SongsPlayerProvider _songsPlayer =
      SongsPlayerProvider._internal();

  factory SongsPlayerProvider() {
    log(_songsPlayer.hashCode.toString());
    return _songsPlayer;
  }

  final AudioPlayer player = AudioPlayer();

  Future<void> setAudioSource(List<SongModel> list) async {
    final playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      children: list.map((e) => AudioSource.uri(Uri.parse(e.data))).toList(),
    );
    await player.setAudioSource(playlist);
    log('Set Audio Is Done');
  }

  bool hasNext() {
    return player.hasNext;
  }

  Duration? currentDuration() {
    return player.duration;
  }

  Future<void> seekTo({required Duration duration, int? index}) {
    return player.seek(duration, index: index);
  }

  bool isPlaying() {
    return player.playing;
  }

  StreamSubscription<Duration> listenToPositionStream(
    void Function(Duration)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return player.positionStream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  StreamSubscription<int?> listenToCurrentIndexStream(
    void Function(int?)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return player.currentIndexStream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  StreamSubscription<bool> listenToIsPlayingStream(
    void Function(bool)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return player.playingStream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  StreamSubscription<bool> listenToShuffelModeEnabledStream(
    void Function(bool)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return player.shuffleModeEnabledStream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  Future<void> playSongOnIndex(int index) {
    return seekTo(duration: Duration.zero, index: index);
  }

  Future<void> play() {
    return player.play();
  }

  Future<void> stop() {
    return player.stop();
  }

  bool hasPrevious() {
    return player.hasPrevious;
  }

  Future<void> playPrevious() {
    return player.seekToPrevious();
  }

  Future<void> playNext() {
    return player.seekToNext();
  }

  AudioSource? getAudioSource() {
    return player.audioSource;
  }

  Future<void> pause() {
    return player.pause();
  }

  bool isShuffled() {
    return player.shuffleModeEnabled;
  }

  Future<void> setShuffled(bool shuffle) {
    return player.setShuffleModeEnabled(shuffle);
  }

  int? currentIndex() {
    return player.currentIndex;
  }

  void Function()? playPreviousButtonFunction() {
    if (!hasPrevious()) {
      return () async {
        SongsPlayerProvider().playSongOnIndex(
            SongsPlayerProvider().getAudioSource()!.shuffleIndices.length - 1);
      };
    } else {
      return () async {
        await SongsPlayerProvider().playPrevious();
      };
    }
  }

  void Function()? playButtonFunction() {
    return () async {
      if (isPlaying()) {
        await SongsPlayerProvider().pause();
      } else {
        SongsPlayerProvider().play();
      }
    };
  }

  void Function()? playNextButtonFunction() {
    if (!hasNext()) {
      return () async {
        SongsPlayerProvider().playSongOnIndex(0);
      };
    } else {
      return () async {
        await SongsPlayerProvider().playNext();
      };
    }
  }

  void Function()? shuffleButtonFunction() {
    return () async {
      if (SongsPlayerProvider().isShuffled()) {
        await SongsPlayerProvider().setShuffled(false);
      } else {
        await SongsPlayerProvider().setShuffled(true);
      }
      log('shuffeld: ${SongsPlayerProvider().isShuffled()}');
    };
  }
}
