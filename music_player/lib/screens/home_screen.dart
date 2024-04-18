import 'package:flutter/material.dart';
import 'package:music_player/widgets/edited_text_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: EditedTextWidget(value: 'Home Screen'),);
  }
}