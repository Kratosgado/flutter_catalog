import "package:animated_radial_menu/animated_radial_menu.dart";
import "package:flutter/material.dart";

class RadialMenuExample extends StatelessWidget {
  const RadialMenuExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      backgroundColor: Colors.black87,
      appBar: AppBar(  
        backgroundColor: Colors.black45,
        title: const Text("Animated Radial Menu"),
        centerTitle: true,
      ),
      body: RadialMenu(  
        children: [
          RadialButton(  
            icon: const Icon(Icons.ac_unit),
            buttonColor: Colors.teal,
            onPress:() => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>  const TargetScreen()),
            ),
          ),
          RadialButton(  
            icon: const Icon(Icons.camera_alt),
            buttonColor: Colors.green,
            onPress:() => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>  const TargetScreen()),
            ),
          ),
          RadialButton(  
            icon: const Icon(Icons.map),
            buttonColor: Colors.orange,
            onPress:() => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>  const TargetScreen()),
            ),
          ),
          RadialButton(  
            icon: const Icon(Icons.alarm),
            buttonColor: Colors.indigo,
            onPress:() => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>  const TargetScreen()),
            ),
          ),
          RadialButton(  
            icon: const Icon(Icons.watch),
            buttonColor: Colors.pink,
            onPress:() => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>  const TargetScreen()),
            ),
          ),
        ],
      )
    );
  }
}

class TargetScreen extends StatelessWidget {
  const TargetScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(  title: const Text('Target Screen'),),
    );
  }
}