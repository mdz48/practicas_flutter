import 'package:flutter/material.dart';
import 'package:noveno/app/features/appointments/domain/entities/appointment_entitty.dart';
import 'package:noveno/app/features/appointments/domain/usecases/create_appointment.dart';

class AddAppointmentViewmodel extends ChangeNotifier {
  final CreateAppointment _createAppointmentUseCase;

  AddAppointmentViewmodel({required CreateAppointment createAppointmentUseCase})
    : _createAppointmentUseCase = createAppointmentUseCase;

  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<bool> addAppointment({
    required String ownerId,
    required String petName,
    required DateTime date,
    required String reason,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final appointment = AppointmentEntity(
        id: '',
        ownerId: ownerId,
        petName: petName,
        date: date,
        reason: reason,
      );

      await _createAppointmentUseCase.execute(appointment);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
