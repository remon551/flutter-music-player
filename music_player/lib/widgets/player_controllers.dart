import 'dart:async';
import 'package:flutter/material.dart';
import 'package:music_player/utils/songs_player_provider.dart';
import 'package:music_player/utils/constatns.dart';

class PlayerControllers extends StatelessWidget {
  const PlayerControllers({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PlayPrevButton(),
        PlayButton(),
        PlayNextButton(),
        RandomButton(),
      ],
    );
  }
}

class PlayPrevButton extends StatelessWidget {
  const PlayPrevButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.white,
      disabledColor: kdisabledButtonColor,
      onPressed: SongsPlayerProvider().playPreviousButtonFunction(),
      icon: const Icon(
        Icons.skip_previous_rounded,
        size: 30,
      ),
    );
  }
}

class PlayButton extends StatefulWidget {
  const PlayButton({
    super.key,
  });

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  bool _isPlaying = false, hasNext = true;
  late StreamSubscription<bool> _playingStream;
  @override
  void initState() {
    super.initState();

    _playingStream = SongsPlayerProvider().listenToIsPlayingStream((isPlaying) {
      setState(() {
        _isPlaying = isPlaying;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _playingStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: kdefaultTextColor,
      disabledColor: kdisabledButtonColor,
      onPressed: () async {
        (SongsPlayerProvider().isPlaying()) ? SongsPlayerProvider().pause() : SongsPlayerProvider().play();
       
      },
      icon: Icon(
        (_isPlaying) ? Icons.pause_rounded : Icons.play_arrow_rounded,
        size: 30,
      ),
    );
  }
}

class PlayNextButton extends StatelessWidget {
  const PlayNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: kdefaultTextColor,
      disabledColor: kdisabledButtonColor,
      onPressed: SongsPlayerProvider().playNextButtonFunction(),
      icon: const Icon(
        Icons.skip_next_rounded,
        size: 30,
      ),
    );
  }
}

class RandomButton extends StatefulWidget {
  const RandomButton({
    super.key,
  });

  @override
  State<RandomButton> createState() => _RandomButtonState();
}

class _RandomButtonState extends State<RandomButton> {
  bool _isShuffeld = false;
  late StreamSubscription<bool> _shuffleStream;

  @override
  void initState() {
    super.initState();
    _shuffleStream =
        SongsPlayerProvider().listenToShuffelModeEnabledStream((isShuffeld) {
      setState(() {
        _isShuffeld = isShuffeld;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _shuffleStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: (_isShuffeld) ? kplayingSongColor : kdefaultTextColor,
      disabledColor: kdisabledButtonColor,
      onPressed: SongsPlayerProvider().shuffleButtonFunction(),
      icon: const Icon(
        Icons.shuffle_rounded,
        size: 30,
      ),
    );
  }
}
