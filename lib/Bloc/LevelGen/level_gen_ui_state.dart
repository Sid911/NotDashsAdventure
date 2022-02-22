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
    required this.lastIndex,
    required this.currentLayer,
  }) : super(
          showUI: true,
          toggleBlocksList: blocksToggleList,
          tileset: tilesheet,
          totalTiles: totalTiles,
        );
  final int lastIndex;
  final int currentLayer;
  @override
  List<Object?> get props => [showUI, tileset, totalTiles, toggleBlocksList, lastIndex, currentLayer];
}

class LevelGenUILoading extends LevelGenUiState {
  const LevelGenUILoading()
      : super(
          showUI: false,
        );
  final bool loading = true;
  @override
  List<Object?> get props => [showUI, tileset, totalTiles, toggleBlocksList, loading];
}

class LevelGenUIHide extends LevelGenUiState {
  const LevelGenUIHide() : super(showUI: false);
  @override
  List<Object?> get props => [showUI, tileset, totalTiles, toggleBlocksList];
}
