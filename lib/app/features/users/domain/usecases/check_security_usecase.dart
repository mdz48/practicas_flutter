import '../repositories/security_repository.dart';

class CheckSecurityUseCase {
  final SecurityRepository _repository;

  CheckSecurityUseCase(this._repository);

  Future<void> call() async {
    await _repository.checkSecurity();
  }
}

