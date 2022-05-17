import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:navy/navy.dart';
//import 'package:path/path.dart' as p;
import 'package:flutter/services.dart';

class FileWidget extends StatefulWidget {
  final String label;
  final String? hint;
  final String? fileId;
  final String? fileName;
  final FunctionOf2<String, List<int>, Future<String?>>? upload;
  final FunctionOf1<String, Future<List<int>?>>? download;
  final FunctionOf1<String, Future<String?>>? publicUrl;
  final ActionOf0? delete;

  const FileWidget({
    Key? key,
    required this.label,
    this.hint,
    this.upload,
    this.download,
    this.publicUrl,
    this.delete,
    this.fileId,
    this.fileName,
  }) : super(key: key);

  @override
  _FileWidgetState createState() => _FileWidgetState();
}

class _FileWidgetState extends State<FileWidget> {
  String? fileId;
  String? fileName;
  late bool waiting;

  @override
  void initState() {
    super.initState();
    waiting = false;
    fileId = widget.fileId;
    fileName = widget.fileName;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 150),
      child: Card(
        key: UniqueKey(),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ListTile(
              title: Text(widget.label),
              subtitle: widget.hint == null ? null : Text(widget.hint!),
              isThreeLine: true,
            ),
            if (fileName != null && fileName!.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.attachment_outlined),
                title: Text(fileName!),
              ),
            ButtonBar(
              children: <Widget>[
                if (fileId != null)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.delete_outline),
                    label: const Text("Delete"),
                    onPressed: () => delete(),
                  ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.cloud_upload_outlined),
                  label: const Text("Upload"),
                  onPressed: () async => await upload(),
                ),
                if (fileId != null)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.cloud_download_outlined),
                    label: const Text("Download"),
                    onPressed: () async => await download(),
                  ),
                if (fileId != null)
                  OutlinedButton.icon(
                    onPressed: () async => await publicUrl(),
                    icon: const Icon(Icons.copy),
                    label: const Text("Copy URL to Clipboard"),
                  ),
              ],
            ),
            if (waiting) const LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }

  void delete() {
    if (widget.delete == null) return;
    setState(() {
      fileName = null;
      fileId = null;
    });
    widget.delete!();
  }

  Future publicUrl() async {
    if (widget.publicUrl == null) return;
    if (fileId == null || fileId!.isEmpty) return; //Aquí hauria d'ensenyar un diàleg
    var url = await widget.publicUrl!(fileId!);
    Clipboard.setData(ClipboardData(text: url));
  }

  Future upload() async {
    try {
      if (widget.upload == null) return;
      // show a dialog to open a file
      final typeGroup = XTypeGroup(label: 'documents', extensions: ['pdf', 'png']);
      final file = await openFile(acceptedTypeGroups: [typeGroup]);
      if (file == null) return;
      setState(() {
        waiting = true;
      });
      var id = await widget.upload!(file.name, await file.readAsBytes());
      setState(() {
        fileName = file.name;
        fileId = id;
      });
    } catch (e) {
      print('error uploading file: $e');
    } finally {
      setState(() {
        waiting = false;
      });
    }
  }

  Future download() async {
    try {
      if (fileId == null || fileId!.isEmpty) return; //Aquí hauria d'ensenyar un diàleg
      if (widget.download == null) return;
      final path = await getSavePath(suggestedName: fileName);
      if (path == null) return;
      var blob = await widget.download!(fileId!);
      if (blob == null) throw Exception("File is empty");
      final data = Uint8List.fromList(blob);
      //final mimeType = "application/pdf";
      final file = XFile.fromData(data, name: fileName); //, mimeType: mimeType
      setState(() {
        waiting = true;
      });
      await file.saveTo(path);
    } catch (e) {
      print('error downloading file');
    } finally {
      setState(() {
        waiting = false;
      });
    }
  }
}
