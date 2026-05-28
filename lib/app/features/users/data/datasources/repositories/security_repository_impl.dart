import 'package:geolocator/geolocator.dart';
import '../../../domain/repositories/security_repository.dart';

class SecurityRepositoryImpl implements SecurityRepository {
  @override
  Future<void> checkSecurity() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Por favor activa el GPS.';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Se requiere permiso de ubicación.';
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw 'Permiso de ubicación denegado permanentemente.';
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    if (position.isMocked) {
      throw 'Ubicación simulada (Fake GPS) detectada. Acceso bloqueado.';
    }
  }
}
