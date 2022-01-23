import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' hide ServiceStatus;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:weatherapp/src/modal/current_weather_data.dart';
import 'package:weatherapp/src/modal/five_days_data.dart';
import 'package:weatherapp/src/ui/citylist/city_list_controller.dart';
import 'package:weatherapp/src/ui/citylist/city_list_screen.dart';

import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController ctr = Get.put(HomeController(city: "kuala lumpur"));
  late SharedPreferences prefs;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  CityListController cityController = Get.put(CityListController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLocPermission();
  }

  showLocationDialog() {
    showAlertDialog(BuildContext context) {
      // set up the button
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          Geolocator.openLocationSettings();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("LOCATION PERMISSION"),
        content: Text("Please enable device location to determine weather."),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  getUserLocation(currentPostion) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPostion.latitude, currentPostion.longitude);
    Placemark place = placemarks[0];
    prefs.setString("selectedCity", place.locality!);
  }

  Future<void> checkLocPermission() async {
    prefs = await SharedPreferences.getInstance();
    final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    final isGpsOn = serviceStatus == ServiceStatus.enabled;
    if (!isGpsOn) {
      // Geolocator.openLocationSettings();
      showLocationDialog();
      return;
    }

    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      var longLat = await Geolocator.getCurrentPosition();
      getUserLocation(longLat);
    } else if (status == PermissionStatus.denied) {
      print(
          'Permission denied. Show a dialog and again ask for the permission');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldState,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("Cities"),
              trailing: Icon(Icons.location_city),
              onTap: () {
                // Get.reset();
                // Get.toNamed("/cities");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CityListScreen()),
                ).then((value) => setState(() {}));
              },
            ),
          ],
        ),
      ),
      body: GetBuilder<HomeController>(builder: (controller) {
        return Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/cloud-in-blue-sky.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        leading: IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            scaffoldState.currentState?.openDrawer();
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 20,
                      ),
                      padding: EdgeInsets.only(top: 100, left: 20, right: 20),
                      child: TextField(
                        onChanged: (value) => controller.city = value,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) async {
                          final List<String> data =
                              await prefs.getStringList('cityData') ?? [];
                          setState(() async {
                            data.add(value);
                            prefs.setStringList("cityData", data);
                            prefs.setString("selectedCity", value);
                            controller.initState(value);
                          });
                        },
                        decoration: InputDecoration(
                          suffix: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          hintStyle: TextStyle(color: Colors.white),
                          hintText: 'Search'.toUpperCase(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    Align(
                      alignment: Alignment(0.0, 1.8),
                      child: SizedBox(
                        height: 10,
                        width: 10,
                        child: OverflowBox(
                          minWidth: 0.0,
                          maxWidth: MediaQuery.of(context).size.width,
                          minHeight: 0.0,
                          maxHeight: (MediaQuery.of(context).size.height / 3),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                width: double.infinity,
                                height: double.infinity,
                                child: Card(
                                  color: Colors.white,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: 15, left: 20, right: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Center(
                                              child: Text(
                                                (controller.currentWeatherData !=
                                                        null)
                                                    ? '${controller.currentWeatherData.name}'
                                                        .toUpperCase()
                                                    : '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    ?.copyWith(
                                                      color: Colors.black45,
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          'flutterfonts',
                                                    ),
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                DateFormat()
                                                    .add_MMMMEEEEd()
                                                    .format(DateTime.now()),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    ?.copyWith(
                                                      color: Colors.black45,
                                                      fontSize: 16,
                                                      fontFamily:
                                                          'flutterfonts',
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            padding:
                                                const EdgeInsets.only(left: 50),
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  (controller.currentWeatherData
                                                              .weather !=
                                                          null)
                                                      ? '${controller.currentWeatherData.weather?[0].description}'
                                                      : '',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption
                                                      ?.copyWith(
                                                        color: Colors.black45,
                                                        fontSize: 22,
                                                        fontFamily:
                                                            'flutterfonts',
                                                      ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  // ignore: unnecessary_null_comparison
                                                  (controller.minTemp != null)
                                                      ? '${(controller.minTemp - 273.15).round().toString()}\u2103'
                                                      : '',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline2!
                                                      .copyWith(
                                                          color: Colors.black45,
                                                          fontFamily:
                                                              'flutterfonts'),
                                                ),
                                                Text(
                                                  (controller.minTemp != null)
                                                      ? 'min: ${(controller.minTemp - 273.15).round().toString()}\u2103 / max: ${(controller.maxTemp - 273.15).round().toString()}\u2103'
                                                      : '',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption
                                                      ?.copyWith(
                                                        color: Colors.black45,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'flutterfonts',
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  width: 120,
                                                  height: 120,
                                                  decoration:
                                                      const BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/icon-01.jpg'),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(
                                                    (controller.currentWeatherData
                                                                .wind !=
                                                            null)
                                                        ? 'wind ${controller.currentWeatherData.wind!.speed} m/s'
                                                        : '',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption
                                                        ?.copyWith(
                                                          color: Colors.black45,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              'flutterfonts',
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        padding: EdgeInsets.only(top: 120),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  'other city'.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      ?.copyWith(
                                        fontSize: 16,
                                        fontFamily: 'flutterfonts',
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              Container(
                                height: 150,
                                child: ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) =>
                                      const VerticalDivider(
                                    color: Colors.transparent,
                                    width: 5,
                                  ),
                                  itemCount: controller.dataList.length,
                                  itemBuilder: (context, index) {
                                    CurrentWeatherData? data;
                                    (controller.dataList.length > 0)
                                        ? data = controller.dataList[index]
                                        : data = null;
                                    return Container(
                                      width: 140,
                                      height: 150,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                (data != null)
                                                    ? '${data.name}'
                                                    : '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    ?.copyWith(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black45,
                                                      fontFamily:
                                                          'flutterfonts',
                                                    ),
                                              ),
                                              Text(
                                                (data != null)
                                                    ? '${(data.main!.temp! - 273.15).round().toString()}\u2103'
                                                    : '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    ?.copyWith(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black45,
                                                      fontFamily:
                                                          'flutterfonts',
                                                    ),
                                              ),
                                              Container(
                                                width: 50,
                                                height: 50,
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/icon-01.jpg'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                (data != null)
                                                    ? '${data.weather?[0].description}'
                                                    : '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    ?.copyWith(
                                                      color: Colors.black45,
                                                      fontFamily:
                                                          'flutterfonts',
                                                      fontSize: 14,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'forcast next 5 days'.toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          ?.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black45,
                                          ),
                                    ),
                                    Icon(
                                      Icons.next_plan_outlined,
                                      color: Colors.black45,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 240,
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: SfCartesianChart(
                                    primaryXAxis: CategoryAxis(),
                                    series: <ChartSeries<FiveDayData, String>>[
                                      SplineSeries<FiveDayData, String>(
                                        dataSource: controller.fiveDaysData,
                                        xValueMapper: (FiveDayData f, _) =>
                                            f.dateTime,
                                        yValueMapper: (FiveDayData f, _) =>
                                            f.temp,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
