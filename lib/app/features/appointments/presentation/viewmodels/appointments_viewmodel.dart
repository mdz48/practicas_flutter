import 'package:flutter/foundation.dart';
import 'package:noveno/app/features/appointments/domain/entities/appointment_entitty.dart';

import '../../domain/usecases/get_appointments_by_owner_usecase.dart';

class AppointmentsViewModel extends ChangeNotifier {
  final GetAppointmentsByOwnerUseCase _getAppointmentsByOwnerUseCase;

  AppointmentsViewModel({
    required GetAppointmentsByOwnerUseCase getAppointmentsByOwnerUseCase,
  }) : _getAppointmentsByOwnerUseCase = getAppointmentsByOwnerUseCase;

  List<AppointmentEntity> _appointments = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<AppointmentEntity> get appointments => _appointments;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> getAppointments(String ownerId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _appointments = await _getAppointmentsByOwnerUseCase(ownerId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
