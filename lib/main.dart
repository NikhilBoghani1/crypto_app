import 'package:crypto_app/navigation/navigation_bar.dart';
import 'package:crypto_app/pages/home/home_page.dart';
import 'package:crypto_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  await registerServices();
  await registerController();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      /*  home: HomePage(),*/
      routes: {
        "/home": (context) => NavigationBarView(),
      },
      initialRoute: "/home",
    );
  }
}
