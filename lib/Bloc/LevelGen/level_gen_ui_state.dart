part of 'level_gen_ui_cubit.dart';

abstract class LevelGenUiState extends Equatable {
  const LevelGenUiState({
    required this.showUI,
    this.tileset,
    this.totalTiles,
    this.toggleBlocksList,
  });
  final bool showUI;
  final SpriteSheet? tileset;
  final int? totalTiles;
  final List<bool>? toggleBlocksList;
}

class LevelGenUILoaded extends LevelGenUiState {
  const LevelGenUILoaded({
    required SpriteSheet tilesheet,
    required int totalTiles,
    required List<bool> blocksToggleList,
    this.lastIndex,
  }) : super(
          showUI: true,
          toggleBlocksList: blocksToggleList,
          tileset: tilesheet,
          totalTiles: totalTiles,
        );
  final int? lastIndex;
  @override
  List<Object> get props => [showUI, tileset!, totalTiles!];
}

class LevelGenUILoading extends LevelGenUiState {
  const LevelGenUILoading()
      : super(
          showUI: false,
        );

  @override
  List<Object?> get props => [showUI, tileset, totalTiles];
}

class LevelGenUIHide extends LevelGenUiState {
  const LevelGenUIHide() : super(showUI: false);
  @override
  List<Object?> get props => [showUI, tileset, totalTiles];
}
