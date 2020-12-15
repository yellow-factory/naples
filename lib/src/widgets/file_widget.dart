import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:navy/navy.dart';
import 'package:path/path.dart' as p;

class FileWidget extends StatefulWidget {
  final String label;
  final String hint;
  final String fileId;
  final String fileName;
  final FunctionOf2<String, List<int>, Future<String>> upload;
  final FunctionOf1<String, Future<List<int>>> download;

  FileWidget({
    Key key,
    @required this.label,
    this.hint,
    this.upload,
    this.download,
    this.fileId,
    this.fileName,
  }) : super(key: key);

  @override
  _FileWidgetState createState() => _FileWidgetState();
}

class _FileWidgetState extends State<FileWidget> {
  String fileId;
  String fileName;

  @override
  void initState() {
    super.initState();
    fileId = widget.fileId;
    fileName = widget.fileName;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 150),
      child: Card(
        key: UniqueKey(),
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.attachment_outlined),
              title: Text(widget.label),
              subtitle: Text(widget.hint),
              isThreeLine: true,
            ),
            ButtonBar(
              children: <Widget>[
                if (fileId != null)
                  OutlinedButton.icon(
                    icon: Icon(Icons.delete_outline),
                    onPressed: () {
                      print("File deleted");
                    },
                    label: Text("Delete"),
                  ),
                OutlinedButton.icon(
                  icon: Icon(Icons.cloud_upload_outlined),
                  label: Text("Upload"),
                  onPressed: () async => await upload(),
                ),
                if (fileId != null)
                  OutlinedButton.icon(
                    icon: Icon(Icons.cloud_download_outlined),
                    label: Text("Download"),
                    onPressed: () async => await download(),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future upload() async {
    try {
      // show a dialog to open a file
      var myFile = await FilePickerCross.importFromStorage(
        //type: FileTypeCross.any,
        fileExtension: 'pdf,png',
      );
      var name = myFile.fileName;
      var id = await widget.upload(myFile.fileName, myFile.toUint8List());
      setState(() {
        fileName = name;
        fileId = id;
      });
    } catch (e) {
      print('error uploading file');
    }
    print("File uploaded");
  }

  Future download() async {
    try {
      if (fileId == null || fileId.isEmpty) return; //Aquí hauria d'ensenyar un diàleg
      var blob = await widget.download(fileId);
      var ext = p.extension(fileName).replaceFirst('.', '');
      var nameWithoutExtension = p.basenameWithoutExtension(fileName);
      var myFile = FilePickerCross(
        Uint8List.fromList(blob),
        path: nameWithoutExtension,
        fileExtension: ext,
      );
      // Shows a dialog to save a file
      var filePath = await myFile.exportToStorage();
      var name = p.basename(filePath);
      setState(() {
        fileName = name;
      });
    } catch (e) {
      print('error downloading file');
    }
    print("File downloaded");
  }
}
