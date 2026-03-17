import 'dart:async';
import 'dart:io';

import 'package:alarm/alarm.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_sip/helper/global_varaibles.dart';
import 'package:plant_sip/helper/shared_preference_class.dart';
import 'package:plant_sip/helper/snack_bar_message.dart';
import 'package:plant_sip/screen/alarm_edit_screen.dart';
import 'package:plant_sip/widget/custom_button.dart';
import 'package:plant_sip/widget/show_alarm_time.dart';

final ImagePicker picker = ImagePicker();

class PlantHomeScreen extends StatefulWidget {
  const PlantHomeScreen({super.key});

  @override
  State<PlantHomeScreen> createState() => _PlantHomeScreenState();
}

class _PlantHomeScreenState extends State<PlantHomeScreen> {
  TextEditingController plantController = TextEditingController();
  final formKey = GlobalKey<FormState>();
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
  void getImageFromGallery() async {
    // Pick an image.
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        cameraImage = File(image.path);

        SPHelper.sp.save("plantImage", cameraImage!.path);
      });
    } else {
      snackBarMessage(
        context: context,
        message: "No Camera Picture is Taken",
        backgroundColor: Colors.red,
      );
    }
  }

  void getImageFromCamera() async {
    // Pick an image.
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        cameraImage = File(image.path);
      });
    } else {
      snackBarMessage(
        context: context,
        message: "No Camera Picture is Taken",
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    cameraImage = File(SPHelper.sp.get("plantImage").toString());
    plantController.addListener(() {
      setState(() {});
    });

    selectedPlantAlarm = SPHelper.sp.get("alarmTime");
    print("plantImage: ${SPHelper.sp.get("plantImage")}");
    print("Alarm Name: ${SPHelper.sp.get("AlarmName")}");
    print("alarmTime: ${SPHelper.sp.get("alarmTime")}");
  }

  void saveAlarmDataLocal() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/plant_image.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          width: double.infinity,
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
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Form(
                key: formKey,
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
                      onTap: () => getImageFromGallery(),
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusGeometry.circular(12),
                          color: Colors.transparent,
                          border: SPHelper.sp.get("plantImage") == null
                              ? Border.all(color: Colors.green, width: 2.0)
                              : null,
                        ),
                        child: SPHelper.sp.get("plantImage") == null
                            ? Center(
                                child: Text(
                                  "Upload Image of your Plant",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(12),
                                child: Image.file(
                                  cameraImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Alarm Name",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: plantController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "This Field is Required";
                        }
                        return null;
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    plantController.text.isNotEmpty &&
                            SPHelper.sp.get("plantImage") != null
                        ? CustomButton(
                            onTap: () {
                              setState(() {
                                navigateToAlarmScreen(alarmSettings);
                              });
                            },
                            title: "Set your Alarm",
                          )
                        : Container(),
                    SizedBox(height: 10),
                    SPHelper.sp.get("alarmTime") == null
                        ? Container()
                        : ShowAlarmTime(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            SPHelper.sp.get("plantImage") == null ? getImageFromCamera() : null,
        backgroundColor: Colors.green,
        child: Icon(Icons.camera_alt, color: Colors.white),
      ),
    );
  }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: AlarmEditScreen(
            alarmSettings: settings,
            plantAlarmName: plantController.text,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    plantController.dispose();
  }
}
