import 'dart:async';

import 'package:uniflow/src/effect/view_effect.dart';
import 'package:uniflow/src/history/view_effect_history.dart';
import 'package:uniflow/src/view_model/view_model.dart';

/// Class that provides effect emission capabilities for ViewModels.
///
/// Create an instance of this class as a variable in your ViewModel to emit effects.
///
/// Example:
/// ```dart
/// class MyViewModel extends ViewModel<MyEvent, MyState> {
///   MyViewModel() : super(MyState.initial()){
///     if you want to track history of effects, you can enable it:
///     effectEmitter.enableHistoryTracking(this);
///  }
///   final effectEmitter = EffectEmitter<MyEffect>();
///
///   @override
///   void onEvent(MyEvent event, StateUpdater<MyState> updater) {
///     // handle event and emit effects using _effectEmitter.emit(effect)
///   }
/// }
/// ```
class EffectEmitter<F extends ViewEffect> {
  final StreamController<F> _effectController = StreamController<F>.broadcast();
  ViewModel? _viewModel;

  /// Emits an effect to the stream.
  void emit(F effect) {
    _effectController.add(effect);

    if (_viewModel != null) {
      final history = _viewModel!.history;
      final currentState = _viewModel!.value;
      final currentEvent = _viewModel?.currentEvent;
      final historyEntry = ViewEffectHistory(
        effect,
        currentState,
        currentEvent,
      );
      history.add(historyEntry);
    }
  }

  /// Stream of effects that can be listened to.
  Stream<F> get effects => _effectController.stream;

  /// Disposes the effect controller and releases resources.
  void dispose() {
    _effectController.close();
  }

  /// Enables history tracking for the ViewModel.
  void enableHistoryTracking(ViewModel viewModel) {
    _viewModel = viewModel;
  }
}
