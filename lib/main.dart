import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:whishapp/screens/screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhishApp',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
      ),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 5, initialIndex: 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text("WhishApp"),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (ctx) => const [
              PopupMenuItem(
                value: 0,
                child: Text("Settings"),
              ),
              PopupMenuItem(
                value: 1,
                child: Text("About"),
              ),
            ],
          ),
        ],
        elevation: 0.8,
        bottom: TabBar(
          isScrollable: true,
          controller: tabController,
          tabs: const [
            Tab(icon: Icon(Icons.home)),
            Tab(text: "CONTACT"),
            Tab(text: "STATUS"),
            Tab(text: "STICKERS"),
            Tab(text: "TOOLS"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          HomeTab(goToPage: (value) => tabController.animateTo(value)),
          const ContactTab(),
          const StatusTab(),
          const StickersTab(),
          const ToolsTab(),
        ],
      ),
    );
  }
}
