import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:whishapp/utils/utils.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLandscape = context.queryData.orientation == Orientation.landscape;
    Widget logo = const FlutterLogo(size: 70);

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
              body: FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    return Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isLandscape) ...[logo, const SizedBox(width: 10)],
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                appName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                "Version ${snapshot.data != null ? snapshot.data!.version : 0.0}",
                                style: context.textTheme.bodyText2!,
                              ),
                              const SizedBox(height: 10),
                              if (!isLandscape) ...[
                                logo,
                                const SizedBox(height: 10),
                              ],
                              Text(
                                "© Prateek SU 2021",
                                style: context.textTheme.bodyText2!,
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.blue[300]),
                                onPressed: () =>
                                    showLicensePage(context: context),
                                child: const Text("Licenses"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  })),
        ),
      ],
    );
  }
}
