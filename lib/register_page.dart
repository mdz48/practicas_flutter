import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

Map<String, String> _hashData(Map<String, String> data) {
  final salt = BCrypt.gensalt();
  return {
    'nombre': BCrypt.hashpw(data['nombre']!, salt),
    'apellido': BCrypt.hashpw(data['apellido']!, salt),
    'ciudad': BCrypt.hashpw(data['ciudad']!, salt),
    'telefono': BCrypt.hashpw(data['telefono']!, salt),
  };
}

bool _checkData(Map<String, dynamic> args) {
  final data = args['data'] as Map<String, String>;
  final stored = args['stored'] as Map<String, String>;
  
  final nombreMatches = BCrypt.checkpw(data['nombre']!, stored['nombre']!);
  final apellidoMatches = BCrypt.checkpw(data['apellido']!, stored['apellido']!);
  final ciudadMatches = BCrypt.checkpw(data['ciudad']!, stored['ciudad']!);
  final telefonoMatches = BCrypt.checkpw(data['telefono']!, stored['telefono']!);
  
  return nombreMatches && apellidoMatches && ciudadMatches && telefonoMatches;
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _ciudadController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillPreloadedData() {
    setState(() {
      _nombreController.text = 'Juan';
      _apellidoController.text = 'Pérez';
      _ciudadController.text = 'Guadalajara';
      _telefonoController.text = '3312345678';
      _emailController.text = 'juan.perez@example.com';
      _passwordController.text = '123456';
    });
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final String nombre = _nombreController.text;
    final String apellido = _apellidoController.text;
    final String ciudad = _ciudadController.text;
    final String telefono = _telefonoController.text;
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    final hashedData = await compute(_hashData, {
      'nombre': nombre,
      'apellido': apellido,
      'ciudad': ciudad,
      'telefono': telefono,
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('hashed_nombre', hashedData['nombre']!);
    await prefs.setString('hashed_apellido', hashedData['apellido']!);
    await prefs.setString('hashed_ciudad', hashedData['ciudad']!);
    await prefs.setString('hashed_telefono', hashedData['telefono']!);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario registrado en Firebase y datos guardados localmente'),
          ),
        );
        Navigator.pop(context); // Volver al login
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al registrar en Firebase: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _validateData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? storedNombre = prefs.getString('hashed_nombre');
    final String? storedApellido = prefs.getString('hashed_apellido');
    final String? storedCiudad = prefs.getString('hashed_ciudad');
    final String? storedTelefono = prefs.getString('hashed_telefono');

    if (storedNombre == null || storedApellido == null || storedCiudad == null || storedTelefono == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No hay datos completos guardados previamente'),
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final String nombre = _nombreController.text;
    final String apellido = _apellidoController.text;
    final String ciudad = _ciudadController.text;
    final String telefono = _telefonoController.text;

    final allMatches = await compute(_checkData, {
      'data': {
        'nombre': nombre,
        'apellido': apellido,
        'ciudad': ciudad,
        'telefono': telefono,
      },
      'stored': {
        'nombre': storedNombre,
        'apellido': storedApellido,
        'ciudad': storedCiudad,
        'telefono': storedTelefono,
      }
    });

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      final String message = allMatches
          ? 'Los datos ingresados coinciden con los guardados'
          : 'Los datos ingresados NO coinciden con los guardados';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _checkDataStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload(); // Refrescar los datos directamente del almacenamiento del teléfono
    final bool hasData = prefs.containsKey('hashed_nombre');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(hasData 
              ? ' Sí hay datos encriptados guardados localmente.' 
              : ' No hay ningún dato guardado.'),
          backgroundColor: hasData ? Colors.green : Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
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
                      labelText: 'Contraseña (min 6 caracteres)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty || value.length < 6 ? 'Ingresa una contraseña válida' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Ingresa tu nombre' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _apellidoController,
                    decoration: const InputDecoration(
                      labelText: 'Apellido',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Ingresa tu apellido' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _ciudadController,
                    decoration: const InputDecoration(
                      labelText: 'Ciudad de nacimiento',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Ingresa tu ciudad de nacimiento' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _telefonoController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Número de teléfono',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Ingresa tu teléfono' : null,
                  ),
                  const SizedBox(height: 24),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else ...[
                    ElevatedButton(
                      onPressed: _registerUser,
                      child: const Text('Registrarse'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: _fillPreloadedData,
                      child: const Text('Autocompletar datos'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: _validateData,
                      child: const Text('Validar datos'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: _checkDataStatus,
                      child: const Text('Verificar estado de datos'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
