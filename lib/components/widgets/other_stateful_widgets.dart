import 'package:flutter/material.dart';

class StatefulWidgetExample extends StatefulWidget {
  const StatefulWidgetExample({super.key});

  @override
  State<StatefulWidgetExample> createState() => _StatefulWidgetExampleState();
}

class _StatefulWidgetExampleState extends State<StatefulWidgetExample> {
  bool switchVal = true, checkBoxVal = true;
  double slider1Val = 0.5, slider2Val = 50;
  int radioVal = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text('Switch'),
        Center(
          child: Switch(
            onChanged: (value) => setState(() => switchVal = value),
            value: switchVal,
          ),
        ),
        const Divider(),
        const Text('Checkbox'),
        Checkbox(
          value: checkBoxVal,
          onChanged: (value) => setState(() => checkBoxVal = value!),
        ),
        const Divider(),
        const Text('Slider with Divisions and Label'),
        Slider(
          value: slider2Val,
          onChanged: (value) => setState(() => slider2Val = value),
          max: 100,
          divisions: 5,
          label: '${slider2Val.round()}',
        ),
        const Divider(),
        const Text('LinearProgressIndicator'),
        const LinearProgressIndicator(
          value: .4,
        ),
        const Divider(),
        const Text('CircularProgressIndicator'),
        const Center(
          child: CircularProgressIndicator(
            value: .1,
            color: Colors.green,
            backgroundColor: Colors.amber,
          ),
        ),
        const Divider(),
        const Text('Radio'),
        Row(
          children: [1, 2, 3, 4]
              .map((e) => Radio(
                  value: e,
                  groupValue: radioVal,
                  onChanged: (value) => setState(() => radioVal = value!)))
              .toList(),
        ),
        const Divider()
      ],
    );
  }
}
