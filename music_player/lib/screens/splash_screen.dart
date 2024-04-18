import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/cubits/get%20songs%20cubit/get_songs_cubit.dart';
import 'package:music_player/cubits/get%20songs%20cubit/get_songs_states.dart';
import 'package:music_player/screens/main_screen.dart';
import 'package:music_player/utils/songs_player_provider.dart';
import 'package:music_player/widgets/edited_text_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Permission permission = Permission.mediaLibrary;
  Future<PermissionStatus> checkPermissionStatus(Permission permission) async {
    final status = await permission.status;
    return status;
  }

  late Timer timer;

  

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetSongsCubit>(context).getSongs();
    timer = Timer.periodic(const Duration(seconds: 5), (_) {
      var status = checkPermissionStatus(permission);
      status.then((value) {
        if (value == PermissionStatus.granted) {
          BlocProvider.of<GetSongsCubit>(context).getSongs();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GetSongsCubit, GetSongsState>(
        builder: (context, state) {
          if (state is GetSongsSuccessfullyState) {
            return FutureBuilder(
              future: SongsPlayerProvider().setAudioSource(
                  BlocProvider.of<GetSongsCubit>(context).songsList),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Future.delayed(
                    const Duration(seconds: 2),
                    () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) {
                            return const MainScreen();
                          },
                        ),
                        (route) => false,
                      );
                    },
                  );
                }
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/music.png',
                      ),
                      const CircularProgressIndicator(
                        color: Color.fromARGB(255, 255, 0, 0),
                      )
                    ],
                  ),
                );
              },
            );
          } else if (state is NoSongsState) {
            return const EditedTextWidget(value: 'NoSongsState');
          } else if (state is NoPermissonGivenForGetSongsState) {
            return const EditedTextWidget(
                value: 'NoPermissonGivenForGetSongsState');
          }

          return const SizedBox();
        },
      ),
    );
  }
}
