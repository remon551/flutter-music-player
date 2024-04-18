import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/cubits/get%20songs%20cubit/get_songs_cubit.dart';
import 'package:music_player/utils/songs_player_provider.dart';
import 'package:music_player/widgets/player_controllers.dart';
import 'package:music_player/widgets/player_slider.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ExpandedPlayer extends StatefulWidget {
  const ExpandedPlayer({
    super.key,
  });

  @override
  State<ExpandedPlayer> createState() => _ExpandedPlayerState();
}

class _ExpandedPlayerState extends State<ExpandedPlayer> {
  int _currentIndex = 0;
  late StreamSubscription<int?> _currentIndexSteam;

  @override
  void initState() {
    super.initState();
    _currentIndexSteam =
        SongsPlayerProvider().listenToCurrentIndexStream((currentIndex) {
      setState(() {
        _currentIndex = currentIndex ?? 0;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _currentIndexSteam.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QueryArtworkWidget(
              artworkQuality: FilterQuality.high,
              id: BlocProvider.of<GetSongsCubit>(context)
                  .songsList[_currentIndex]
                  .id,
              type: ArtworkType.AUDIO,
              artworkHeight: 300,
              artworkWidth: 300,
              artworkBorder: BorderRadius.circular(15),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              BlocProvider.of<GetSongsCubit>(context)
                  .songsList[_currentIndex]
                  .displayNameWOExt,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 40,
            ),
            const PlayerControllers(),
            const SizedBox(
              height: 10,
            ),
            const PlayerSlider(),
          ],
        ),
      ),
    );
  }
}
