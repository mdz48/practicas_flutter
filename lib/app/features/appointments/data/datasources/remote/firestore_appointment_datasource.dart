import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noveno/app/features/appointments/data/models/appointment_model.dart';

class FirestoreAppointmentDatasource {
  final FirebaseFirestore _firestore;

  FirestoreAppointmentDatasource({required FirebaseFirestore firestore})
    : _firestore = firestore;

  CollectionReference get _appointmentsCollection =>
      _firestore.collection('appointments');

  Future<List<AppointmentModel>> getAppointmentsByOwnerId(
    String ownerId,
  ) async {
    final querySnapshot = await _appointmentsCollection
        .where('ownerId', isEqualTo: ownerId)
        .get();

    return querySnapshot.docs
        .map((doc) => AppointmentModel.fromFirestore(doc))
        .toList();
  }

  Future<AppointmentModel> createAppointment(
    AppointmentModel appointment,
  ) async {
    final docRef = await _appointmentsCollection.add(appointment.toJson());

    final createdDoc = await docRef.get();
    return AppointmentModel.fromFirestore(createdDoc);
  }
}
