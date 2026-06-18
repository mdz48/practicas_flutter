import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:no_screenshot/overlay_mode.dart';
import 'package:no_screenshot/secure_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe_device/safe_device.dart';
import 'package:provider/provider.dart';
import 'register_page.dart';
import 'dashboard_page.dart';
import 'session_provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isChecking = true;
  bool _isBlocked = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkSecurity();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkSecurity() async {
    setState(() {
      _isChecking = true;
      _isBlocked = false;
    });
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw 'Por favor activa el GPS.';

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied)
          throw 'Se requiere permiso de ubicación.';
      }
      if (permission == LocationPermission.deniedForever) {
        throw 'Permiso de ubicación denegado permanentemente.';
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (position.isMocked)
        throw 'Ubicación simulada (Fake GPS) detectada. Acceso bloqueado.';

      setState(() => _isChecking = false);
    } catch (e) {
      setState(() {
        _isChecking = false;
        _isBlocked = true;
        _errorMessage = e.toString();
      });
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    
    // Iniciar el temporizador de sesión
    context.read<SessionProvider>().startSession();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Éxito! Iniciar sesión: ${_emailController.text}'),
      ),
    );

    // Navegar de forma destructiva al dashboard
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const DashboardPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_isBlocked) {
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
                Text(_errorMessage, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _checkSecurity,
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
        constraints: const BoxConstraints(maxWidth: 400),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                onPressed: _isLoading ? null : _submitForm,
                child: const Text('Iniciar Sesión'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
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
