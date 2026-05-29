import 'package:flutter/material.dart';
import 'package:no_screenshot/overlay_mode.dart';
import 'package:no_screenshot/secure_widget.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/app_container.dart';
import '../viewmodels/login_viewmodel.dart';
import '../viewmodels/register_viewmodel.dart';
import 'register.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:noveno/app/features/appointments/presentation/screens/appointments_page.dart';
import 'package:noveno/app/features/appointments/presentation/viewmodels/appointments_viewmodel.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final viewModel = context.read<LoginViewModel>();
    final success = await viewModel.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      final user = viewModel.currentUser;
      final appContainer = context.read<AppContainer>();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<AppointmentsViewModel>(
            create: (_) => AppointmentsViewModel(
              getAppointmentsByOwnerUseCase:
                  appContainer.appointmentModule.getAppointmentsByOwnerUseCase,
            ),
            child: AppointmentsPage(ownerId: user?.uid ?? ''),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logoPath = isDark
        ? 'assets/images/white_logo.svg'
        : 'assets/images/black_logo.svg';

    if (viewModel.isChecking) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.isBlocked) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'Acceso Denegado',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(viewModel.errorMessage, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: viewModel.checkSecurity,
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SecureWidget(
      mode: OverlayMode.secure,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        constraints: const BoxConstraints(maxWidth: 350),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  heightFactor: 0.65,
                  child: SvgPicture.asset(logoPath),
                ),
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingresa tu correo' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Ingresa tu contraseña'
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: viewModel.isLoading ? null : _submitForm,
                child: const Text('Iniciar Sesión'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  final appContainer = context.read<AppContainer>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChangeNotifierProvider<RegisterViewModel>(
                            create: (_) => RegisterViewModel(
                              registerUseCase:
                                  appContainer.usersModule.registerUseCase,
                            ),
                            child: const RegisterPage(),
                          ),
                    ),
                  );
                },
                child: const Text('Registrarme'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
