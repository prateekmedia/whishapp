import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:path/path.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

import 'package:whishapp/utils/utils.dart';
import 'package:whishapp/widgets/widgets.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({
    Key? key,
    required this.imageFile,
    this.fetchAssets,
  }) : super(key: key);

  final Future<File> imageFile;
  final VoidCallback? fetchAssets;

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  bool _isOpen = true;
  bool _areDetailsVisible = false;
  @override
  Widget build(BuildContext context) {
    showDetails() async {
      setState(() => _areDetailsVisible = true);
      var file = await widget.imageFile;
      if (file.existsSync() && file.readAsBytesSync().isNotEmpty) {
        var img = Image.file(file);
        Completer<ui.Image> completer = Completer<ui.Image>();
        img.image.resolve(const ImageConfiguration()).addListener(ImageStreamListener((ImageInfo image, bool _) {
          completer.complete(image.image);
        }));
        ui.Image info = await completer.future;
        var newPath = (await widget.imageFile).path.replaceAll(RegExp(r'/storage/emulated/0/'), 'Internal Storage/');
        newPath = p.dirname(newPath);
        if (newPath.contains('/storage/')) {
          var listPath = p.split(p.relative(newPath));
          listPath.removeAt(0);
          newPath = p.joinAll(listPath);
          newPath = p.dirname(newPath);
        }
        showPopover(
          context: context,
          innerPadding: const EdgeInsets.all(8),
          builder: (ctx) => FutureBuilder<File>(
            future: widget.imageFile,
            builder: (context, snapshot) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Details",
                  style: context.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                          snapshot.hasData
                              ? DateFormat('dd MMMM yyy hh:mm a').format(snapshot.data!.lastModifiedSync())
                              : "",
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.image_outlined),
                    const SizedBox(width: 10),
                    Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(snapshot.hasData ? p.basename(snapshot.data!.path) : "",
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                            Text(newPath, style: context.textTheme.bodyText2),
                            Row(
                              children: [
                                Text(snapshot.hasData ? p.basename(snapshot.data!.lengthSync().getFileSize()) : "",
                                    style: context.textTheme.bodyText2),
                                const SizedBox(width: 40),
                                Text("${info.width}x${info.height}", style: context.textTheme.bodyText2),
                              ],
                            )
                          ],
                        )),
                  ],
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ).whenComplete(() => setState(() => _areDetailsVisible = false));
      }
    }

    _toggleOverlay() {
      setState(() {
        _isOpen = !_isOpen;
      });
      Future.delayed(const Duration(milliseconds: 100)).whenComplete(() => _isOpen
          ? SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values)
          : SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []));
    }

    return WillPopScope(
      onWillPop: () async {
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            AdvancedGestureDetector(
              onTap: _toggleOverlay,
              onSwipeUp: _isOpen && !_areDetailsVisible ? showDetails : null,
              onSwipeDown: _isOpen
                  ? () => context.back(
                      () => SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values))
                  : null,
              child: Container(
                alignment: Alignment.center,
                child: FutureBuilder<File>(
                  future: widget.imageFile,
                  builder: (_, snapshot) {
                    final file = snapshot.data;
                    if (file == null) return Container();
                    return PhotoView(
                      backgroundDecoration: BoxDecoration(
                        color: Colors.grey[900],
                      ),
                      imageProvider: FileImage(file),
                    );
                  },
                ),
              ),
            ),
            AnimatedAlign(
              alignment: !_isOpen ? const Alignment(0, 1.25) : const Alignment(0, 1),
              duration: const Duration(milliseconds: 200),
              child: AnimatedOpacity(
                opacity: _isOpen ? 1 : 0,
                duration: const Duration(milliseconds: 150),
                child: Material(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  color: context.isDark ? Colors.black.withAlpha(150) : Colors.white.withAlpha(150),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (Platform.isAndroid)
                        IconButton(
                          onPressed: () async => Share.shareFiles([(await widget.imageFile).path]),
                          padding: const EdgeInsets.all(5),
                          icon: const Icon(Icons.share),
                          tooltip: "Share",
                        ),
                      IconButton(
                        onPressed: () async => OpenFile.open((await widget.imageFile).path),
                        padding: const EdgeInsets.all(5),
                        icon: const Icon(Icons.open_in_browser),
                        tooltip: "Open with",
                      ),
                      IconButton(
                        onPressed: () async {
                          await Directory(appPath).create();
                          await (await widget.imageFile).copy(appPath + basename((await widget.imageFile).path));
                          BotToast.showText(
                              text: "Saved to Device/$appName",
                              textStyle: context.textTheme.bodyText1!.copyWith(color: Colors.white));
                        },
                        padding: const EdgeInsets.all(5),
                        icon: const Icon(Icons.download_outlined),
                        tooltip: "Download",
                      ),
                      IconButton(
                        onPressed: () => showPopoverWB(
                          context: context,
                          onConfirm: () async {
                            (await widget.imageFile).deleteSync();
                            context.back();
                            context.back();
                            if (widget.fetchAssets != null) widget.fetchAssets!();
                          },
                          builder: (cxt) => Text(
                            "Delete Image Permanently?",
                            style: context.textTheme.bodyText1!.copyWith(fontSize: 17),
                          ),
                        ),
                        padding: const EdgeInsets.all(5),
                        icon: const Icon(Icons.delete),
                        tooltip: "Delete",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedAlign(
              alignment: !_isOpen ? const Alignment(-1, -1.25) : const Alignment(-1, -1),
              duration: const Duration(milliseconds: 200),
              child: AnimatedOpacity(
                opacity: _isOpen ? 1 : 0,
                duration: const Duration(milliseconds: 150),
                child: SafeArea(
                  child: Material(
                    color: context.isDark ? Colors.black.withAlpha(150) : Colors.white.withAlpha(130),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: context.back,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      icon: const Icon(Icons.chevron_left),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedAlign(
              alignment: !_isOpen ? const Alignment(1, -1.25) : const Alignment(1, -1),
              duration: const Duration(milliseconds: 200),
              child: AnimatedOpacity(
                opacity: _isOpen ? 1 : 0,
                duration: const Duration(milliseconds: 150),
                child: SafeArea(
                  child: Material(
                    color: context.isDark ? Colors.black.withAlpha(150) : Colors.white.withAlpha(130),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                    ),
                    child: MaterialButton(
                      onPressed: showDetails,
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Details",
                        style: context.textTheme.headline6!.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
