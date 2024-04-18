import 'package:flutter/material.dart';
import 'package:music_player/utils/constatns.dart';
import 'package:music_player/widgets/inkwell_container.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongDisplayItem extends StatefulWidget {
  const SongDisplayItem(
      {super.key,
      required this.model,
      required this.backgroundColor,
      required this.index,
      this.isPlaying = false,
      this.onTap});
  final SongModel model;
  final Color backgroundColor;
  final int index;
  final bool isPlaying;
  final Function()? onTap;

  @override
  State<SongDisplayItem> createState() => _SongDisplayItemState();
}

class _SongDisplayItemState extends State<SongDisplayItem> {
  String getPlayTime(int? duration) {
    if (duration == null) {
      return '<unknown>';
    } else {
      duration = (duration / 1000).floor();
      int minutes = (duration / 60).floor();
      int seconds = duration % 60;
      return '${minutes < 10 ? '0$minutes' : minutes}:${seconds < 10 ? '0$seconds' : seconds}';
    }
  }

  Color getCurrentColor() =>
      widget.isPlaying ? kplayingSongColor : kdefaultTextColor;

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      padding: 8,
      borderRadius: 20,
      color: widget.backgroundColor,
      onTap: widget.onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          QueryArtworkWidget(
            id: widget.model.id,
            type: ArtworkType.AUDIO,
            artworkHeight: 60,
            artworkWidth: 60,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.model.displayNameWOExt,
                  style: TextStyle(color: getCurrentColor(), fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  widget.model.artist ?? '<unknown>',
                  style: TextStyle(
                      color: getCurrentColor().withOpacity(0.5), fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          const SizedBox(
            width: 25,
          ),
          Column(
            children: [
              Icon(
                widget.isPlaying
                    ? Icons.multitrack_audio_rounded
                    : Icons.play_arrow_rounded,
                color: getCurrentColor(),
              ),
              Text(
                getPlayTime(
                  widget.model.duration,
                ),
                style: TextStyle(color: getCurrentColor()),
              )
            ],
          ),
        ],
      ),
    );
  }
}
