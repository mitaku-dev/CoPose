import 'package:camera/camera.dart';

class CameraManager {

  List<CameraDescription> _cameras = <CameraDescription>[];

  CameraManager._internal();

  static final CameraManager _instance = CameraManager._internal();

  factory CameraManager() {
    return _instance;
  }

  List<CameraDescription> get cameras => _cameras;

  // Init method
  init() async {
    try {
      _cameras = await availableCameras();
    } on CameraException catch (e) {
      print("Failed to init Cameras");
    }
  }
}