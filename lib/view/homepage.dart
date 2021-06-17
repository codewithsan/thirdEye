import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:third_eye/controller/textToSpeech.dart';
import 'package:third_eye/model/captionsModel.dart';
import 'package:third_eye/model/captionsRepository.dart';
import 'package:third_eye/util/const.dart';
import 'package:third_eye/util/enum.dart';
import 'package:flutter/services.dart';
import 'package:mdi/mdi.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextToSpeech _tts = TextToSpeech();
  ImageType _imageType = ImageType.image;
  late List<CameraDescription> cameras;
  CameraController? controller;
  bool _isloading = true;
  bool _reqSent = false;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getCameras();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          key: _scaffoldkey,
          appBar: AppBar(
            title: const Text("THIRD EYE"),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/thirdEye.png"),
            ),
            actions: [
              _imageType == ImageType.image
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: const Icon(
                        Icons.image,
                        color: Colors.white,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: const Icon(
                        Mdi.fileDocument,
                        color: Colors.white,
                      ),
                    )
            ],
          ),
          body: !_isloading
              ? Stack(
                  children: [
                    GestureDetector(
                      child: CameraPreview(controller!),
                      onDoubleTap: _sendRequest,
                      onHorizontalDragUpdate: (details) {
                        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
                        int sensitivity = 8;
                        if (details.delta.dx > sensitivity) {
                          setState(() {
                            _imageType = ImageType.image;
                          });
                        } else if (details.delta.dx < -sensitivity) {
                          setState(() {
                            _imageType = ImageType.document;
                          });
                        }
                      },
                    ),
                    _reqSent
                        ? Center(
                            child: kCustomProgressIndicator,
                          )
                        : SizedBox()
                  ],
                )
              : Center(
                  child: kCustomProgressIndicator,
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    _tts.dispose();
    super.dispose();
  }

  void getCameras() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller!.lockCaptureOrientation(DeviceOrientation.portraitUp);
      setState(() {
        _isloading = false;
      });
    }).catchError(
      (error) {
        print('Camera Controller Error: $error');
        controller?.dispose();
        Navigator.pop(context);
      },
    );
  }

  void _sendRequest() async {
    try {
      if (!_reqSent) {
        setState(() {
          _reqSent = true;
        });
        HapticFeedback.heavyImpact();
        XFile file = await controller!.takePicture();
        print(file.path);

        Captions captions =
            await CaptionsRepository.describeImage(file, _imageType);
        _tts.speak(captions.text);
        print(captions.text);

        //deleting captured image
        final imageFile = File(file.path);
        imageFile.delete();

        HapticFeedback.heavyImpact();

        setState(() {
          _reqSent = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
