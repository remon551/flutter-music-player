import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/cubits/is%20player%20collapsed%20cubit/is_player_collapsed_cubit.dart';
import 'package:music_player/screens/splash_screen.dart';
import 'package:music_player/utils/constatns.dart';
import 'package:music_player/cubits/get%20songs%20cubit/get_songs_cubit.dart';
import 'package:music_player/utils/simple_cubit_observer.dart';
import 'package:permission_handler/permission_handler.dart';

bool devicePreview = false;

void main() async {
  Bloc.observer = SimpleCubitObserver();

  // await JustAudioBackground.init(
  //   androidNotificationChannelId:
  //       'com.ryanheise.audioservice.AudioServiceActivity',
  //   androidNotificationChannelName: 'Audio playback',
  //   androidNotificationOngoing: true,
  // );

  runApp(
    DevicePreview(
      enabled: devicePreview,
      builder: (context) => const MusicApp(),
    ),
  );
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetSongsCubit(),
        ),
        BlocProvider(
          create: (context) => IsPlayerCollapsedCubit(),
        )
      ],
      child: MaterialApp(
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: ThemeData(
          sliderTheme: const SliderThemeData(
              showValueIndicator: ShowValueIndicator.always,
              valueIndicatorTextStyle: TextStyle(color: Colors.black)),
          scaffoldBackgroundColor: kprimayColor,
          appBarTheme: const AppBarTheme(
            color: ksecondryColor,
            centerTitle: true,
            titleTextStyle: TextStyle(
                color: Colors.white, fontSize: 25, fontFamily: 'Dosis'),
          ),
        ),
        home: FutureBuilder(
          future: Permission.storage.request(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const SplashScreen();
            }
            return const CircularProgressIndicator(
              color: kprimayColor,
            );
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
