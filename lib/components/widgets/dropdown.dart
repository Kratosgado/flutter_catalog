import 'package:flutter/material.dart';

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  static const menuItems = <String>['one', 'two', 'three', 'four'];

  final List<DropdownMenuItem<String>> _dropDownMenuItems = menuItems
      .map(
        (e) => DropdownMenuItem(
          value: e,
          child: Text(e),
        ),
      )
      .toList();

  final List<PopupMenuItem<String>> _popUpMenuItems = menuItems
      .map(
        (e) => PopupMenuItem(
          value: e,
          child: Text(e),
        ),
      )
      .toList();

  String _btn1SelectedVal = 'one';
  String? _btn2SelectedVal;
  late String _btn3SelectedVal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('DropDownButton with default value'),
          trailing: DropdownButton<String>(
            items: _dropDownMenuItems,
            value: _btn1SelectedVal,
            onChanged: (String? newVal) {
              if (newVal != null) {
                setState(() {
                  _btn1SelectedVal = newVal;
                });
              }
            },
          ),
        ),
        ListTile(
          title: const Text('DropDownButton with hint'),
          trailing: DropdownButton<String>(
            items: _dropDownMenuItems,
            value: _btn2SelectedVal,
            hint: const Text('choose'),
            onChanged: (String? newVal) {
              if (newVal != null) {
                setState(() {
                  _btn2SelectedVal = newVal;
                });
              }
            },
          ),
        ),
        ListTile(
          title: const Text('Popup Menu'),
          trailing: PopupMenuButton<String>(
            itemBuilder: (ctx) => _popUpMenuItems,
            onSelected: (String newVal) {
              _btn3SelectedVal = newVal;
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("$_btn3SelectedVal is pressed")));
            },
          ),
        )
      ],
    );
  }
}
