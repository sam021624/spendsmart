import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NavState {}

class NavOnboarding extends NavState {}

class NavHome extends NavState {}

class NavSettings extends NavState {}

class NavProfile extends NavState {}

class NavCubit extends Cubit<NavState> {
  NavCubit() : super(NavHome());

  void showOnboarding() => emit(NavOnboarding());
}
