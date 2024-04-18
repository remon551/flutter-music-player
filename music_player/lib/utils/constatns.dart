import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

const kprimayColor = Color(0xff0D112A);
const ksecondryColor = Color(0xff1F213A);
const kthirdColor = Color(0xffe8def8);
const kdisabledButtonColor = Color.fromARGB(123, 158, 158, 158);
const kplayingSongColor = Color.fromARGB(255, 255, 0, 0);
const kdefaultTextColor = Colors.white;

const currentSongPicture = 'CurrentSongPicture';
const khomeScreenAppBarTitle = 'Home';
const kmusicScreenAppBarTitle = 'Your Songs';
const ksearchScreenAppBarTitle = 'Search';

MediaItem toMediaItem(SongModel e) {
  return MediaItem(
      id: e.id.toString(),
      title: e.displayName,
      album: e.album,
      artist: e.artist,
      displayTitle: e.displayNameWOExt,
      duration: Duration(microseconds: e.duration!));
}