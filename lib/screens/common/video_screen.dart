import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:path/path.dart';

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
    BetterPlayerConfiguration betterPlayerConfiguration = const BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
      autoPlay: true,
      looping: true,
    );
    _betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.file,
      widget.filePath,
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(_betterPlayerDataSource);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(basenameWithoutExtension(widget.filePath)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(controller: _betterPlayerController),
          ),
        ],
      ),
    );
  }
}
