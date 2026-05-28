import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../remote/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource _remoteDatasource;

  AuthRepositoryImpl(this._remoteDatasource);

  @override
  Future<UserEntity> signInWithEmailAndPassword(
    String email,
    String password,
  ) {
    return _remoteDatasource.signInWithEmailAndPassword(email, password);
  }
}
