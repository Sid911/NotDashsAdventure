part of 'level_gen_ui_cubit.dart';

abstract class LevelGenUiState extends Equatable {
  const LevelGenUiState({required this.showUI});
  final bool showUI;
}

class LevelGenUiShow extends LevelGenUiState {
  const LevelGenUiShow() : super(showUI: true);

  // int totalTiles;
  // int lastIndex;
  //
  @override
  List<Object> get props => [showUI];
}

class LevelGenUIHide extends LevelGenUiState {
  const LevelGenUIHide() : super(showUI: false);
  @override
  List<Object?> get props => [showUI];
}
