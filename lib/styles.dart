import 'package:flutter/material.dart';
import 'dart:math';

const sweepGradient = BoxDecoration(
  shape: BoxShape.circle,
  gradient: SweepGradient(
    startAngle: 3.14 / 6,
    endAngle: pi * 1.8,
    colors: [
      Colors.blue,
      Colors.yellow,
      Colors.red,
      Colors.blueAccent,
    ],
  ),
);
