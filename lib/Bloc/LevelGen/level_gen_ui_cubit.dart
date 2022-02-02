import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part './level_gen_ui_state.dart';

class LevelGenUiCubit extends Cubit<LevelGenUiState> {
  LevelGenUiCubit() : super(const LevelGenUiShow());

  void showUI() {
    emit(const LevelGenUiShow());
  }

  void hideUI() {
    emit(const LevelGenUIHide());
  }
}
