import 'package:flutter/material.dart';
import 'package:whishapp/widgets/widgets.dart';

class HomeTab extends StatelessWidget {
  final void Function(int value) goToPage;

  const HomeTab({
    Key? key,
    required this.goToPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HomeSButton(
            onPressed: () => goToPage(1),
            text: "Contact unsaved number",
          ),
          const SizedBox(height: 20),
          HomeSButton(
            onPressed: () => goToPage(2),
            text: 'WA Status Saver',
          ),
          const SizedBox(height: 20),
          HomeSButton(
            onPressed: () => goToPage(3),
            text: 'Create Sticker pack',
          ),
          const SizedBox(height: 20),
          HomeSButton(
            onPressed: () => goToPage(4),
            text: 'Text tools',
          ),
        ],
      ),
    );
  }
}
