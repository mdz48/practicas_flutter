class AppointmentEntity {
  final String id;
  final String ownerId;
  final String petName;
  final DateTime date;
  final String reason;

  AppointmentEntity({
    required this.id,
    required this.ownerId,
    required this.petName,
    required this.date,
    required this.reason,
  });
}