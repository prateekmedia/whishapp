import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              repeat: ImageRepeat.repeatY,
              image: AssetImage('assets/background.jpeg'),
            ),
          ),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("WhishApp"),
                    Text("© Prateek SU 2021"),
                    TextButton(
                      onPressed: () {},
                      child: Text("Licenses"),
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
