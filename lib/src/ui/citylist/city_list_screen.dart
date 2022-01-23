import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/src/ui/citylist/city_list_controller.dart';
import 'package:weatherapp/src/ui/home/home_controller.dart';
import 'package:weatherapp/src/ui/home/home_screen.dart';

class CityListScreen extends StatefulWidget {
  CityListScreen({Key? key}) : super(key: key);

  @override
  State<CityListScreen> createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> {
  CityListController controller = Get.put(CityListController());

  HomeController homeCtrl = Get.put(HomeController(city: ""));

  late SharedPreferences prefs;

  @override
  void initState() {
    getSharedPref();
    super.initState();
  }

  getSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      controller.cityData = prefs.getStringList('cityData')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Select City"),
          backgroundColor: Colors.blueAccent,
        ),
        body: Container(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 10,
          ),
          child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(
                    controller.cityData![index].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      height: 2,
                    ),
                  ),
                  onTap: () {
                    prefs.setString(
                        "selectedCity", controller.cityData![index]);
                    homeCtrl.updateCityName(controller.cityData![index]);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  });
            },
            separatorBuilder: (BuildContext context, int index) {
              return Column(
                children: const [
                  SizedBox(
                    height: 10,
                  ),
                  Divider(height: 1, color: Colors.green),
                ],
              );
            },
            itemCount: controller.cityData!.length,
          ),
        ));
  }
}
