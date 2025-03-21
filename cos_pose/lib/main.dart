import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pose_tool/pages/select_reference_page.dart';
//import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'CameraManager.dart';
import 'home.dart';
import 'package:tflite_v2/tflite_v2.dart';




List<CameraDescription> cameras = [];

Future<Null> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
 // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await CameraManager().init();
  loadModel();
  runApp(MyApp());
}

loadModel() async {
  Tflite.close();
  try {
    String? res = await Tflite.loadModel(
        model: "assets/posenet_mv1_075_float_from_checkpoints.tflite"
    );
    print(res);
  } on PlatformException {
    print("Failed to load model");
  }


  // FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CosPose',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: SelectReferencePage()//Home(cameras),
    );
  }
}