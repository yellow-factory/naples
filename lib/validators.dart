import 'package:flutter/material.dart';
import 'package:naples/utils.dart';
import 'package:naples/l10n/generated/naples_localizations.dart';

//TODO: Localize Validators
//TODO: Make tests of validators

class Validator<T> {
  final BuildContext context;
  final _validators = List<FunctionOf1<T, FunctionOf<String>>>();

  Validator(this.context);

  void add(PredicateOf1<T> isNotValid, FunctionOf<String> error) {
    _validators.add((T t) => isNotValid(t) ? error : null);
  }

  FunctionOf1<T, String> get value {
    return (T t) {
      String result;
      for (var isValid in _validators) {
        var partialResult = isValid(t);
        if (partialResult != null) {
          if (result == null) {
            result = partialResult();
            continue;
          }
          result = "$result\n$partialResult";
        }
      }
      return result;
    };
  }

  void required() {
    add((t) => t == null,
        () => NaplesLocalizations.of(context).helloNaples); // 'Please enter some text');
  }
}

class StringValidator extends Validator<String> {
  StringValidator(BuildContext context) : super(context);

  @override
  void required() {
    add((t) => t == null || t.isEmpty,
        () => NaplesLocalizations.of(context).helloNaples); //'Please enter some text');
  }

  void maxLength(int max) {
    add((t) => t != null && t.length > max, () => 'Max length cannot be greater than $max');
  }

  void regularExpression(String expression, {bool caseSensitive: false, bool multiLine: false}) {
    var regExp = new RegExp(
      expression,
      caseSensitive: caseSensitive,
      multiLine: multiLine,
    );
    add((t) => !regExp.hasMatch(t), () => 'Is not matching the regular expression: $expression');
  }
}

class NumberValidator extends Validator<num> {
  NumberValidator(BuildContext context) : super(context);

  @override
  void required() {
    add((t) => t == null || t == 0, () => 'Please enter some number different than zero');
  }

  void positive() {
    add((t) => t == null || t < 0, () => 'Please enter a positive number');
  }

  void negative() {
    add((t) => t == null || t > 0, () => 'Please enter a negative number');
  }

  void max(int max) {
    add((t) => t != null && t > max, () => 'Please enter a number lower than $max');
  }

  void min(int min) {
    add((t) => t != null && t < min, () => 'Please enter a number greater than $max');
  }

  void range(int min, int max) {
    add((t) => t != null && t > min && t < max,
        () => 'Please enter a number between $min and $max');
  }
}
