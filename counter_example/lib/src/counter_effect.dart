import 'package:uniflow/uniflow.dart';

sealed class CounterEffect extends ViewEffect {}

class LimitReachedEffect extends CounterEffect {
  final String message = "Counter limit reached!";
}

class NegativeValueNotAllowedEffect extends CounterEffect {
  final String message = "Negative value not allowed!";
}
