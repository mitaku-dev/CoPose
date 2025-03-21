import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

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
  int height = 0;
  int width = 0;

  @override
  Widget build(BuildContext context){
    Size screen = MediaQuery.of(context).size;

    return Scaffold(
        body: Column(
          children: [
            //Image Display or empty
            image ==  null ? Container(height: 400) :
                Stack(
                  children: [
                    kIsWeb?
                        Image.network(image!.path) :
                    Image.file(
                        File(image!.path)
                    ),
                    BndBox(
                        _recognitions == null ? [] : _recognitions,
                        math.max(height, width),
                        math.min(height, width),
                        screen.height,
                        screen.width
                    )
                  ]
                ),

            image == null ?
            ElevatedButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                var file = await picker.pickImage(source: ImageSource.gallery);

                if(file != null) {
                  final decodedImage = await decodeImageFromList(await file.readAsBytes());
                  height = decodedImage.height;  // Image height
                  width = decodedImage.width;
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


              },
              child: Text("Select Reference", style: TextStyle())
            )
        :
            ElevatedButton(
            onPressed: () {},
            child: Text("Continue")
            )
    ]
        )
            //2 Buttons

    );
  }
}