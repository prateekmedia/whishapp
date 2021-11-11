import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:whishapp/screens/common/image_screen.dart';

waOpenFile(context, String path, {VoidCallback? fetchAssets}) {
  String? mimeType = lookupMimeType(basename(path).toLowerCase());
  String type = mimeType == null ? "" : mimeType.split("/")[0];
  switch (type) {
    case "image":
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ImageScreen(imageFile: Future.value(File(path)), fetchAssets: fetchAssets),
        ),
      );
      break;
    case "video":
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => VideoScreen(
      //         videoFile: Future.value(File(path)), fetchAssets: fetchAssets),
      //   ),
      // );
      break;
    default:
      OpenFile.open(path);
      break;
  }
}
