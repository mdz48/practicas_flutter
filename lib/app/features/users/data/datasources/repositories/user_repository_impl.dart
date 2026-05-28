import 'package:noveno/app/features/users/data/datasources/remote/firebase_auth_datasource.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuthDatasource _firebaseAuthDatasource;

  UserRepositoryImpl(this._firebaseAuthDatasource);

  @override
  Future<UserEntity> getUserById(String id) {
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> createUser(String email, String password) {
    return _firebaseAuthDatasource.createUserWithEmailAndPassword(
      email,
      password,
    );
  }
}