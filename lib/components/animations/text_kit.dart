import "package:flutter/material.dart";
import "package:animated_text_kit/animated_text_kit.dart";

const kTexts = [
  'Hello world',
  'My name is Mbeah',
  'Who are you',
  'I love you',
  'What are we doing today'
];
const kTextStyle = TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.blueAccent);

class AnimatedTextKitExample extends StatelessWidget {
  const AnimatedTextKitExample({super.key});

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = Theme.of(context).textTheme.headlineSmall;
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        Text(
          'TextLiquidFill',
          style: titleTextStyle,
        ),
        TextLiquidFill(
          text: 'LIQUIDY',
          waveColor: Colors.blueAccent,
          boxBackgroundColor: Colors.red[100]!,
          textStyle: const TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.bold,
          ),
          boxHeight: 100,
        ),
        const Divider(),
        Text(
          'RotateAnimatedTextKit',
          style: titleTextStyle,
        ),
        SizedBox(
          height: 64,
          child: AnimatedTextKit(
              animatedTexts: [
                for (final txt in kTexts)
                  RotateAnimatedText(
                    txt,
                    textStyle: kTextStyle,
                    textAlign: TextAlign.start,
                  ),
              ],
              onTap: () => debugPrint("Tap Event"),
              onFinished: () => showDialog(
                  context: context,
                  builder: (context) =>
                      const AlertDialog(title: Text("done"), content: Text("okay now")))),
        ),
        const Divider(),
        Text(
          'FadeAnimatedTextKit',
          style: titleTextStyle,
        ),
        SizedBox(
          height: 64,
          child: AnimatedTextKit(
            animatedTexts: [
              for (final txt in kTexts)
                FadeAnimatedText(
                  txt,
                  textStyle: kTextStyle,
                  textAlign: TextAlign.start,
                ),
            ],
            onTap: () => debugPrint("Tap Event"),
            repeatForever: true,
          ),
        ),
        const Divider(),
        Text(
          'TyperAnimatedTextKit',
          style: titleTextStyle,
        ),
        SizedBox(
          height: 64,
          child: AnimatedTextKit(
            animatedTexts: [
              for (final txt in kTexts)
                TyperAnimatedText(
                  txt,
                  textStyle: kTextStyle,
                  textAlign: TextAlign.start,
                ),
            ],
            onTap: () => debugPrint("Tap Event"),
            repeatForever: true,
          ),
        ),
        const Divider(),
        Text(
          'WavyAnimatedTextKit',
          style: titleTextStyle,
        ),
        SizedBox(
          height: 64,
          child: AnimatedTextKit(
            animatedTexts: [
              for (final txt in kTexts)
                WavyAnimatedText(
                  txt,
                  textStyle: kTextStyle,
                  textAlign: TextAlign.start,
                ),
            ],
            onTap: () => debugPrint("Tap Event"),
            isRepeatingAnimation: true,
          ),
        ),
        const Divider(),
        Text(
          'ScaleAnimatedTextKit',
          style: titleTextStyle,
        ),
        SizedBox(
          height: 64,
          child: AnimatedTextKit(
            animatedTexts: [
              for (final txt in kTexts)
                ScaleAnimatedText(
                  txt,
                  textStyle: kTextStyle,
                  textAlign: TextAlign.start,
                ),
            ],
            onTap: () => debugPrint("Tap Event"),
            isRepeatingAnimation: true,
            onFinished: () => const AlertDialog(
              title: Text("done"),
            ),
          ),
        ),
      ],
    );
  }
}
