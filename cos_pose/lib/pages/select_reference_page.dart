import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pose_tool/home.dart';
import 'package:tflite_v2/tflite_v2.dart';

import '../SkeletonPainter.dart';
import '../bnd_box.dart';



class SelectReferencePage extends StatefulWidget {
  SelectReferencePage() : super();

  @override
  _SelectReferencePageState createState() => _SelectReferencePageState();
}

class _SelectReferencePageState extends State<SelectReferencePage> {


  XFile? image;

  final ImagePicker _picker = ImagePicker();
  List<dynamic> _recognitions = [];
  double height = 0;
  double width = 0;

  // final double MAX_WIDTH = 600;
  // final double MAX_HEIGHT = 600;


   Size scaleImage(double MAX_WIDTH, double MAX_HEIGHT) {
     final double aspectRatio = width/ height;
     double newWidth = MAX_WIDTH;
     double newHeight = MAX_HEIGHT;

     if (aspectRatio > 1) {
       // Breiter als hoch -> skalieren basierend auf Breite
       newHeight = MAX_WIDTH / aspectRatio;
       if (newHeight > MAX_HEIGHT) {
         newHeight = MAX_HEIGHT;
         newWidth = MAX_HEIGHT * aspectRatio;
       }
     } else {
       // Höher als breit -> skalieren basierend auf Höhe
       newWidth = MAX_HEIGHT * aspectRatio;
       if (newWidth > MAX_WIDTH) {
         newWidth = MAX_WIDTH;
         newHeight = MAX_WIDTH / aspectRatio;
       }
     }

     return Size(newWidth, newHeight);
   }


   selectImage() async {
     final ImagePicker picker = ImagePicker();
     var file = await picker.pickImage(source: ImageSource.gallery);

     if(file != null) {
       final decodedImage = await decodeImageFromList(await file.readAsBytes());
     height = decodedImage.height.toDouble();  // Image height
     width = decodedImage.width.toDouble();
     }


     Tflite.runPoseNetOnImage(
     path: file!.path,
     numResults: 2,
     threshold: 0.7,
     nmsRadius: 10,
     asynch: true
     ).then((recognitions) {
     setState((){
     image = file;
     print(recognitions);
     //  if(recognitions.length == 0) {
     //TODO
     //  }
     _recognitions = recognitions!;
     });

     });

   }

  @override
  Widget build(BuildContext context){
    Size screen = MediaQuery.of(context).size;
    Size newSize = scaleImage(screen.width, screen.height - 100);
    return Scaffold(
        body: Column(
          children: [
            //Image Display or empty
            image ==  null ? Container(height: 400) :
                Container(
                    height: newSize.height, //TODO scale real size absed on picture
                    width: newSize.width,
                    child:  Stack(
                        children: [
                          Image.file(
                              File(image!.path)
                          ),
                          Container(
                            height:newSize.height, //TODO scale real size absed on picture
                            width: newSize.width,
                            child: CustomPaint(
                              painter: SkeletonPainter(_recognitions),
                            ),
                          ),
                        ]
                    ),
                ),

            image == null ?
            ElevatedButton(
              onPressed: selectImage,
              child: Text("Select Reference", style: TextStyle())
            )
        :
                OverflowBar(
                  spacing: 25,
                  children: [
                    ElevatedButton(
                        onPressed: selectImage,
                        child: Text("Select New")
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Home(_recognitions))
                          );

                        },
                        child: Text("Continue")
                    )
                  ],
                )

    ]
        )
            //2 Buttons

    );
  }
}