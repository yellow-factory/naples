import 'package:flutter/material.dart';
import 'package:naples/src/common/common.dart';
import 'package:naples/src/widgets/file_widget.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/edit/properties/model_property.dart';

class FileProperty extends StatelessWidget with ModelProperty<String?>, Expandable {
  final int flex;
  final String label;
  final String? hint;
  final bool autofocus;
  final PredicateOf0? editable;
  final FunctionOf0<String?> getProperty;
  final ActionOf1<String?>? setProperty;
  final FunctionOf1<String?, String?>? validator;
  final FunctionOf2<String, List<int>, Future<String?>>? upload;
  final FunctionOf1<String, Future<List<int>?>>? download;
  final FunctionOf1<String, Future<String?>>? publicUrl;

  FileProperty({
    Key? key,
    required this.label,
    this.hint,
    this.autofocus = false,
    this.editable,
    required this.getProperty,
    this.setProperty,
    this.validator,
    this.flex = 1,
    this.upload,
    this.download,
    this.publicUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FileWidget(
      label: label,
      hint: hint,
      upload: (fileName, fileBytes) async {
        if (upload == null) return null;
        var id = await upload!(fileName, fileBytes);
        if (id == null) throw Exception("Upload has not returned an identifier");
        if (setProperty == null) return id;
        setProperty!(id);
        print('File id: $id');
        return id;
      },
      download: download,
      publicUrl: publicUrl,
      delete: setProperty == null ? null : () => setProperty!(null),
    );
  }
}
