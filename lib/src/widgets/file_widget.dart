import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FileWidget extends StatelessWidget {
  final String label;
  final String hint;

  FileWidget({
    Key key,
    this.label,
    this.hint,
  }) : super(key: key);

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
              title: Text(label),
              subtitle: Text(hint),
              isThreeLine: true,
            ),
            ButtonBar(
              children: <Widget>[
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
                    onPressed: () {
                      print("File uploaded");
                    }),
                OutlinedButton.icon(
                  icon: Icon(Icons.cloud_download_outlined),
                  label: Text("Download"),
                  onPressed: () {
                    print("File downloaded");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
