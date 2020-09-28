import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:naples/view_models/properties/properties.dart';
import 'package:provider/provider.dart';

class FileViewModelPropertyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final property = context.watch<FileViewModelProperty>();
    return Card(
        key: UniqueKey(),
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListTile(
            leading: Icon(Icons.attachment_outlined),
            title: Text(property.label()),
            subtitle: Text(property.hint()),
          ),
          ButtonBar(
            children: <Widget>[
              OutlineButton.icon(
                icon: Icon(Icons.delete_outline),
                onPressed: () {
                  print("File deleted");
                },
                label: Text("Delete"),
              ),
              OutlineButton.icon(
                  icon: Icon(Icons.cloud_upload_outlined),
                  label: Text("Upload"),
                  onPressed: () {
                    print("File uploaded");
                  }),
              OutlineButton.icon(
                icon: Icon(Icons.cloud_download_outlined),
                label: Text("Download"),
                onPressed: () {
                  print("File downloaded");
                },
              ),
            ],
          )
        ]));
  }
}
