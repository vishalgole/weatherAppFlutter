import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CityListController extends GetxController {
  List<String>? cityData;
  late SharedPreferences prefs;

  @override
  void onInit() async {
    prefs = await SharedPreferences.getInstance();
    super.onInit();
    if (prefs.getStringList('cityData') != null) {
      cityData = prefs.getStringList('cityData') ?? [];
    } else {
      final info = [
        "Kuala Lumpur",
        "Klang",
        "Ipoh",
        "Butterworth",
        "Johor Bahru",
        "George Town",
        "Petaling Jaya",
        "Kuantan",
        "Shah Alam",
        "Kota Bharu",
        "Melaka",
        "Kota Kinabalu",
        "Seremban",
        "Sandakan",
        "Sungai Petani",
        "Kuching",
        "Kuala Terengganu",
        "Alor Setar",
        "Putrajaya",
        "Kangar",
        "Labuan",
        "Pasir Mas",
        "Tumpat",
        "Ketereh",
        "Kampung Lemal",
        "Pulai Chondong"
      ];
      prefs.setStringList('cityData', info);
    }
    cityData = prefs.getStringList('cityData') ?? [];
    update();
  }

  getCityData() {
    cityData = prefs.getStringList('cityData') ?? [];
    update();
    return cityData;
  }
}
