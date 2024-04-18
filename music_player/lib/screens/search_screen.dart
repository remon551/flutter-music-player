import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/cubits/get%20songs%20cubit/get_songs_cubit.dart';
import 'package:music_player/utils/constatns.dart';
import 'package:music_player/utils/pair.dart';
import 'package:music_player/utils/songs_player_provider.dart';
import 'package:music_player/widgets/custom_text_field.dart';
import 'package:music_player/widgets/song_display_item.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Pair<SongModel, int>> _result = [];
  String _searchedName = '';
  late StreamSubscription<int?> _currentIndexStreamSubscription;
  int _currentIndex = 0;

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CustomTextField(
            labelText: 'Search',
            hintText: 'Enter Song Name...',
            maxLines: 1,
            onChanged: (searchedName) {
              _searchedName = searchedName.toLowerCase();
              _result = [];
              var songList = BlocProvider.of<GetSongsCubit>(context).songsList;
              if (_searchedName != '') {
                for (int i = 0; i < songList.length; i++) {
                  if (songList[i]
                          .displayNameWOExt
                          .toLowerCase()
                          .contains(_searchedName) ||
                      (songList[i].artist ?? '')
                          .toLowerCase()
                          .contains(_searchedName)) {
                    _result.add(Pair(songList[i], i));
                  }
                }
              }

              setState(() {});
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _result.length,
              itemBuilder: (context, index) {
                return SongDisplayItem(
                  model: _result[index].first,
                  backgroundColor:
                      index % 2 == 0 ? ksecondryColor : kprimayColor,
                  index: _result[index].second,
                  onTap: () async {
                    if (_currentIndex != _result[index].second) {
                      await SongsPlayerProvider()
                          .playSongOnIndex(_result[index].second);
                      if (!SongsPlayerProvider().isPlaying()) {
                        SongsPlayerProvider().play();
                      }
                    }
                  },
                  isPlaying: _currentIndex == _result[index].second,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
