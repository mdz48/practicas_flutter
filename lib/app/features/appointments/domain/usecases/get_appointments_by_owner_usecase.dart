import 'package:noveno/app/features/appointments/domain/entities/appointment_entitty.dart';
import 'package:noveno/app/features/appointments/domain/repositories/appointment_repository.dart';

class GetAppointmentsByOwnerUseCase {
  final AppointmentRepository _repository;

  GetAppointmentsByOwnerUseCase(this._repository);

  Future<List<AppointmentEntity>> call(String ownerId) {
    return _repository.getAppointmentsByOwnerId(ownerId);
  }
}
