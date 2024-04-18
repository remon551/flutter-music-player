import 'dart:async';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:just_audio_background/just_audio_background.link';
import 'package:music_player/utils/songs_player_provider.dart'; // Updated import

class AudioBackgroundService {
  final SongsPlayerProvider _playerProvider = SongsPlayerProvider();

  Future<void> initialize() async {
    // Initialize just_audio_background
    await JustAudioBackground.initialize(
      persistenceMode: PersistenceMode.awoken, // Adjust persistence as needed
      notificationBuilder: (playing, duration, position) => _buildNotification(playing, duration, position),
    );

    // Connect your SongsPlayerProvider with just_audio_background
    await JustAudioBackground.setPlayer(_playerProvider.player);
  }

  // Helper method to build notification (optional)
  Notification _buildNotification(bool playing, Duration duration, Duration position) {
    // Implement notification details here
  }
}
