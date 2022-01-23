import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/src/modal/current_weather_data.dart';
import 'package:weatherapp/src/modal/five_days_data.dart';
import 'package:weatherapp/src/service/weather_service.dart';

class HomeController extends GetxController {
  String city;
  String? searchText;
  double minTemp = 275.0;
  double maxTemp = 275.0;
  // late String? desc;

  CurrentWeatherData currentWeatherData = CurrentWeatherData();
  List<CurrentWeatherData> dataList = [];
  List<FiveDayData> fiveDaysData = [];
  late SharedPreferences prefs;
  String? getCity;

  HomeController({required this.city});

  @override
  void onInit() async {
    prefs = await SharedPreferences.getInstance();
    getCity = prefs.getString("selectedCity") ?? "Kuala Lumpur";
    prefs.setString("selectedCity", getCity!);
    // storage.setItem("selectedCity", city);
    initState(getCity);
    getTopFiveCities();
    super.onInit();
  }

  void updateWeather(city) {
    this.city = city;
    update();
    initState(getCity);
  }

  void initState(cityName) {
    getCurrentWeatherData(cityName);
    getFiveDaysData();
    update();
  }

  void getCurrentWeatherData(cityName) async {
    WeatherService(city: cityName).getCurrentWeatherData(
        onSuccess: (data) {
          currentWeatherData = data;
          minTemp = double.parse((currentWeatherData.main?.temp).toString());
          maxTemp = double.parse((currentWeatherData.main?.tempMax).toString());
          // descript = currentWeatherData.weather?[0].description;
          update();
        },
        onError: (error) => {
              print(error),
              update(),
            });
    update();
  }

  void updateCityName(cityName) {
    city = cityName;
    update();
    initState(cityName);
  }

  void getTopFiveCities() {
    List<String> cities = ['London', 'New York', 'Paris', 'Moscow', 'Tokyo'];
    cities.forEach((c) {
      WeatherService(city: '$c').getCurrentWeatherData(onSuccess: (data) {
        dataList.add(data);
        update();
      }, onError: (error) {
        update();
      });
    });
    update();
  }

  void getFiveDaysData() {
    WeatherService(city: '$city').getFiveDaysThreeHoursForcastData(
        onSuccess: (data) {
      fiveDaysData = data;
      update();
    }, onError: (error) {
      update();
    });
  }
}
