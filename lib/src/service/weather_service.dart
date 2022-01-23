import 'package:weatherapp/src/api/api_repository.dart';
import 'package:weatherapp/src/modal/current_weather_data.dart';
import 'package:weatherapp/src/modal/five_days_data.dart';

class WeatherService {
  final String city;

  String baseUrl = 'https://api.openweathermap.org/data/2.5';
  String apiKey = 'appid=de164c1ff08fc9148197565094ceae46';

  WeatherService({required this.city});

  void getCurrentWeatherData({
    Function()? beforeSend,
    Function(CurrentWeatherData currentWeatherData)? onSuccess,
    Function(dynamic error)? onError,
  }) {
    final url = '$baseUrl/weather?q=$city&lang=en&$apiKey';
    ApiRepository(url: '$url', payload: null).get(
        beforeSend: () => {
              if (beforeSend != null)
                {
                  beforeSend(),
                },
            },
        onSuccess: (data) => {
              onSuccess!(CurrentWeatherData.fromJson(data)),
            },
        onError: (error) => {
              if (onError != null)
                {
                  onError(error),
                }
            });
  }

  void getTopFiveCities({
    Function()? beforeSend,
    Function(dynamic currentWeatherData)? onSuccess,
    Function(dynamic error)? onError,
  }) {}

  void getFiveDaysThreeHoursForcastData({
    Function()? beforeSend,
    Function(List<FiveDayData> fiveDayData)? onSuccess,
    Function(dynamic error)? onError,
  }) {
    final url = '$baseUrl/forecast?q=$city&lang=en&$apiKey';
    ApiRepository(url: '$url', payload: null).get(
        beforeSend: () => {},
        onSuccess: (data) => {
              onSuccess!((data['list'] as List)
                  .map((t) => FiveDayData.fromJson(t))
                  .toList()),
            },
        onError: (error) => {
              onError!(error),
            });
  }
}
