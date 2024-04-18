import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleCubitObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('change is: $change');
  }
}
