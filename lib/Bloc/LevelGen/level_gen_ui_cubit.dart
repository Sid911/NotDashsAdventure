import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flame/sprite.dart';
import 'package:logging/logging.dart';
import 'package:not_dashs_adventure/Utility/Repositories/TilesheetRepository.dart';

part './level_gen_ui_state.dart';

class LevelGenUiCubit extends Cubit<LevelGenUiState> {
  LevelGenUiCubit() : super(const LevelGenUIHide(currentLayer: 0));
  TilesheetRepository repository = TilesheetRepository();
  final Logger _logger = Logger("LeveL Genration UI");

  void toggleTile(int index) {
    emit(LevelGenUILoaded(
      tilesheet: state.tileset!,
      totalTiles: state.totalTiles!,
      lastTileIndex: index,
      currentLayer: (state as LevelGenUILoaded).currentLayer, // we know that this can only be called when ui is loaded,
    ));
  }

  void loadUI() async {
    //loading UI
    emit(LevelGenUILoading(currentLayer: state.currentLayer));
    final tilesheet = await repository.getTileSheet();
    final totalTiles = repository.currentTilesheetLog!.recommendedTilesList.length;
    final blocksToggleList = List<bool>.filled(totalTiles, false);
    blocksToggleList.first = true;
    // UI loaded
    emit(LevelGenUILoaded(
      tilesheet: tilesheet!,
      totalTiles: totalTiles,
      lastTileIndex: 0,
      currentLayer: state.currentLayer,
    ));
  }

  void setLayerIndex(int index) {
    if (state is LevelGenUILoaded) {
      final currentState = state as LevelGenUILoaded;
      emit(
        LevelGenUILoaded(
            tilesheet: currentState.tileset!,
            totalTiles: currentState.totalTiles!,
            lastTileIndex: currentState.lastTileIndex,
            currentLayer: index),
      );
    } else {
      _logger.log(Level.INFO, "Current State is not loaded pls wait till it loads");
    }
  }

  void hideUI() {
    print(state.currentLayer);
    emit(LevelGenUIHide(currentLayer: state.currentLayer));
  }
}
