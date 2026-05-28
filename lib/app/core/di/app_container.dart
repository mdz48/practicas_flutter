import 'package:firebase_auth/firebase_auth.dart';
import 'package:noveno/app/features/users/di/users_module.dart';

class AppContainer {
  late final UsersModule usersModule;

  AppContainer() {
    final firebaseAuth = FirebaseAuth.instance;

    usersModule = UsersModule(firebaseAuth: firebaseAuth);
  }
}
