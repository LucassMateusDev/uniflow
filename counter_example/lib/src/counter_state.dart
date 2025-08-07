import 'package:uniflow/uniflow.dart';

class CounterState extends ViewState {
  final int count;

  CounterState({required this.count});

  CounterState.initial() : count = 0;

  CounterState copyWith({int? count}) {
    return CounterState(count: count ?? this.count);
  }

  @override
  List<Object?> get props => [count];
}
