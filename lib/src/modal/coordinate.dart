class Coordinate {
  final double lon = 0.0;
  final double lat = 0.0;

  Coordinate({lon, lat});

  factory Coordinate.fromJson(dynamic json) {
    if (json == null) {
      return Coordinate(lon: 0, lat: 0);
    }
    return Coordinate(
        lon: double.parse(json['lon'].toString()),
        lat: double.parse(json['lat'].toString()));
  }
}
