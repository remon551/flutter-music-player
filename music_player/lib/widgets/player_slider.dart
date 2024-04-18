import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/cubits/get%20songs%20cubit/get_songs_cubit.dart';
import 'package:music_player/utils/songs_player_provider.dart';
import 'package:music_player/utils/constatns.dart';

class PlayerSlider extends StatefulWidget {
  const PlayerSlider({
    super.key,
  });

  @override
  State<PlayerSlider> createState() => _PlayerSliderState();
}

class _PlayerSliderState extends State<PlayerSlider> {
  double _value = 0;
  late StreamSubscription<Duration> _positionSubscription;

  @override
  void initState() {
    super.initState();
    _positionSubscription =
        SongsPlayerProvider().listenToPositionStream((currentDuration) {
      setState(() {
        _value = currentDuration.inMilliseconds.toDouble();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _positionSubscription.cancel();
  }

  String getPlayTime(int duration) {
    duration = (duration / 1000).floor();
    int minutes = (duration / 60).floor();
    int seconds = duration % 60;
    return '${minutes < 10 ? '0$minutes' : minutes}:${seconds < 10 ? '0$seconds' : seconds}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Slider(
          activeColor: kdefaultTextColor,
          value: _value,
          onChanged: (value) async {
            if (BlocProvider.of<GetSongsCubit>(context)
                        .songsList[
                            SongsPlayerProvider().currentIndex() ?? 0]
                        .duration!
                        .toDouble() -
                    value <
                2000) {
              _value = BlocProvider.of<GetSongsCubit>(context)
                      .songsList[SongsPlayerProvider().currentIndex() ?? 0]
                      .duration!
                      .toDouble() -
                  2000;
            } else {
              _value = value;
            }
            setState(() {});
            await SongsPlayerProvider()
                .seekTo(duration: Duration(milliseconds: _value.toInt()));
          },
          min: 0,
          max: BlocProvider.of<GetSongsCubit>(context)
              .songsList[SongsPlayerProvider().currentIndex() ?? 0]
              .duration!
              .toDouble(),
          allowedInteraction: SliderInteraction.tapAndSlide,
          label: getPlayTime(_value.toInt()),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getPlayTime(_value.toInt()),
                style: const TextStyle(color: kdefaultTextColor),
              ),
              Text(
                getPlayTime(BlocProvider.of<GetSongsCubit>(context)
                    .songsList[SongsPlayerProvider().currentIndex() ?? 0]
                    .duration!),
                style: const TextStyle(color: kdefaultTextColor),
              )
            ],
          ),
        )
      ],
    );
  }
}
