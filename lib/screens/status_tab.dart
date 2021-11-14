import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:whishapp/utils/utils.dart';

class StatusTab extends HookWidget {
  const StatusTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late List<FileSystemEntity> files;

    final imageFile = useState<List<FileSystemEntity>>([]);
    final videoFile = useState<List<FileSystemEntity>>([]);

    getFiles() async {
      String currentPath = Platform.isLinux
          ? (await getHomeDirectory()) + "/Downloads/"
          : Platform.isAndroid
              ? Directory(waPath).existsSync()
                  ? waPath
                  : Directory(secWaPath).existsSync()
                      ? secWaPath
                      : ""
              : "";
      if (currentPath != "") {
        files = Directory(currentPath).listSync();
        imageFile.value = files.where((element) {
          final mimeType = lookupMimeType(element.path);
          return mimeType == null ? false : mimeType.split('/')[0] == "image";
        }).toList();
        videoFile.value = files.where((element) {
          final mimeType = lookupMimeType(element.path);
          return mimeType == null ? false : mimeType.split('/')[0] == "video";
        }).toList();
      }
    }

    final storagePerm = useState<bool>(false);

    grantStoragePermission() async {
      if (!Platform.isAndroid || await Permission.storage.request().isGranted) {
        getFiles();
        // getBackupFiles();
        storagePerm.value = true;
      }
    }

    useEffect(() {
      grantStoragePermission();
    }, []);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (MapEntry<String, ValueNotifier<List<FileSystemEntity>>> current
              in {"Photos": imageFile, "Videos": videoFile}.entries) ...[
            Text(current.key),
            current.value.value.isEmpty
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text("No ${current.key} Found"),
                  )
                : Flexible(
                    fit: FlexFit.loose,
                    child: GridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: current.value.value.length,
                      itemBuilder: (_, index) => ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => waOpenFile(
                              context, current.value.value[index].path),
                          child: MediaThumbnail(
                              file: current.value.value[index] as File),
                        ),
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        crossAxisCount: (context.width / 200 + 1 / 2).toInt(),
                      ),
                    ),
                  ),
          ],
        ],
      ),
    );
  }
}

class MediaThumbnail extends StatelessWidget {
  const MediaThumbnail({
    Key? key,
    required this.file,
  }) : super(key: key);

  final File file;

  @override
  Widget build(BuildContext context) {
    String? mimeType = lookupMimeType(basename(file.path).toLowerCase());
    String type = mimeType == null ? "" : mimeType.split("/")[0];
    return type == "image"
        ? extension(file.path) == ".svg"
            ? SvgPicture.file(
                file,
                width: 100,
                height: 100,
              )
            : Image(
                image: ResizeImage(
                  FileImage(file),
                  width: 100,
                  height: 100,
                ),
              )
        : FutureBuilder<Uint8List?>(
            future: VideoThumbnail.thumbnailData(
              video: file.path,
              imageFormat: ImageFormat.JPEG,
              maxWidth: 100,
              quality: 25,
            ),
            builder: (ctx, snap) => snap.data != null
                ? Image.memory(snap.data!)
                : const Placeholder(),
          );
  }
}
