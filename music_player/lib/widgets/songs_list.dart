import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/cubits/get%20songs%20cubit/get_songs_cubit.dart';
import 'package:music_player/utils/songs_player_provider.dart';
import 'package:music_player/utils/constatns.dart';
import 'package:music_player/widgets/song_display_item.dart';

class SongsList extends StatefulWidget {
  const SongsList({
    super.key,
  });

  @override
  State<SongsList> createState() => _SongsListState();
}

class _SongsListState extends State<SongsList> {
  int _currentIndex = 0;
  late StreamSubscription<int?> _currentIndexStreamSubscription;

  @override
  void initState() {
    super.initState();
    _currentIndexStreamSubscription =
        SongsPlayerProvider().listenToCurrentIndexStream((currentIndex) {
      setState(() {
        _currentIndex = currentIndex ?? 0;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _currentIndexStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: BlocProvider.of<GetSongsCubit>(context).songsList.length,
      itemBuilder: (context, index) {
        return SongDisplayItem(
          index: index,
          backgroundColor: index % 2 == 0 ? ksecondryColor : kprimayColor,
          model: BlocProvider.of<GetSongsCubit>(context).songsList[index],
          onTap: () async {
            if (_currentIndex != index) {
              await SongsPlayerProvider()
                  .playSongOnIndex(index);
              if (!SongsPlayerProvider().isPlaying()) {
                SongsPlayerProvider().play();
              }
            }
          },
          isPlaying: _currentIndex == index,
        );
      },
    );
  }
}
