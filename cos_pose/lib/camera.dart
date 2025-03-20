import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';

import 'dart:math' as math;

typedef void Callback(List<dynamic> list, int h, int w);

class Camera extends StatefulWidget {

  final List<CameraDescription> cameras;
  final Callback setRecognitions;

  Camera(this.cameras, this.setRecognitions);

  @override
  _CameraState createState() => _CameraState();

}

class _CameraState extends State<Camera> {

CameraController? controller;
bool isDetecting = false;

@override
void initState() {
  super.initState();

  if (widget.cameras == null || widget.cameras.length < 1) {
    print('No Camera is found');
  } else {
    controller = new CameraController(widget.cameras[0], ResolutionPreset.high);
    controller?.initialize().then((_) {
      if (!mounted) return;
      setState(() {});

      controller?.startImageStream((image) {
        if (!isDetecting) isDetecting = true;
        int startTime = new DateTime.now().millisecondsSinceEpoch;

        //poseNet
        Tflite.runPoseNetOnFrame(
            bytesList: image.planes.map((plane) {
              return plane.bytes;
            }).toList(),
            imageHeight: image.height,
            imageWidth: image.width,
            numResults: 2
        ).then((recognitions) {
          int endTime = new DateTime.now().millisecondsSinceEpoch;
          print("Detection took ${endTime - startTime}");

          widget.setRecognitions(recognitions!, image.height, image.width);

          isDetecting = false;
        });
      });
    });
  }
}

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }

    var tmp = MediaQuery.of(context).size;

    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = controller!.value.previewSize!;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight:
      screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
      screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: CameraPreview(controller!),
    );
  }

}