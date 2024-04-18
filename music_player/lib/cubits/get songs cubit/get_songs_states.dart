// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:on_audio_query/on_audio_query.dart';

class GetSongsState {}

class GetSongsInitialState extends GetSongsState {}

class GetSongsLoadingState extends GetSongsState {}

class NoSongsState extends GetSongsState {}

class NoPermissonGivenForGetSongsState extends GetSongsState {}

class GetSongsSuccessfullyState extends GetSongsState {
  List<SongModel> songsList;
  GetSongsSuccessfullyState({
    required this.songsList,
  });
}

class GetSongsFailedState extends GetSongsState {
  final String errMessage;

  GetSongsFailedState({required this.errMessage});
}
