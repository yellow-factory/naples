import 'package:naples/utils.dart';

class Validator<T> {
  final _validators = List<FunctionOf1<T, String>>();

  void add(Predicate1<T> isValid, String error) {
    _validators.add((T t) => isValid(t) ? error : null);
  }

  FunctionOf1<T, String> get value {
    return (T t) {
      String result;
      for (var isValid in _validators) {
        var partialResult = isValid(t);
        if (partialResult != null) {
          if (result == null) {
            result = partialResult;
            continue;
          }
          result = "$result\n$partialResult";
        }
      }
      return result;
    };
  }

  void required() {
    add((t) => t == null, 'Please enter some text');
  }
}

class StringValidator extends Validator<String> {
  @override
  void required() {
    add((t) => t == null || t.isEmpty, 'Please enter some text');
  }

  void maxLength(int max) {
    add((t) => t != null && t.length > max, 'Max length cannot be greater than $max');
  }

  void regularExpression(String expression, {bool caseSensitive: false, bool multiLine: false}) {
    var regExp = new RegExp(
      expression,
      caseSensitive: caseSensitive,
      multiLine: multiLine,
    );
    add((t) => !regExp.hasMatch(t), 'Is not matching the regular expression: $expression');
  }
}
