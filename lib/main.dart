import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hive/hive.dart';

import 'home/pages/home.page.dart';

var box;

Future<void> main() async {
  var path = Directory.current.path;
  Hive.init(path);
  box = await Hive.openBox('testBox');

  runApp(const MyApp());
  doWhenWindowReady(() {
    final win = appWindow;
    final initialSize = Size(600, 350);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "Custom window with Flutter";
    win.maxSize = initialSize;
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Hasura Backup',
      theme: ThemeData(
        typography: const Typography(
          caption: TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
