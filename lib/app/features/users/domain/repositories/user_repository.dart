import 'package:noveno/app/features/users/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getUserById(String id);
  Future<UserEntity> createUser(String email, String password);
}