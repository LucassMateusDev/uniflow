import 'package:uniflow/uniflow.dart';

sealed class CounterEvent extends ViewEvent {}

class IncrementCounterEvent extends CounterEvent {}

class DecrementCounterEvent extends CounterEvent {}
