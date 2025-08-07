// ignore_for_file: avoid_print

import 'package:counter_example/src/counter_effect.dart';
import 'package:counter_example/src/counter_event.dart';
import 'package:counter_example/src/counter_state.dart';
import 'package:uniflow/uniflow.dart';

class CounterViewModel extends ViewModel<CounterEvent, CounterState> {
  CounterViewModel() : super(CounterState.initial()) {
    effectEmitter.enableHistoryTracking(this);
  }

  final effectEmitter = EffectEmitter<CounterEffect>();

  @override
  void onEvent(CounterEvent event, StateUpdater<CounterState> updater) {
    switch (event) {
      case IncrementCounterEvent():
        if (state.count >= 10) {
          effectEmitter.emit(LimitReachedEffect());
          return;
        }
        updater(state.copyWith(count: state.count + 1));
      case DecrementCounterEvent():
        if (state.count <= 0) {
          effectEmitter.emit(NegativeValueNotAllowedEffect());
          return;
        }
        updater(state.copyWith(count: state.count - 1));
    }
  }
}
