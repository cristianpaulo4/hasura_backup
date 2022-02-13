import 'dart:io';
import 'dart:typed_data';
import 'package:backup_hasura/home/services/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../main.dart';
import 'package:intl/intl.dart';

class FormsWidgets extends StatefulWidget {
  const FormsWidgets({Key? key}) : super(key: key);

  @override
  _FormsWidgetsState createState() => _FormsWidgetsState();
}

class _FormsWidgetsState extends State<FormsWidgets> {
  bool _checked = false;
  final url_controller = TextEditingController();
  final pwd_controller = TextEditingController();
  final form_key = GlobalKey<FormState>();

  Future<void> _saveLocal() async {
    box.put('url', url_controller.text);
    box.put('pwd', pwd_controller.text);
    box.put('editar', _checked);
  }

  Future<void> _carregarDados() async {
    var url = box.get('url');
    var pwd = box.get('pwd');
    var editar = box.get('editar');
    setState(() {
      url_controller.text = url;
      pwd_controller.text = pwd;
      _checked = editar ?? false;
    });
  }

  Future<void> _writingInFile(String data) async {
    try {
      final format = DateFormat('dd-MM-yyyy hh-mm-ss');
      String date = format.format(DateTime.now());

      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Selecione onde quer salvar o Backup Hasura',
        fileName: 'backup-hasura-$date.txt',
      );
      File file = File(outputFile!);
      var outputAsUint8List = Uint8List.fromList(data.codeUnits);
      await file.writeAsBytes(outputAsUint8List);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _carregarDados();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: form_key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormBox(
            enabled: !_checked,
            controller: url_controller,
            header: "Url do Banco",
            placeholder: "Digite a url do banco",
            validator: (value) {
              return value!.isEmpty ? "Digite a url do banco Hasura" : null;
            },
          ),
          TextFormBox(
            enabled: !_checked,
            controller: pwd_controller,
            header: "Senha",
            placeholder: "Digite a senha do banco se houver.",
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: ToggleSwitch(
              checked: _checked,
              onChanged: (v) {
                setState(() {
                  _checked = v;
                });
                _saveLocal();
              },
              content: Text(_checked ? 'Editar Campos' : 'Salvar Campos'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          FilledButton(
            child: const Text("Fazer Backup"),
            onPressed: () async {
              if (form_key.currentState!.validate()) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return ContentDialog(
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('Aguarde...'),
                          SizedBox(
                            width: 10,
                          ),
                          ProgressRing(),
                        ],
                      ),
                    );
                  },
                );

                var data = await ServicesHasura().realizarBackup(
                  url: url_controller.text,
                  pwd: pwd_controller.text,
                );
                await _writingInFile(data.toString());
                Navigator.pop(context);
              }
            },
            style: ButtonStyle(
              padding: ButtonState.all<EdgeInsetsGeometry>(
                const EdgeInsets.all(10),
              ),
            ),
          )
        ],
      ),
    );
  }
}
