class AppointmentEntity {
  final String id;
  final String ownerId;
  final String petId;
  final DateTime date;
  final String reason;

  AppointmentEntity({
    required this.id,
    required this.ownerId,
    required this.petId,
    required this.date,
    required this.reason,
  });
}