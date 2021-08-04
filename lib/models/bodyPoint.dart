import 'package:flutter/material.dart';

enum ProblemType { Pain, PinsAandNeedles, Iching }

extension ParseToString on ProblemType {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

class BodyPoint {
  UniqueKey key; // Only used by the flutter engine
  Offset offset;
  ProblemType problemType;
  DateTime logOn;
  String description;
  DateTime startOn;
  DateTime noMoreOn;
  BodyPoint(this.key, this.offset, this.problemType, this.logOn,
      this.description, this.startOn, this.noMoreOn);
}
