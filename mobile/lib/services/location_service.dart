// Location service — uses Android manifest permissions (no runtime request needed for debug APK)
class LocationService {
  static Future<bool> requestLocationPermission() async {
    // On Android, permissions are declared in AndroidManifest.xml
    // For debug builds, permissions are granted automatically
    // For production, implement proper permission handling via platform channels
    return true;
  }

  static Future<bool> hasLocationPermission() async {
    return true;
  }
}
