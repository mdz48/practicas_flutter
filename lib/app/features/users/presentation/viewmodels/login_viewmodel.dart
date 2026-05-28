import 'package:flutter/foundation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/check_security_usecase.dart';
import '../../domain/usecases/login_usecase.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final CheckSecurityUseCase _checkSecurityUseCase;

  LoginViewModel({
    required LoginUseCase loginUseCase,
    required CheckSecurityUseCase checkSecurityUseCase,
  })  : _loginUseCase = loginUseCase,
        _checkSecurityUseCase = checkSecurityUseCase;

  bool _isLoading = false;
  bool _isChecking = true;
  bool _isBlocked = false;
  String _errorMessage = '';
  UserEntity? _currentUser;

  bool get isLoading => _isLoading;
  bool get isChecking => _isChecking;
  bool get isBlocked => _isBlocked;
  String get errorMessage => _errorMessage;
  UserEntity? get currentUser => _currentUser;

  Future<void> checkSecurity() async {
    _isChecking = true;
    _isBlocked = false;
    _errorMessage = '';
    notifyListeners();

    try {
      await _checkSecurityUseCase();
      _isChecking = false;
    } catch (e) {
      _isChecking = false;
      _isBlocked = true;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _currentUser = await _loginUseCase(email, password);
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