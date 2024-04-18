import 'package:flutter/material.dart';
import 'package:music_player/widgets/songs_list.dart';


class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  @override
  Widget build(BuildContext context) {
    return const SongsList();
  }
}
