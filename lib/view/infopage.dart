import 'package:flutter/material.dart';
import 'package:third_eye/util/const.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.1,
              ),
              Image.asset("assets/posterThirdEye.png"),
              SizedBox(
                height: height * 0.05,
              ),
              Text(
                "Double tap the screen and the app will describe the image seen by the camera",
                style: kTextStyle,
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Text(
                "Left swipe to enter document mode in which app will read the text shown to camera",
                style: kTextStyle,
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Text(
                "You can toggle between image and document mode by swiping left and right",
                style: kTextStyle,
              ),
              SizedBox(
                height: height * 0.05,
              ),
              OutlinedButton.icon(
                icon: Icon(
                  Icons.thumb_up,
                ),
                label: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "OK, Got it",
                    style: kTextStyle,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  side: BorderSide(width: 2.0, color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
