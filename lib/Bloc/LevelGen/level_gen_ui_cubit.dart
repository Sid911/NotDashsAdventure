import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flame/sprite.dart';
import 'package:logging/logging.dart';
import 'package:not_dashs_adventure/Utility/Repositories/TilesheetRepository.dart';

part './level_gen_ui_state.dart';

class LevelGenUiCubit extends Cubit<LevelGenUiState> {
  LevelGenUiCubit() : super(const LevelGenUIHide());
  TilesheetRepository repository = TilesheetRepository();
  final Logger _logger = Logger("LeveL Genration UI");

  void toggle(int index) {
    List<bool>? currentToggleList = state.toggleBlocksList;
    currentToggleList ??= List<bool>.filled(state.totalTiles!, false);
    currentToggleList[index] = true;
    // error area
    if (state is LevelGenUILoaded) {
      final newState = state as LevelGenUILoaded;
      assert(newState.lastIndex == null);
      currentToggleList[newState.lastIndex!] = false;
    }
  }

  void loadUI() async {
    _logger.log(Level.FINE, "loadUI : Loading the UI");
    //loading UI
    emit(const LevelGenUILoading());
    final tilesheet = await repository.getTileSheet();
    final totalTiles = tilesheet!.columns * tilesheet.rows;
    final blocksToggleList = List<bool>.filled(totalTiles, false);
    blocksToggleList.first = true;
    // UI loaded
    _logger.log(Level.FINE, "loadUI : Emitting LevelGenUI Loaded");
    emit(LevelGenUILoaded(
      tilesheet: tilesheet,
      totalTiles: totalTiles,
      blocksToggleList: blocksToggleList,
      lastIndex: 0,
    ));
  }

  void hideUI() {
    emit(const LevelGenUIHide());
  }
}
