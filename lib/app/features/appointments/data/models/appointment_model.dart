import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noveno/app/features/appointments/domain/entities/appointment_entitty.dart';

class AppointmentModel extends AppointmentEntity {
  AppointmentModel({
    required super.id,
    required super.ownerId,
    required super.petName,
    required super.date,
    required super.reason,
  });

  factory AppointmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppointmentModel(
      id: doc.id,
      ownerId: data['ownerId'] ?? '',
      petName: data['petName'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      reason: data['reason'] ?? '',
    );
  }

  factory AppointmentModel.fromEntity(AppointmentEntity entity) {
    return AppointmentModel(
      id: entity.id,
      ownerId: entity.ownerId,
      petName: entity.petName,
      date: entity.date,
      reason: entity.reason,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ownerId': ownerId,
      'petName': petName,
      'date': Timestamp.fromDate(date),
      'reason': reason,
    };
  }
}