import 'package:flutter/material.dart';
import 'package:noveno/app/core/di/app_container.dart';
import 'package:noveno/app/features/appointments/presentation/screens/add_appoinment_page.dart';
import 'package:noveno/app/features/appointments/presentation/viewmodels/add_appointment_viewmodel.dart';
import 'package:noveno/app/features/appointments/presentation/viewmodels/appointments_viewmodel.dart';
import 'package:provider/provider.dart';

class AppointmentsPage extends StatefulWidget {
  final String ownerId;

  const AppointmentsPage({super.key, required this.ownerId});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentsViewModel>().getAppointments(widget.ownerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppointmentsViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Appointments')),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.appointments.isEmpty
          ? const Center(child: Text('No hay citas registradas.'))
          : ListView.builder(
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
              builder: (context) =>
                  ChangeNotifierProvider<AddAppointmentViewmodel>(
                    create: (context) => AddAppointmentViewmodel(
                      createAppointmentUseCase: appContainer
                          .appointmentModule
                          .createAppointmentUseCase,
                    ),
                    child: AddAppoinmentPage(ownerId: widget.ownerId),
                  ),
            ),
          ).then((value) {
            if (value == true) {
              context.read<AppointmentsViewModel>().getAppointments(
                widget.ownerId,
              );
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
