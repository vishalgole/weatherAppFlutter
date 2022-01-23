class MainWeather {
  final double? temp;
  final double? feelslike;
  final double? tempMax;
  final double? tempMin;
  final int? pressure;
  final int? humidity;

  MainWeather(
      {this.temp,
      this.feelslike,
      this.tempMin,
      this.tempMax,
      this.pressure,
      this.humidity});

  factory MainWeather.fromJson(dynamic json) {
    if (json == null) {
      return MainWeather();
    }
    return MainWeather(
      temp: json['temp'],
      feelslike: double.parse(json['feels_like'].toString()),
      // feelslike: 276.5,
      tempMin: json['tempMin'],
      tempMax: json['tempMax'],
      pressure: json['pressure'],
      humidity: json['humidity'],
    );
  }
}
