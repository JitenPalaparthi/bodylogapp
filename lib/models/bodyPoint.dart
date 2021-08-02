import 'package:flutter/material.dart';

enum ProblemType { Pain, PinsAandNeedles, Iching }

extension ParseToString on ProblemType {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

class BodyPoint {
  Offset offset;
  ProblemType problemType;
  DateTime logOn;
  //DateTime starton;
  //DateTime endOn;
  BodyPoint(this.offset, this.problemType, this.logOn);
}
