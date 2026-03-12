import 'dart:async';
import 'dart:io';

import 'package:alarm/alarm.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_sip/screen/alarm_edit_screen.dart';
import 'package:plant_sip/widget/custom_button.dart';

final ImagePicker picker = ImagePicker();

class PlantHomeScreen extends StatefulWidget {
  const PlantHomeScreen({super.key});

  @override
  State<PlantHomeScreen> createState() => _PlantHomeScreenState();
}

class _PlantHomeScreenState extends State<PlantHomeScreen> {
  DateTime now = DateTime.now().copyWith(
    hour: 0,
    minute: 0,
    second: 0,
    millisecond: 0,
    microsecond: 0,
  );
  late final alarmSettings = AlarmSettings(
    id: 42,
    dateTime: now,

    loopAudio: true,
    vibrate: true,
    warningNotificationOnKill: Platform.isIOS,
    androidFullScreenIntent: true,
    volumeSettings: VolumeSettings.fade(
      volume: 0.8,
      fadeDuration: Duration(seconds: 5),
      volumeEnforced: true,
    ),
    notificationSettings: NotificationSettings(
      title: 'This is the title',
      body: 'This is the body',
      stopButton: 'Stop the alarm',
      icon: 'notification_icon',
      iconColor: Color(0xff862778),
    ),
  );
  String imageUrl =
      "https://imgs.search.brave.com/POSiM5I-qipFSRImCXHDR9qvDHa9wUtuvrQSIsrV8xg/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pLnJl/ZGQuaXQvbWJudG9r/c3hnaXRmMS5qcGVn";
  File? cameraImage;
  void getImageFromCamera() async {
    // Pick an image.
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        cameraImage = File(image.path);
      });

      print("Imagei is picked ${image.path} $cameraImage ");
    } else {
      print("Image is Not Picked");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/plant_image.png", fit: BoxFit.cover),
          ),

          // gradient overlay
          Positioned.fill(
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(25, 16, 34, 0.6),
                    Color.fromRGBO(25, 16, 34, 0.6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Simple Set Alarm",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () => getImageFromCamera(),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusGeometry.circular(12),
                        color: Colors.transparent,
                        border: cameraImage == null ?  Border.all(color: Colors.green, width: 2.0) : null
                      ),
                      child: cameraImage == null
                          ? Center(
                              child: Text(
                                "Tap to Take image of your Plant",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(12),
                              child: Image.file(
                                File(cameraImage!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Time",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    onTap: () {
                      setState(() {});
                      navigateToAlarmScreen(alarmSettings);
                    },
                    title: "Set your Alarm",
                  ),
                  SizedBox(height: 15),
                  CustomButton(onTap: () {}, title: "Save Your Alarm"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void openTimePicker() async {
    await Alarm.set(alarmSettings: alarmSettings);
  }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: AlarmEditScreen(alarmSettings: settings),
        );
      },
    );
  }
}
