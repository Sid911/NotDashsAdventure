import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/ResourceType.dart';
import 'package:not_dashs_adventure/Utility/Repositories/TilesheetRepository.dart';

part './level_gen_ui_state.dart';

class LevelGenUiCubit extends Cubit<LevelGenUiState> {
  LevelGenUiCubit()
      : super(LevelGenUIHide(
          currentLayer: 0,
          darkMode: false,
          backgroundBegin: Colors.black,
          backgroundEnd: Colors.grey.shade900,
          puzzleLayer: 1,
        ));
  TilesheetRepository repository = TilesheetRepository();
  final Logger _logger = Logger("LeveL Generation UI");

  void toggleTile(int index) {
    emit(LevelGenUILoaded(
      tilesheet: state.tileset!,
      totalTiles: state.totalTiles!,
      lastTileIndex: index,
      currentLayer: (state as LevelGenUILoaded).currentLayer, // we know that this can only be called when ui is loaded,
      darkMode: state.darkMode, backgroundEndColor: state.backgroundEndColor,
      backgroundBeginColor: state.backgroundBeginColor,
      showSettings: false,
      resourceType: (state as LevelGenUILoaded).resourceType,
      puzzleLayer: state.puzzleLayer,
    ));
  }

  void loadUI() async {
    //loading UI
    emit(LevelGenUILoading(
      currentLayer: state.currentLayer,
      darkMode: state.darkMode,
      backgroundBegin: state.backgroundBeginColor,
      backgroundEnd: state.backgroundEndColor,
      puzzleLayer: state.puzzleLayer,
    ));
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
      darkMode: state.darkMode,
      backgroundBeginColor: state.darkMode ? Colors.white : Colors.black,
      backgroundEndColor: state.darkMode ? Colors.grey : Colors.grey.shade900,
      showSettings: state.showSettings,
      resourceType: ResourceType.tile,
      puzzleLayer: state.puzzleLayer,
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
          currentLayer: index,
          darkMode: currentState.darkMode,
          backgroundEndColor: currentState.backgroundEndColor,
          backgroundBeginColor: currentState.backgroundBeginColor,
          resourceType: currentState.resourceType,
          showSettings: false,
          puzzleLayer: currentState.puzzleLayer,
        ),
      );
      if (index == currentState.puzzleLayer) {
        setResourceType(ResourceType.puzzle, 0);
      }
      ;
    } else if (state is LevelGenUIHide) {
      emit(LevelGenUIHide(
          currentLayer: state.currentLayer,
          darkMode: state.darkMode,
          backgroundBegin: state.backgroundBeginColor,
          backgroundEnd: state.backgroundEndColor,
          puzzleLayer: state.puzzleLayer));
    } else {
      _logger.log(Level.INFO, "Current State is not loaded pls wait till it loads");
    }
  }

  void setDarkMode(bool value) {
    if (state is LevelGenUILoaded) {
      final currentState = state as LevelGenUILoaded;
      emit(LevelGenUILoaded(
        tilesheet: currentState.tileset!,
        totalTiles: currentState.totalTiles!,
        currentLayer: currentState.currentLayer,
        lastTileIndex: currentState.lastTileIndex,
        backgroundBeginColor: value ? Colors.white : Colors.black,
        backgroundEndColor: value ? Colors.grey : Colors.grey.shade900,
        darkMode: value,
        showSettings: currentState.showSettings,
        resourceType: currentState.resourceType,
        puzzleLayer: currentState.puzzleLayer,
      ));
    }
  }

  void setBackgroundGradientBeginColor(Color color) {
    if (state is LevelGenUILoaded) {
      final currentState = state as LevelGenUILoaded;
      emit(LevelGenUILoaded(
        tilesheet: currentState.tileset!,
        totalTiles: currentState.totalTiles!,
        currentLayer: currentState.currentLayer,
        lastTileIndex: currentState.lastTileIndex,
        backgroundBeginColor: color,
        backgroundEndColor: currentState.backgroundEndColor,
        darkMode: currentState.darkMode,
        showSettings: currentState.showSettings,
        resourceType: currentState.resourceType,
        puzzleLayer: currentState.puzzleLayer,
      ));
    }
  }

  void setBackgroundGradientEndColor(Color color) {
    if (state is LevelGenUILoaded) {
      final currentState = state as LevelGenUILoaded;
      emit(LevelGenUILoaded(
        tilesheet: currentState.tileset!,
        totalTiles: currentState.totalTiles!,
        currentLayer: currentState.currentLayer,
        lastTileIndex: currentState.lastTileIndex,
        backgroundBeginColor: currentState.backgroundBeginColor,
        backgroundEndColor: color,
        darkMode: currentState.darkMode,
        showSettings: currentState.showSettings,
        resourceType: currentState.resourceType,
        puzzleLayer: currentState.puzzleLayer,
      ));
    }
  }

  void hideSettings() {
    if (state is LevelGenUILoaded) {
      final currentState = state as LevelGenUILoaded;
      emit(
        LevelGenUILoaded(
          tilesheet: currentState.tileset!,
          totalTiles: currentState.totalTiles!,
          lastTileIndex: currentState.lastTileIndex,
          currentLayer: currentState.currentLayer,
          darkMode: currentState.darkMode,
          backgroundEndColor: currentState.backgroundEndColor,
          backgroundBeginColor: currentState.backgroundBeginColor,
          resourceType: currentState.resourceType,
          showSettings: false,
          puzzleLayer: currentState.puzzleLayer,
        ),
      );
    }
  }

  void showSettings() {
    if (state is LevelGenUILoaded) {
      final currentState = state as LevelGenUILoaded;
      emit(
        LevelGenUILoaded(
          tilesheet: currentState.tileset!,
          totalTiles: currentState.totalTiles!,
          lastTileIndex: currentState.lastTileIndex,
          currentLayer: currentState.currentLayer,
          darkMode: currentState.darkMode,
          backgroundEndColor: currentState.backgroundEndColor,
          backgroundBeginColor: currentState.backgroundBeginColor,
          showSettings: true,
          resourceType: currentState.resourceType,
          puzzleLayer: currentState.puzzleLayer,
        ),
      );
    }
  }

  void setResourceType(ResourceType type, int initialIndex) {
    if (state is LevelGenUILoaded) {
      final currentState = state as LevelGenUILoaded;
      emit(LevelGenUILoaded(
        tilesheet: currentState.tileset!,
        totalTiles: currentState.totalTiles!,
        lastTileIndex: initialIndex,
        currentLayer: currentState.currentLayer,
        darkMode: currentState.darkMode,
        backgroundEndColor: currentState.backgroundEndColor,
        backgroundBeginColor: currentState.backgroundBeginColor,
        showSettings: currentState.showSettings,
        resourceType: type,
        puzzleLayer: currentState.puzzleLayer,
      ));
    }
  }

  void setPuzzleLayer(int layer) {
    if (state is LevelGenUILoaded) {
      final currentState = state as LevelGenUILoaded;
      emit(LevelGenUILoaded(
        tilesheet: currentState.tileset!,
        totalTiles: currentState.totalTiles!,
        lastTileIndex: currentState.lastTileIndex,
        currentLayer: currentState.currentLayer,
        darkMode: currentState.darkMode,
        backgroundEndColor: currentState.backgroundEndColor,
        backgroundBeginColor: currentState.backgroundBeginColor,
        showSettings: currentState.showSettings,
        resourceType: currentState.resourceType,
        puzzleLayer: layer,
      ));
    } else if (state is LevelGenUIHide) {
      emit(LevelGenUIHide(
        currentLayer: state.currentLayer,
        darkMode: state.darkMode,
        backgroundBegin: state.backgroundBeginColor,
        backgroundEnd: state.backgroundEndColor,
        puzzleLayer: layer,
      ));
    }
  }

  void hideUI() {
    emit(
      LevelGenUIHide(
        currentLayer: state.currentLayer,
        darkMode: state.darkMode,
        backgroundBegin: state.backgroundBeginColor,
        backgroundEnd: state.backgroundEndColor,
        puzzleLayer: state.puzzleLayer,
      ),
    );
  }
}
