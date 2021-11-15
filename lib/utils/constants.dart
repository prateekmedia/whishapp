import 'dart:io';

import 'package:path_provider/path_provider.dart';

String appName = "WhishApp";

String waPath = "/storage/emulated/0/WhatsApp/Media/.Statuses";
String secWaPath = "/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses";

Future<String> getHomeDirectory() async {
  var homeDir = (await getApplicationDocumentsDirectory()).path.split('/');
  homeDir.removeLast();
  return homeDir.join('/');
}

String appPath = Platform.isAndroid ? "/storage/emulated/0/WhishApp/" : "/home/prateeksu/WhishApp/";
