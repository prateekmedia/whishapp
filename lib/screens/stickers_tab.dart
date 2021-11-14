import 'package:flutter/material.dart';

class StickersTab extends StatelessWidget {
  const StickersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int stickers = 0;

    return Stack(
      children: [
        if (stickers == 0)
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => debugPrint("Add new sticker pack"),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, size: 60),
                  Text("Create new sticker pack"),
                ],
              ),
            ),
          ),
        if (stickers > 0)
          Align(
            alignment: const Alignment(0.96, 0.96),
            child: FloatingActionButton(
              tooltip: "Add New Sticker Pack",
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          )
      ],
    );
  }
}
