import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:noveno/app/features/appointments/di/appointment_module.dart';
import 'package:noveno/app/features/users/di/users_module.dart';

class AppContainer {
  late final UsersModule usersModule;
  late final AppointmentModule appointmentModule;

  AppContainer() {
    final firebaseAuth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    usersModule = UsersModule(firebaseAuth: firebaseAuth);
    appointmentModule = AppointmentModule(firestore: firestore);
  }
}
