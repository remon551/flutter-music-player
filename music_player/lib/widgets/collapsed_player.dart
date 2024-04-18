import 'dart:async';

import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:music_player/cubits/get%20songs%20cubit/get_songs_cubit.dart';
import 'package:music_player/cubits/is%20player%20collapsed%20cubit/is_player_collapsed_cubit.dart';
import 'package:music_player/utils/songs_player_provider.dart';
import 'package:music_player/widgets/inkwell_container.dart';
import 'package:music_player/widgets/player_controllers.dart';
import 'package:on_audio_query/on_audio_query.dart';

class CollapsedPlayer extends StatefulWidget {
  const CollapsedPlayer({
    super.key,
    required BottomSheetBarController bsbController,
  }) : _bsbController = bsbController;

  final BottomSheetBarController _bsbController;

  @override
  State<CollapsedPlayer> createState() => _CollapsedPlayerState();
}

class _CollapsedPlayerState extends State<CollapsedPlayer> {
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
    return InkWellContainer(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QueryArtworkWidget(
              artworkQuality: FilterQuality.high,
              id: BlocProvider.of<GetSongsCubit>(context)
                  .songsList[_currentIndex]
                  .id,
              type: ArtworkType.AUDIO,
              artworkHeight: 50,
              artworkWidth: 50,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Marquee(
                text: BlocProvider.of<GetSongsCubit>(context)
                    .songsList[_currentIndex]
                    .displayNameWOExt,
                style: const TextStyle(color: Colors.white),
                blankSpace: 40,
                fadingEdgeEndFraction: 0.2,
                fadingEdgeStartFraction: 0.2,
              ),
            ),
            const PlayerControllers()
          ],
        ),
      ),
      onTap: () {
        widget._bsbController.expand();
        BlocProvider.of<IsPlayerCollapsedCubit>(context).extend();
      },
    );
  }
}
