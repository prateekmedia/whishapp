import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whishapp/utils/utils.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key, required this.filePath}) : super(key: key);

  final String filePath;

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late BetterPlayerController _betterPlayerController;
  late BetterPlayerDataSource _betterPlayerDataSource;

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration = const BetterPlayerConfiguration(autoPlay: true);
    _betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.file,
      widget.filePath,
    );
    _betterPlayerController = BetterPlayerController(
      betterPlayerConfiguration,
      betterPlayerDataSource: _betterPlayerDataSource,
    );

    _betterPlayerController.addEventsListener((BetterPlayerEvent event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        _betterPlayerController
            .setOverriddenAspectRatio(_betterPlayerController.videoPlayerController!.value.aspectRatio);
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async => OpenFile.open(widget.filePath),
            padding: const EdgeInsets.all(5),
            icon: const Icon(Icons.open_in_browser),
            tooltip: "Open with",
          ),
          IconButton(
            onPressed: () async {
              await Directory(appPath).create();
              await File(widget.filePath).copy(appPath + basename(widget.filePath));
              BotToast.showText(
                  text: "Saved to Device/$appName",
                  textStyle: context.textTheme.bodyText1!.copyWith(color: Colors.white));
            },
            padding: const EdgeInsets.all(5),
            icon: const Icon(Icons.download_outlined),
            tooltip: "Download",
          ),
          IconButton(
            onPressed: () async => Share.shareFiles([widget.filePath]),
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: BetterPlayer(controller: _betterPlayerController),
    );
  }
}
