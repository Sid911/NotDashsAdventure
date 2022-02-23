part of 'level_gen_ui_cubit.dart';

abstract class LevelGenUiState extends Equatable {
  const LevelGenUiState(
      {required this.showUI, this.tileset, this.totalTiles, this.toggleBlocksList, this.currentLayer = 0});
  final bool showUI;
  final int currentLayer;
  final SpriteSheet? tileset;
  final int? totalTiles;
  final List<bool>? toggleBlocksList;
}

class LevelGenUILoaded extends LevelGenUiState {
  const LevelGenUILoaded({
    required SpriteSheet tilesheet,
    required int totalTiles,
    required int currentLayer,
    required List<bool> blocksToggleList,
    required this.lastIndex,
  }) : super(
            showUI: true,
            toggleBlocksList: blocksToggleList,
            tileset: tilesheet,
            totalTiles: totalTiles,
            currentLayer: currentLayer);
  final int lastIndex;
  @override
  List<Object?> get props => [showUI, tileset, totalTiles, toggleBlocksList, lastIndex, currentLayer];
}

class LevelGenUILoading extends LevelGenUiState {
  const LevelGenUILoading({required int currentLayer})
      : super(
          showUI: false,
          currentLayer: currentLayer,
        );
  final bool loading = true;
  @override
  List<Object?> get props => [showUI, tileset, totalTiles, toggleBlocksList, loading];
}

class LevelGenUIHide extends LevelGenUiState {
  const LevelGenUIHide({required int currentLayer}) : super(showUI: false, currentLayer: currentLayer);
  @override
  List<Object?> get props => [showUI, tileset, totalTiles, toggleBlocksList];
}
