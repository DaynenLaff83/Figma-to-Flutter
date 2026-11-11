
import 'package:flutter/foundation.dart';

import '../data/attraction_repository.dart';
import '../models/attraction.dart';

class AttractionsViewModel extends ChangeNotifier {
  final AttractionRepository _repository = AttractionRepository();

  List<Attraction> _attractions = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _maxScareLevel = 3; // Start by showing every haunt

  List<Attraction> get attractions =>
      List.unmodifiable(_attractions);

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;
  int get maxScareLevel => _maxScareLevel;

// Only show haunts at or below the selected scare level
List<Attraction> get visibleAttractions => _attractions
    .where((attraction) => attraction.scareLevel <= _maxScareLevel)
    .toList();
  

  Future<void> loadAttractions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _attractions = await _repository.loadAttractions();
    } catch (error) {
      _errorMessage = 'Could not load the haunts: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // Update the maximum scare level selected by the user
void setMaxScareLevel(int level) {
  _maxScareLevel = level;
  notifyListeners();
}
}
