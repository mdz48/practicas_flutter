import 'package:flutter/material.dart';

enum MagicState { initial, searching, found, notFound }

class MagicProvider with ChangeNotifier {
  static const int _minRange = 1;
  static const int _maxRange = 100;
  static const int _maxAttempts = 7;

  MagicState _state = MagicState.initial;
  int _low = _minRange;
  int _high = _maxRange;
  int _currentGuess = 0;
  int _attempts = 0;
  int _targetNumber = 0;
  List<int> _guessHistory = [];

  MagicState get state => _state;
  int get currentGuess => _currentGuess;
  int get attempts => _attempts;
  int get targetNumber => _targetNumber;
  List<int> get guessHistory => List.unmodifiable(_guessHistory);
  bool get canSearch => _state == MagicState.initial;

  void startSearch(int target) {
    if (target < _minRange || target > _maxRange) return;

    _targetNumber = target;
    _low = _minRange;
    _high = _maxRange;
    _attempts = 0;
    _guessHistory = [];
    _state = MagicState.searching;

    _performStep();
  }

  void _performStep() {
    if (_attempts >= _maxAttempts || _low > _high) {
      _state = MagicState.notFound;
      notifyListeners();
      return;
    }

    _currentGuess = (_low + _high) ~/ 2;
    _attempts++;
    _guessHistory.add(_currentGuess);

    if (_currentGuess == _targetNumber) {
      _state = MagicState.found;
    } else if (_currentGuess < _targetNumber) {
      _low = _currentGuess + 1;
    } else {
      _high = _currentGuess - 1;
    }

    notifyListeners();

    if (_state == MagicState.searching) {
      Future.delayed(const Duration(milliseconds: 600), () {
        _performStep();
      });
    }
  }

  void reset() {
    _state = MagicState.initial;
    _low = _minRange;
    _high = _maxRange;
    _currentGuess = 0;
    _attempts = 0;
    _targetNumber = 0;
    _guessHistory = [];
    notifyListeners();
  }
}
