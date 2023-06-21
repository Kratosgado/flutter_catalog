import 'dart:ui';
import 'package:flutter/material.dart';

class ImageFilteredExample extends StatefulWidget {
  const ImageFilteredExample({super.key});

  @override
  State<ImageFilteredExample> createState() => _ImageFilteredExampleState();
}

class _ImageFilteredExampleState extends State<ImageFilteredExample> {
  double sigmaX = 0, sigmaY = 0, rotZ = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(4),
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaX),
          child: const FlutterLogo(
            size: 200,
          ),
        ),
        ImageFiltered(
          imageFilter: ImageFilter.matrix(Matrix4.rotationZ(rotZ).storage),
          child: const Text(
            "Not only can images be 'filterd', in fact any widget"
            "can be placed under ImageFiltered",
          ),
        ),
        const Divider(),
        ...controlWidget(),
      ],
    );
  }

  List<Widget> controlWidget() {
    return [
      Row(
        children: [
          const Text('sigmaX'),
          Expanded(
            child: Slider(
              max: 20,
              value: sigmaX,
              onChanged: (value) => setState(() => sigmaX = value),
            ),
          ),
          Text(sigmaX.toStringAsFixed(1)),
        ],
      ),
      Row(
        children: [
          const Text('sigmaY'),
          Expanded(
            child: Slider(
              max: 20,
              value: sigmaY,
              onChanged: (value) => setState(() => sigmaY = value),
            ),
          ),
          Text(sigmaY.toStringAsFixed(1)),
        ],
      ),
      Row(
        children: [
          const Text('rotationZ: '),
          Expanded(
            child: Slider(
              max: 1.6,
              min: -1.6,
              value: rotZ,
              onChanged: (value) => setState(() => rotZ = value),
            ),
          ),
          Text(rotZ.toStringAsFixed(1)),
        ],
      ),
    ];
  }
}
