import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../../../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({required super.uid, super.email});

  factory UserModel.fromFirebaseUser(firebase.User firebaseUser) {
    return UserModel(uid: firebaseUser.uid, email: firebaseUser.email);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
    };
  }
}
