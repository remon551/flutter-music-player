import 'package:flutter_bloc/flutter_bloc.dart';

class IsPlayerCollapsedCubit extends Cubit<bool> {
  IsPlayerCollapsedCubit() : super(true);
  bool isCollapsed = true;

  void collapse() {
    isCollapsed = true;
    emit(isCollapsed);
  }

  void extend() {
    isCollapsed = false;
    emit(isCollapsed);
  }
}
