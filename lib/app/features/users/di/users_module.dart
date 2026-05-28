import 'package:firebase_auth/firebase_auth.dart';
import '../data/datasources/remote/firebase_auth_datasource.dart';
import '../data/datasources/repositories/auth_repository_impl.dart';
import '../data/datasources/repositories/user_repository_impl.dart';
import '../data/datasources/repositories/security_repository_impl.dart';
import '../domain/usecases/check_security_usecase.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/register_usecase.dart';

class UsersModule {
  late final FirebaseAuthDatasource _firebaseAuthDatasource;
  late final AuthRepositoryImpl _authRepository;
  late final UserRepositoryImpl userRepository;
  late final SecurityRepositoryImpl _securityRepository;
  late final LoginUseCase loginUseCase;
  late final RegisterUseCase registerUseCase;
  late final CheckSecurityUseCase checkSecurityUseCase;

  UsersModule({required FirebaseAuth firebaseAuth}) {
    _firebaseAuthDatasource = FirebaseAuthDatasource(
      firebaseAuth: firebaseAuth,
    );
    _authRepository = AuthRepositoryImpl(_firebaseAuthDatasource);
    userRepository = UserRepositoryImpl(_firebaseAuthDatasource);
    _securityRepository = SecurityRepositoryImpl();
    loginUseCase = LoginUseCase(_authRepository);
    registerUseCase = RegisterUseCase(userRepository);
    checkSecurityUseCase = CheckSecurityUseCase(_securityRepository);
  }
}

