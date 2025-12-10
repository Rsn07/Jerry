import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/html.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../utils/storage_helper.dart';

class EditorPage extends StatefulWidget {
  final Map<String, String> files;
  final String projectName;
  const EditorPage({super.key, required this.files, required this.projectName});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  late String currentFile;
  late CodeController codeController;
  WebViewController? webCtrl;

  @override
  void initState() {
    super.initState();
    currentFile = widget.files.keys.first;
    codeController = CodeController(text: widget.files[currentFile] ?? '', language: html);
  }

  void switchFile(String f) {
    setState(() {
      currentFile = f;
      codeController.text = widget.files[f] ?? '';
      if (f.endsWith('.html')) {
        webCtrl?.loadHtmlString(widget.files[f] ?? '');
      }
    });
  }

  void saveFile() async {
    widget.files[currentFile] = codeController.text;
    if (currentFile.endsWith('.html')) {
      webCtrl?.loadHtmlString(widget.files[currentFile]!);
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
  }

  void exportProject() async {
    final path = await StorageHelper.saveProject(widget.projectName, widget.files);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved to \$path')));
  }

  @override
  Widget build(BuildContext context) {
    final fileButtons = widget.files.keys.map((f) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: ElevatedButton(onPressed: () => switchFile(f), child: Text(f)),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.projectName), actions: [IconButton(onPressed: exportProject, icon: const Icon(Icons.save_alt))]),
      body: Row(children: [
        Expanded(
          flex: 3,
          child: Column(children: [
            SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: fileButtons)),
            Expanded(child: CodeTheme(child: CodeField(controller: codeController), data: CodeThemeData(styles: {}))),
            Row(children: [ElevatedButton(onPressed: saveFile, child: const Text('Save'))]),
          ]),
        ),
        Expanded(
          flex: 2,
          child: Column(children: [
            Expanded(
              child: WebView(
                onWebViewCreated: (ctrl) {
                  webCtrl = ctrl;
                  final html = widget.files[currentFile] ?? '<html><body></body></html>';
                  if (currentFile.endsWith('.html')) webCtrl?.loadHtmlString(html);
                },
                javascriptMode: JavascriptMode.unrestricted,
              ),
            ),
          ]),
        )
      ]),
    );
  }
}
