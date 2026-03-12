import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:plant_sip/screen/plant_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     
      home: PlantHomeScreen(),
    );
  }
}
