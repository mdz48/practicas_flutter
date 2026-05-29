import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noveno/app/features/appointments/domain/entities/appointment_entitty.dart';

class AppointmentModel extends AppointmentEntity {
  AppointmentModel({
    required super.id,
    required super.ownerId,
    required super.petId,
    required super.date,
    required super.reason,
  });

  factory AppointmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppointmentModel(
      id: doc.id,
      ownerId: data['ownerId'] ?? '',
      petId: data['petId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      reason: data['reason'] ?? '',
    );
  }

  factory AppointmentModel.fromEntity(AppointmentEntity entity) {
    return AppointmentModel(
      id: entity.id,
      ownerId: entity.ownerId,
      petId: entity.petId,
      date: entity.date,
      reason: entity.reason,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ownerId': ownerId,
      'petId': petId,
      'date': Timestamp.fromDate(date),
      'reason': reason,
    };
  }
}