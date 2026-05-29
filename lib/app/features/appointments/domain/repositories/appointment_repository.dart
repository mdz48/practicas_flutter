import 'package:noveno/app/features/appointments/domain/entities/appointment_entitty.dart';

abstract class AppointmentRepository {
  Future<AppointmentEntity> getAppointmentById(String id);
  Future<List<AppointmentEntity>> getAppointmentsByOwnerId(String ownerId);
  Future<AppointmentEntity> createAppointment(AppointmentEntity appointment);
  Future<AppointmentEntity> updateAppointment(AppointmentEntity appointment);
  Future<void> deleteAppointment(String id);
}
