import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:pose_tool/CameraManager.dart';
import 'package:pose_tool/SkeletonPainter.dart';
import 'package:pose_tool/pages/SkeletonUtils.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:vector_math/vector_math.dart' as vec;

//import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'bnd_box.dart';
import 'camera.dart';

import 'dart:math' as math;

class Home extends StatefulWidget {
  //final List<CameraDescription> cameras;
  Home(this.reference);
  //Home(this.cameras);

  final List<dynamic> reference;

  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  List<dynamic> _recognitions = [];
  int _imageHeight = 0;
  int _imageWidth = 0;
  CameraController? controller;


  @override
  void initState() {
    super.initState();
    controller = new CameraController(CameraManager().cameras[0], ResolutionPreset.high);
   // loadModel();
  }

  /*
  loadModel() async {
    String? res = await Tflite.loadModel(
        model: "assets/posenet_mv1_075_float_from_checkpoints.tflite"
    );
    print(res);
 // FlutterNativeSplash.remove();
  }
*/

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }




  @override
  void dispose() async {
    super.dispose();
    await Tflite.close();
  }


  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Camera(
            CameraManager().cameras,
            controller,
            setRecognitions,
          ),
          Container(
            height:screen.height, //TODO scale real size absed on picture
            width: screen.width,
            child: CustomPaint(
              painter: SkeletonPainter(SkeletonUtils.prepareData(widget.reference,_recognitions)),
            )
          ),
          /*
          Container(
              height:screen.height, //TODO scale real size absed on picture
              width: screen.width,
              child: CustomPaint(
                painter: SkeletonPainter(_recognitions),
              )
          ),*/
          /*
          BndBox(
              _recognitions == null ? [] : _recognitions,
              math.max(_imageHeight, _imageWidth),
              math.min(_imageHeight, _imageWidth),
              screen.height,
              screen.width
              ),*/


        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(82,170,94,1.0),
        child: const Icon(Icons.cameraswitch, color: Colors.white, size:28),
        onPressed: (){

            if(controller != null){
              final lensDirection =  controller!.description.lensDirection;
              CameraDescription newDescription;
              if(lensDirection == CameraLensDirection.front){
                newDescription = CameraManager().cameras.firstWhere((description) => description.lensDirection == CameraLensDirection.back);
              }
              else{
                newDescription = CameraManager().cameras.firstWhere((description) => description.lensDirection == CameraLensDirection.front);
              }
              setState(() {
                controller!.setDescription(newDescription);
              });

            }


        }
      )
      );
  }
}