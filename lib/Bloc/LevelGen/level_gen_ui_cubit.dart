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
    List<bool>? currentToggleList = state.toggleBlocksList;
    currentToggleList ??= List<bool>.filled(state.totalTiles!, false);
    currentToggleList[index] = true;
    // error area
    if (state is LevelGenUILoaded) {
      final newState = state as LevelGenUILoaded;
      currentToggleList[newState.lastIndex] = false;
    }
    emit(LevelGenUILoaded(
      tilesheet: state.tileset!,
      totalTiles: state.totalTiles!,
      blocksToggleList: currentToggleList,
      lastIndex: index,
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
      blocksToggleList: blocksToggleList,
      lastIndex: 0,
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
            blocksToggleList: state.toggleBlocksList!,
            lastIndex: currentState.lastIndex,
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
