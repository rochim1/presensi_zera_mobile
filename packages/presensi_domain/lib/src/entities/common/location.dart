class AppLocation {
  final double lat;
  final double long;

  const AppLocation({required this.lat, required this.long});
}

class AppAddress {
  final AppLocation location;
  final String address;

  AppAddress({required this.location, required this.address});
}
