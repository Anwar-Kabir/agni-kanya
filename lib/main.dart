import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:woman_safety/views/home/home.dart';
import 'package:woman_safety/views/personal_info/personal_info.dart';
import 'package:woman_safety/views/splash/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Splash(),
    );
  }
}
