import 'package:vector_math/vector_math.dart' as vec;

class SkeletonUtils {


  static List<dynamic> prepareData(List<dynamic> reference, List<dynamic> actual) {

    if(actual.isEmpty) return reference;
    print("ref before $reference");
    vec.Vector2 trans = calculateTranslation(actual, reference);
    double factor = getNormalizeFactor(actual, reference);

    reference = scale(reference, factor);


    print("after scale $reference");

    reference = translate(reference, trans);
    print("ref $reference");
    return reference;
  }

  static List<dynamic> translate(List<dynamic> reference, vec.Vector2 trans) {

    for(var index = 0;  index < reference[0]["keypoints"].values.length; index++) {
      reference[0]["keypoints"].update(index, (v) {
        v["x"] = v["x"] + trans.x;
        v["y"] = v["y"] + trans.y;
        return v;
      });
    }

    return reference;
  }

  static List<dynamic> scale(List<dynamic> reference, double factor) {
    vec.Vector2 middlePoint;
    try {
       middlePoint = calculateMiddlePoint(reference);//getMiddlePoint(reference);
    } on StateError {
      middlePoint = getMiddlePoint(reference);
      print("Error while Scaling, using fallback Option");
      return reference;
    }


    for(var index = 0;  index < reference[0]["keypoints"].values.length; index++) {
      reference[0]["keypoints"].update(index, (v) {
        v["x"] = middlePoint.x + (v["x"] - middlePoint.x)*factor;
        v["y"] = middlePoint.y + (v["y"] - middlePoint.y)*factor;
        return v;
      });
    }

    return reference;
  }

  /**
   * Get The Middle Point of the whole person
   */
  static vec.Vector2 getMiddlePoint(List<dynamic> reference) {
    double minx = 1;
    double maxx = 0;
    double miny = 1;
    double maxy = 0;

    for(dynamic value  in reference[0]["keypoints"].values) {
      print(value);
      double x = value["x"] ;
      double y = value["y"];
      if( x < minx) minx= x;
      if(x > maxx) maxx = x;
      if(y < miny) miny = y;
      if(y > maxy) maxy = y;
    }

    //box

    return vec.Vector2((maxx + minx)/2, (maxy + miny)/2);

  }


  static vec.Vector2 getVectorFromKeypoint(dynamic recognitions, String key) {
    var keypoint = recognitions[0]["keypoints"].values.firstWhere((map) => map['part'].toString() == key);
    return vec.Vector2(keypoint["x"], keypoint["y"]);

  }

  static vec.Vector2 calculateTranslation(dynamic actual, dynamic reference) {
    if(actual.isEmpty ) return vec.Vector2(0,0);
    vec.Vector2 actualMid = calculateMiddlePoint(actual);
    vec.Vector2 refMid = calculateMiddlePoint(reference);
    return  vec.Vector2(actualMid.x - refMid.x, actualMid.y - refMid.y);
  }

  /**
   * Calculate Middle point only by torso
   */
  static vec.Vector2 calculateMiddlePoint(dynamic values) {
    vec.Vector2 rightShoulder = getVectorFromKeypoint(values, "rightShoulder");
    vec.Vector2 leftShoulder = getVectorFromKeypoint(values, "leftShoulder");
    vec.Vector2 rightHip = getVectorFromKeypoint(values, "rightHip");
    vec.Vector2 leftHip = getVectorFromKeypoint(values, "leftHip");

    double x = (rightShoulder.x + leftShoulder.x + rightHip.x + leftHip.x) / 4;
    double y = (rightShoulder.y + leftShoulder.y + rightHip.y + leftHip.y) / 4;

    return vec.Vector2(x,y);
  }

  static double getNormalizeFactor(List<dynamic> recognitions, List<dynamic> reference) {
    if(recognitions.isEmpty ) return 1;

    vec.Vector2 rightShoulder = getVectorFromKeypoint(recognitions, "rightShoulder");
    vec.Vector2 leftShoulder = getVectorFromKeypoint(recognitions, "leftShoulder");

    var actual = rightShoulder.distanceTo(leftShoulder);

    vec.Vector2 rightShoulderRef = getVectorFromKeypoint(reference, "rightShoulder");
    vec.Vector2 leftShoulderRef = getVectorFromKeypoint(reference, "leftShoulder");

    var ref = rightShoulderRef.distanceTo(leftShoulderRef);

    return (actual / ref);

  }


}