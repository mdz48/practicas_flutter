import 'package:noveno/app/features/appointments/data/datasources/remote/firestore_appointment_datasource.dart';
import 'package:noveno/app/features/appointments/data/models/appointment_model.dart';
import 'package:noveno/app/features/appointments/domain/entities/appointment_entitty.dart';
import 'package:noveno/app/features/appointments/domain/repositories/appointment_repository.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final FirestoreAppointmentDatasource _datasource;

  AppointmentRepositoryImpl(this._datasource);

  @override
  Future<AppointmentEntity> getAppointmentById(String id) {
    // TODO: implement getAppointmentById
    throw UnimplementedError();
  }

  @override
  Future<List<AppointmentEntity>> getAppointmentsByOwnerId(
      String ownerId) async {
    return await _datasource.getAppointmentsByOwnerId(ownerId);
  }

  @override
  Future<AppointmentEntity> createAppointment(
      AppointmentEntity appointment) async {
    final model = AppointmentModel.fromEntity(appointment);
    return await _datasource.createAppointment(model);
  }

  @override
  Future<AppointmentEntity> updateAppointment(
      AppointmentEntity appointment) {
    // TODO: implement updateAppointment
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAppointment(String id) {
    // TODO: implement deleteAppointment
    throw UnimplementedError();
  }
}