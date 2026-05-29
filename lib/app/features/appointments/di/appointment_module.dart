import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noveno/app/features/appointments/data/datasources/remote/firestore_appointment_datasource.dart';
import 'package:noveno/app/features/appointments/data/datasources/repositories/appointment_repository_impl.dart';
import 'package:noveno/app/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:noveno/app/features/appointments/domain/usecases/create_appointment.dart';
import 'package:noveno/app/features/appointments/domain/usecases/get_appointments_by_owner_usecase.dart';

class AppointmentModule {
  late final AppointmentRepository appointmentRepository;
  late final CreateAppointment createAppointmentUseCase;
  late final GetAppointmentsByOwnerUseCase getAppointmentsByOwnerUseCase;

  AppointmentModule({required FirebaseFirestore firestore}) {
    final datasource = FirestoreAppointmentDatasource(firestore: firestore);
    appointmentRepository = AppointmentRepositoryImpl(datasource);
    createAppointmentUseCase = CreateAppointment(appointmentRepository);
    getAppointmentsByOwnerUseCase = GetAppointmentsByOwnerUseCase(appointmentRepository);
  }
}
