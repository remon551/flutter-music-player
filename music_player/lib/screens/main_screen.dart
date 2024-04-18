import 'dart:async';
import 'dart:developer';

import 'package:audio_session/audio_session.dart';
import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:music_player/cubits/is%20player%20collapsed%20cubit/is_player_collapsed_cubit.dart';
import 'package:music_player/screens/home_screen.dart';
import 'package:music_player/screens/music_screen.dart';
import 'package:music_player/screens/search_screen.dart';
import 'package:music_player/screens/settings_screen.dart';
import 'package:music_player/utils/constatns.dart';
import 'package:music_player/utils/songs_player_provider.dart';
import 'package:music_player/widgets/collapsed_player.dart';
import 'package:music_player/widgets/expanded_player.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String appBarTitle = kmusicScreenAppBarTitle;
  int _currentPageIndex = 1;
  bool _isCollapsed = true;
  bool _isExpanded = false;
  bool canPop = false;
  final _bsbController = BottomSheetBarController();

  late StreamSubscription<Duration> _durationStream;

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    SongsPlayerProvider().player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
  }

  void _onBsbChanged() {
    if (_bsbController.isCollapsed && !_isCollapsed) {
      _isCollapsed = true;
      _isExpanded = false;
      BlocProvider.of<IsPlayerCollapsedCubit>(context).collapse();
    } else if (_bsbController.isExpanded && !_isExpanded) {
      _isCollapsed = false;
      _isExpanded = true;
      BlocProvider.of<IsPlayerCollapsedCubit>(context).extend();
    }
  }

  @override
  void initState() {
    _bsbController.addListener(_onBsbChanged);
    _durationStream =
        SongsPlayerProvider().listenToPositionStream((currentDuration) {
      if (!SongsPlayerProvider().hasNext() &&
          SongsPlayerProvider().currentDuration()! == currentDuration) {
        SongsPlayerProvider().seekTo(duration: Duration.zero, index: 0);
      }
    });
    // _init();

    super.initState();
  }

  @override
  void dispose() {
    _durationStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvoked: (didPop) {
        log('onPopInvoked');
        if (!BlocProvider.of<IsPlayerCollapsedCubit>(context).isCollapsed) {
          log('isCollapsed');
          _bsbController.collapse();
        } else if (SongsPlayerProvider().isPlaying()) {
          log('moveTaskToBack');
          MoveToBackground.moveTaskToBack();
        } else {
          log('pop');
          FlutterExitApp.exitApp();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          actions: [
            BlocBuilder<IsPlayerCollapsedCubit, bool>(
              builder: (context, isCollapsed) {
                return Visibility(
                  visible: !isCollapsed,
                  child: IconButton(
                    onPressed: () {
                      _bsbController.collapse();
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                );
              },
            )
          ],
        ),
        bottomNavigationBar: Theme(
          data: ThemeData(canvasColor: ksecondryColor),
          child: BottomNavigationBar(
            selectedItemColor: kdefaultTextColor,
            onTap: (index) {
              setState(() {
                if (index == 3) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return const SettingsScreen();
                    },
                  ));
                } else {
                  if (index == 0) {
                    appBarTitle = khomeScreenAppBarTitle;
                  } else if (index == 1) {
                    appBarTitle = kmusicScreenAppBarTitle;
                  } else if (index == 2) {
                    appBarTitle = ksearchScreenAppBarTitle;
                  }
                  _currentPageIndex = index;
                }
              });
            },
            currentIndex: _currentPageIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.music,
                ),
                label: 'Music',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.search,
                ),
                label: 'Settings',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.cog,
                ),
                label: 'Settings',
              ),
            ],
          ),
        ),
        body: BlocBuilder<IsPlayerCollapsedCubit, bool>(
          builder: (context, state) {
            return BottomSheetBar(
              height: 80,
              color: ksecondryColor,
              borderRadiusExpanded: const BorderRadius.all(Radius.zero),
              backdropColor:
                  const Color.fromARGB(255, 53, 53, 53).withOpacity(0.5),
              locked:
                  !BlocProvider.of<IsPlayerCollapsedCubit>(context).isCollapsed,
              controller: _bsbController,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0),
              ),
              expandedBuilder: (scrollController) {
                return const ExpandedPlayer();
              },
              collapsed: CollapsedPlayer(bsbController: _bsbController),
              body: [
                const HomeScreen(),
                const MusicScreen(),
                const SearchScreen(),
              ][_currentPageIndex],
            );
          },
        ),
      ),
    );
  }
}
