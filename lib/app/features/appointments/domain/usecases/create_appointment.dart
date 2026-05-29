import 'package:noveno/app/features/appointments/domain/entities/appointment_entitty.dart';
import 'package:noveno/app/features/appointments/domain/repositories/appointment_repository.dart';

class CreateAppointment {
  final AppointmentRepository _repository;

  CreateAppointment(this._repository);

  Future<AppointmentEntity> execute(AppointmentEntity appointment) async {
    return await _repository.createAppointment(appointment);
  }
}
