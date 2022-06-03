//Import this file to make a ViewModel that inherits EditViewModel or SaveCancelViewModel

export 'package:naples/src/edit/properties/model_property.dart';
export 'package:naples/src/edit/properties/string_property.dart';
export 'package:naples/src/edit/properties/int_property.dart';
export 'package:naples/src/edit/properties/double_property.dart';
export 'package:naples/src/edit/properties/bool_property.dart';
export 'package:naples/src/edit/properties/select_property.dart';
export 'package:naples/src/edit/properties/datetime_property.dart';
export 'package:naples/src/edit/properties/file_property.dart';
export 'package:naples/src/edit/properties/comment_property.dart';
export 'package:naples/src/edit/properties/divider_property.dart';
export 'package:naples/src/edit/properties/markdown_property.dart';
export 'package:naples/src/edit/properties/mustache_property.dart';
export 'package:naples/src/edit/properties/container_property.dart';
export 'package:naples/src/edit/properties/custom_property.dart';

export 'package:naples/src/edit/edit_view.dart';
export 'package:naples/src/edit/edit_builder.dart';
export 'package:naples/src/edit/collection_editor.dart';

//TODO: Falten la resta de tipus: "double", etc.
//       case "double":
//         //En el cas de double i DateTime hauré de fer servir:
//         //https://pub.dev/documentation/intl/latest/intl/NumberFormat-class.html
//         //https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
//         //https://pub.dev/packages/intl
//         break;

//TODO: Cal implementar el combo i el lookup
