import 'package:flutter/material.dart';
import 'package:pose_tool/pages/SkeletonUtils.dart';
import 'package:vector_math/vector_math.dart' as vec;


/**
 * Connect:
 * rightShoulder ->leftShoulder
 * right Shoulder -> rightHip
 * rightShoulder -> right Elbow
 * rightElbow - rightWrist
 * leftShoulder - leftElbow
 * leftElbow - leftWrist
 * leftShoulder -> leftHip
 * rightHip -> leftHip
 * rightHip - rightKnee
 * rightKnee -> rightAnkle
 * leftHip -> leftKnee
 * leftKneww -> leftAnkle
 */

class SkeletonPainter extends CustomPainter {

  final List<dynamic> results;
  final double factor;
  final double translatex;
  final double translatey;

  SkeletonPainter(this.results,{ this.factor = 1, this.translatex = 0, this.translatey = 0});


  final paintBone = Paint()
    ..color = Colors.blue
    ..strokeWidth = 3.0;



  drawSkeleton(dynamic data,Canvas canvas, Size size) {
    drawLine(data, canvas, size, "rightShoulder", "leftShoulder");
    drawLine(data, canvas, size, "rightShoulder", "rightHip");
    drawLine(data, canvas, size, "rightShoulder", "rightElbow");
    drawLine(data, canvas, size, "rightElbow", "rightWrist");
    drawLine(data, canvas, size, "leftShoulder", "leftElbow");
    drawLine(data, canvas, size, "leftElbow", "leftWrist");
    drawLine(data, canvas, size, "leftShoulder", "leftHip");
    drawLine(data, canvas, size, "rightHip", "leftHip");
    drawLine(data, canvas, size, "rightHip", "rightKnee");
    drawLine(data, canvas, size, "rightKnee", "rightAnkle");
    drawLine(data, canvas, size, "leftHip", "leftKnee");
    drawLine(data, canvas, size, "leftKnee", "leftAnkle");
  }


  drawLine(dynamic data, Canvas canvas, Size size, String key1, String key2) {
    var keypoints = data["keypoints"].values;
    var obj1 = keypoints.where((map) => map['part'].toString() == key1).single;
    var obj2 = keypoints.where((map) => map['part'].toString() == key2).single;

    var _x1 = (obj1["x"]+translatex) * size.width *factor;
    var _y1 = (obj1["y"]+translatey) * size.height *factor;

    var _x2 = (obj2["x"]+translatex) * size.width *factor;
    var _y2 = (obj2["y"]+translatey) * size.height *factor;

    canvas.drawLine(Offset(_x1, _y1), Offset(_x2, _y2), paintBone);
  }

  @override
  void paint(Canvas canvas, Size size) {

    final paintJoint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;


    results.forEach((re) {
      drawSkeleton(re, canvas, size);

      var list = re["keypoints"].values;
      for(var point in list) {

        //get part
        if(point["score"] < 0.3) continue; //filter bad results

        var _x = (point["x"]+translatex) * size.width *factor;
        var _y = (point["y"]+translatey) * size.height * factor;
        canvas.drawCircle(Offset(_x, _y), 5, paintJoint);

      }

      /*
      var list = re["keypoints"].values.forEach<Widget>((k) {
        var _x = k["x"] * size.width;
        var _y = k["y"] * size.height;

        //var scaleW, scaleH, x, y;


        // canvas.drawLine(Offset(_x, _y), Offset(p2.x, p2.y), paintBone);
      }); */
    });

   // SkeletonUtils.calculateMiddlePoint(values)
    //canvas.drawCircle(Offset(_x, _y), 5, paintJoint);
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;



}