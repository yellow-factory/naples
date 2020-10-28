//Import this file to make a ViewModel that inherits EditViewModel or SaveCancelViewModel

export 'package:naples/src/view_models/edit/edit_view_model.dart';
export 'package:naples/src/view_models/edit/save_view_model.dart';

export 'package:naples/src/view_models/edit/properties/model_property.dart';
export 'package:naples/src/view_models/edit/properties/string_property.dart';
export 'package:naples/src/view_models/edit/properties/int_property.dart';
export 'package:naples/src/view_models/edit/properties/bool_property.dart';
export 'package:naples/src/view_models/edit/properties/select_property.dart';
export 'package:naples/src/view_models/edit/properties/datetime_property.dart';
export 'package:naples/src/view_models/edit/properties/file_property.dart';
export 'package:naples/src/view_models/edit/properties/comment_property.dart';
export 'package:naples/src/view_models/edit/properties/divider_property.dart';
export 'package:naples/src/view_models/edit/properties/markdown_property.dart';
export 'package:naples/src/view_models/edit/properties/mustache_property.dart';
export 'package:naples/src/view_models/edit/properties/container_property.dart';

export 'package:naples/src/view_models/edit/dynamic_form.dart';
export 'package:naples/src/view_models/edit/save_view_model.dart';
export 'package:naples/src/view_models/edit/get_loader.dart';

//TODO: Falten la resta de tipus: "double", etc.
//       case "double":
//         //En el cas de double i DateTime hauré de fer servir:
//         //https://pub.dev/documentation/intl/latest/intl/NumberFormat-class.html
//         //https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
//         //https://pub.dev/packages/intl
//         break;

//TODO: Cal implementar el combo i el lookup
