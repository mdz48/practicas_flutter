import 'package:flutter/foundation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/register_usecase.dart';

class RegisterViewModel with ChangeNotifier {
  final RegisterUseCase _registerUseCase;

  RegisterViewModel({required RegisterUseCase registerUseCase})
      : _registerUseCase = registerUseCase;

  bool _isLoading = false;
  String _errorMessage = '';
  UserEntity? _createdUser;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  UserEntity? get createdUser => _createdUser;

  Future<bool> register(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _createdUser = await _registerUseCase(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
