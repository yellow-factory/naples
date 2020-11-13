///Interface to implement in a Widget that can be expanded,
///has the information to be expanded
abstract class Expandable {
  int get flex;
}

abstract class IMustacheValues {
  Map<String, dynamic> mustacheValues(String locale);
}
