part of 'level_gen_ui_cubit.dart';

abstract class LevelGenUiState extends Equatable {
  const LevelGenUiState({
    required this.showUI,
    required this.showSettings,
    this.tileset,
    this.totalTiles,
    required this.darkMode,
    required this.backgroundBeginColor,
    required this.backgroundEndColor,
    this.currentLayer = 0,
  });
  final bool showUI;
  final bool showSettings;
  final bool darkMode;
  final int currentLayer;
  final Color backgroundBeginColor;
  final Color backgroundEndColor;
  final SpriteSheet? tileset;
  final int? totalTiles;
}

class LevelGenUILoaded extends LevelGenUiState {
  const LevelGenUILoaded({
    required SpriteSheet tilesheet,
    required int totalTiles,
    required int currentLayer,
    required this.lastTileIndex,
    required bool darkMode,
    required Color backgroundBeginColor,
    required Color backgroundEndColor,
    required bool showSettings,
    this.resourceType = ResourceType.tile,
  }) : super(
          showUI: true,
          showSettings: showSettings,
          tileset: tilesheet,
          totalTiles: totalTiles,
          currentLayer: currentLayer,
          darkMode: darkMode,
          backgroundBeginColor: backgroundBeginColor,
          backgroundEndColor: backgroundEndColor,
        );
  final int lastTileIndex;
  final ResourceType resourceType;
  @override
  List<Object?> get props => [
        showUI,
        tileset,
        totalTiles,
        lastTileIndex,
        currentLayer,
        darkMode,
        backgroundBeginColor,
        backgroundEndColor,
        showSettings,
        resourceType,
      ];
}

class LevelGenUILoading extends LevelGenUiState {
  const LevelGenUILoading({
    required int currentLayer,
    required bool darkMode,
    required Color backgroundBegin,
    required Color backgroundEnd,
  }) : super(
          showUI: false,
          showSettings: false,
          currentLayer: currentLayer,
          darkMode: darkMode,
          backgroundBeginColor: backgroundBegin,
          backgroundEndColor: backgroundEnd,
        );
  final bool loading = true;
  @override
  List<Object?> get props => [showUI, tileset, totalTiles, loading, darkMode, backgroundBeginColor, backgroundEndColor];
}

class LevelGenUIHide extends LevelGenUiState {
  const LevelGenUIHide({
    required int currentLayer,
    required bool darkMode,
    required Color backgroundBegin,
    required Color backgroundEnd,
  }) : super(
          showUI: false,
          showSettings: false,
          currentLayer: currentLayer,
          darkMode: darkMode,
          backgroundBeginColor: backgroundBegin,
          backgroundEndColor: backgroundEnd,
        );
  @override
  List<Object?> get props => [showUI, tileset, totalTiles, darkMode, backgroundBeginColor, backgroundEndColor];
}
