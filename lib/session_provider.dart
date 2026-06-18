import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart'; 

class SessionProvider extends ChangeNotifier {
  Timer? _timer;
  final int _timeoutSeconds = 15;

  void startSession() {
    _startTimer();
  }

  void userInteracted() {
    if (_timer != null && _timer!.isActive) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(Duration(seconds: _timeoutSeconds), _onSessionExpired);
  }

  void _onSessionExpired() {
    _timer?.cancel();
    
    final context = navigatorKey.currentContext;
    if (context != null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MyHomePage(title: 'Flutter Demo Home Page')),
        (Route<dynamic> route) => false,
      );
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              title: const Text('Sesión Expirada'),
              content: const Text('Por seguridad, tu sesión ha sido cerrada por inactividad.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Aceptar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
