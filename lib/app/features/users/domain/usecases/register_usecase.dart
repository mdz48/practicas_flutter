import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class RegisterUseCase {
  final UserRepository _repository;

  RegisterUseCase(this._repository);

  Future<UserEntity> call(String email, String password) {
    return _repository.createUser(email, password);
  }
}
