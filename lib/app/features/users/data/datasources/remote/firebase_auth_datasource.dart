import 'package:firebase_auth/firebase_auth.dart';
import 'models/user_model.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class FirebaseAuthDatasource {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDatasource({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw AuthException('Usuario no encontrado.');
      }
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      String message = 'Ocurrió un error al iniciar sesión.';
      if (e.code == 'user-not-found') {
        message = 'Usuario no encontrado.';
      } else if (e.code == 'wrong-password') {
        message = 'Contraseña incorrecta.';
      } else if (e.code == 'invalid-email') {
        message = 'Correo electrónico no válido.';
      } else if (e.code == 'invalid-credential') {
        message = 'Credenciales incorrectas.';
      }
      throw AuthException(message);
    } catch (e) {
      throw AuthException('Error: ${e.toString()}');
    }
  }

  Future<UserModel> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw AuthException('No se pudo registrar el usuario.');
      }
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      String message = 'Ocurrió un error al registrar el usuario.';
      if (e.code == 'weak-password') {
        message = 'La contraseña ingresada es muy débil.';
      } else if (e.code == 'email-already-in-use') {
        message = 'El correo electrónico ya está registrado.';
      } else if (e.code == 'invalid-email') {
        message = 'El correo electrónico no es válido.';
      }
      throw AuthException(message);
    } catch (e) {
      throw AuthException('Error: ${e.toString()}');
    }
  }
}
