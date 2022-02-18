import 'package:logging/logging.dart';
import 'package:not_dashs_adventure/Utility/VectorInt.dart';

class DesignerGameState {
  DesignerGameState({this.size = 20}) {
    baseMatrix = List.generate(size, (_) => List.generate(size, (_) => 0));
    highLightMatrix = List.generate(size, (index) => List.generate(size, (_) => -1));
    highLightMatrix[0][0] = 115;
  }
  final _logger = Logger("DesignerGameState");

  int size;
  Vector2Int lastHighlight = Vector2Int(x: 0, y: 0);
  late List<List<int>> baseMatrix;
  late List<List<int>> highLightMatrix;
  void toggleIndex(Vector2Int location, int replacingIndex) {
    if (location.x >= 0 && location.x <= baseMatrix[0].length && location.y >= 0 && location.y <= baseMatrix.length) {
      _logger.log(Level.INFO, "Index : $replacingIndex");
      baseMatrix[location.y][location.x] = replacingIndex;
      highLightMatrix[lastHighlight.y][lastHighlight.x] = -1;
      highLightMatrix[location.y][location.x] = 115;
      lastHighlight = Vector2Int(x: location.x, y: location.y);
    }
  }
}
