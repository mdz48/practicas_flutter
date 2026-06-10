import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'login_form.dart';
import 'notification_service.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (_) {}
  NotificationService().initNotifications();
  runApp(
    DevicePreview(enabled: kIsWeb, builder: (context) => const MyApp()),
  );
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final sessionStateStream = StreamController<SessionState>.broadcast();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SessionConfig sessionConfig;

  @override
  void initState() {
    super.initState();
    sessionConfig = SessionConfig(
      invalidateSessionForAppLostFocus: const Duration(seconds: 5),
      invalidateSessionForUserInactivity: const Duration(seconds: 5),
    );

    sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) async {
      if (timeoutEvent == SessionTimeoutState.appFocusTimeout ||
          timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
        
        sessionStateStream.add(SessionState.stopListening);
        // Log out user
        await FirebaseAuth.instance.signOut();
        
        // Return to login page using the global navigator key
        scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text('Sesión cerrada por inactividad (5s)')),
        );
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MyHomePage(title: 'Flutter Demo Home Page')),
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SessionTimeoutManager(
      userActivityDebounceDuration: const Duration(seconds: 1),
      sessionConfig: sessionConfig,
      sessionStateStream: sessionStateStream.stream,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: scaffoldMessengerKey,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [const LoginForm()],
          ),
        ),
      ),
    );
  }
}
