

import 'package:flutter/material.dart';
import 'package:noveno/app/core/di/app_container.dart';
import 'package:noveno/app/features/appointments/presentation/screens/add_appoinment_page.dart';
import 'package:noveno/app/features/appointments/presentation/viewmodels/add_appointment_viewmodel.dart';
import 'package:noveno/app/features/appointments/presentation/viewmodels/appointments_viewmodel.dart';
import 'package:provider/provider.dart';

class AppointmentsPage extends StatelessWidget {
  final String ownerId;

  const AppointmentsPage({super.key, required this.ownerId});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppointmentsViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Appointments')),
      body: ListView.builder(
        itemCount: viewModel.appointments.length,
        itemBuilder: (context, index) {
          final appointment = viewModel.appointments[index];
          return ListTile(
            title: Text(appointment.reason),
            subtitle: Text(appointment.date.toString()),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final appContainer = context.read<AppContainer>();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider<AddAppointmentViewmodel>(
                create: (context) => AddAppointmentViewmodel(
                  createAppointmentUseCase:
                      appContainer.appointmentModule.createAppointmentUseCase,
                ),
                child: AddAppoinmentPage(ownerId: ownerId),
              ),
            ),
          ).then((value) {
            if (value == true) {
              viewModel.getAppointments(ownerId);
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}