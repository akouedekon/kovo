class Ride {
  final String id;
  final String driverName;
  final double fromLat;
  final double fromLng;
  final double toLat;
  final double toLng;
  final int seatsAvailable;
  final double price;

  Ride({required this.id, required this.driverName, required this.fromLat, required this.fromLng, required this.toLat, required this.toLng, required this.seatsAvailable, required this.price});

  factory Ride.fromJson(Map<String, dynamic> j) => Ride(
    id: j['id'].toString(),
    driverName: j['driverName'] ?? j['driver_name'] ?? 'Driver',
    fromLat: (j['fromLat'] ?? j['from_lat'] ?? 0).toDouble(),
    fromLng: (j['fromLng'] ?? j['from_lng'] ?? 0).toDouble(),
    toLat: (j['toLat'] ?? j['to_lat'] ?? 0).toDouble(),
    toLng: (j['toLng'] ?? j['to_lng'] ?? 0).toDouble(),
    seatsAvailable: (j['seatsAvailable'] ?? j['seats_available'] ?? 1),
    price: (j['price'] ?? 0).toDouble(),
  );
}
