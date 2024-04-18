import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/cubits/get%20songs%20cubit/get_songs_states.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class GetSongsCubit extends Cubit<GetSongsState> {
  GetSongsCubit() : super(GetSongsInitialState());
  List<SongModel> songsList = [];

  void getSongs() async {
    if (await Permission.storage.isGranted) {
      emit(GetSongsLoadingState());
      try {
        final OnAudioQuery audioQuery = OnAudioQuery();
        songsList = await audioQuery.querySongs();
        if (songsList.isEmpty) {
          emit(NoSongsState());
        } else {
          emit(GetSongsSuccessfullyState(songsList: songsList));
        }
      } catch (e) {
        emit(GetSongsFailedState(errMessage: e.toString()));
      }
    } else {
      emit(NoPermissonGivenForGetSongsState());
    }
  }
}
