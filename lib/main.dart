import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_preview/device_preview.dart';
import 'firebase_options.dart';
import 'login_form.dart';
import 'notification_service.dart';
import 'package:provider/provider.dart';
import 'session_provider.dart';
import 'package:flutter/services.dart';
import 'package:safe_device/safe_device.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {}
  NotificationService().initNotifications();
  runApp(
    ChangeNotifierProvider(
      create: (context) => SessionProvider(),
      child: DevicePreview(enabled: kIsWeb, builder: (context) => const MyApp()),
    ),
  );
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
      locale: DevicePreview.locale(context),
      builder: (context, child) {
        final devicePreviewChild = DevicePreview.appBuilder(context, child);
        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (_) => context.read<SessionProvider>().userInteracted(),
          onPointerSignal: (_) => context.read<SessionProvider>().userInteracted(),
          onPointerMove: (_) => context.read<SessionProvider>().userInteracted(),
          child: Focus(
            autofocus: true,
            onKeyEvent: (node, event) {
              context.read<SessionProvider>().userInteracted();
              return KeyEventResult.ignored;
            },
            child: devicePreviewChild,
          ),
        );
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isCheckingSecurity = true;

  @override
  void initState() {
    super.initState();
    _checkSecurity();
  }

  Future<void> _checkSecurity() async {
    if (!kDebugMode) {
      bool isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
      if (isDevelopmentModeEnable) {
        if (mounted) {
          _showSecurityDialog();
        }
        return;
      }
    }
    if (mounted) {
      setState(() {
        _isCheckingSecurity = false;
      });
    }
  }

  void _showSecurityDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.security, color: Colors.red),
                SizedBox(width: 8),
                Text('Bloqueo de Seguridad'),
              ],
            ),
            content: const Text(
                'Se ha detectado que la depuración USB está activa. Por estrictas políticas de seguridad, la aplicación no puede ejecutarse en este estado.\n\nPor favor, desactiva la depuración USB en los ajustes del sistema y vuelve a intentarlo.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Cerrar Aplicación', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingSecurity) {
      // Pantalla de carga mientras se verifica la seguridad
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [const LoginForm()],
        ),
      ),
    );
  }
}
