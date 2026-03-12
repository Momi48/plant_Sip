import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_sip/helper/global_varaibles.dart';
import 'package:plant_sip/widget/custom_button.dart';

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

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        "https://imgs.search.brave.com/POSiM5I-qipFSRImCXHDR9qvDHa9wUtuvrQSIsrV8xg/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pLnJl/ZGQuaXQvbWJudG9r/c3hnaXRmMS5qcGVn";
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple Set Alarm", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadiusGeometry.circular(12),
                color: Colors.green,
              ),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(12),
                child: Image.network(imageUrl, fit: BoxFit.cover),
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
                openTimePicker();
              },
              title: "Set your Alarm",
            ),
            SizedBox(height: 15,),
            CustomButton(onTap: (){

            }, title: "Save Your Alarm")
          ],
        ),
      ),
    );
  }

  void openTimePicker() {
    BottomPicker.time(
      headerBuilder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Set your next meeting time',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.close, color: Colors.red),
            ),
          ],
        );
      },
      use24hFormat: false,
      onSubmit: (index) {},
      bottomPickerTheme: BottomPickerTheme.orange,
      initialTime: Time(minutes: 23),
      maxTime: Time(hours: 17),
    ).show(context);
  }
}
