import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'src/ui/citylist/city_list_screen.dart';
import 'src/ui/home/home_binding.dart';
import 'src/ui/home/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: "/",
          page: () => HomeScreen(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: "/cities",
          page: () => CityListScreen(),
        ),
      ],
    );
  }
}
