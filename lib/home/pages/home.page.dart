import 'dart:io';

import 'package:backup_hasura/home/widgets/forms.widgets.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      content: Column(
        children: [
          SizedBox(
            height: 30,
            child: Row(
              children: [
                Expanded(child: MoveWindow()),
                WindowButtons(),
              ],
            ),
          ),
          Expanded(
            child: ScaffoldPage(
              padding: EdgeInsets.zero,
              header: PageHeader(
                title: Row(
                  children: [
                    const Text("Hasura Backup"),
                    const SizedBox(width: 10,),
                    Image.asset(
                      'assets/logo.png',
                      width: 30,
                    )
                  ],
                ),
              ),
              content: const Padding(
                padding: EdgeInsets.all(15),
                child: FormsWidgets(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

final buttonColors = WindowButtonColors(
  iconNormal: Color(0xFF805306),
  mouseOver: Color(0xFFF6A00C),
  mouseDown: Color(0xFF805306),
  iconMouseOver: Color(0xFF805306),
  iconMouseDown: Color(0xFFFFD500),
);

final closeButtonColors = WindowButtonColors(
  mouseOver: Color(0xFFD32F2F),
  mouseDown: Color(0xFFB71C1C),
  iconNormal: Color(0xFF805306),
  iconMouseOver: Colors.white,
);

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
