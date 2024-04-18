import 'package:flutter/material.dart';
import 'package:music_player/widgets/edited_text_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: EditedTextWidget(value: 'Settings Screen'),
    ));
  }
}
