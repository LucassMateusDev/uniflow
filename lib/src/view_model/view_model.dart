import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:uniflow/src/history/flow_history.dart';
import 'package:uniflow/src/history/view_state_history.dart';
import 'package:uniflow/src/event/view_event.dart';
import 'package:uniflow/src/state/view_state.dart';

typedef StateUpdater<S> = void Function(S newState);

/// Base class for all ViewModels in the UniFlow architecture.
///
/// Extend this class to implement your application's business logic and state management.
abstract class ViewModel<E extends ViewEvent, S extends ViewState>
    implements ValueListenable<S> {
  late final ValueNotifier<S> _stateNotifier;

  /// Returns the current state held by `_stateNotifier`.
  S get state => _stateNotifier.value;

  /// Returns the current state held by `_stateNotifier`.
  @override
  S get value => _stateNotifier.value;

  E? _currentEvent;

  /// Returns the current event being processed, if any.
  E? get currentEvent => _currentEvent;

  final FlowHistory<E> _history = FlowHistory();
  final int historyLimit;

  FlowHistory<E> get history => _history;

  /// Creates an instance of `BaseController` with a provided initial state.
  ///
  /// [initialState] The initial state for the controller.
  ViewModel(S initialState, {this.historyLimit = 50}) {
    _stateNotifier = ValueNotifier<S>(initialState);
  }

  /// Adds a listener that will be called whenever the state changes.
  ///
  /// [listener] The callback function to be called on state changes.
  @override
  void addListener(VoidCallback listener) {
    _stateNotifier.addListener(listener);
  }

  /// Removes a previously added listener.
  ///
  /// [listener] The callback function to be removed.
  @override
  void removeListener(VoidCallback listener) {
    _stateNotifier.removeListener(listener);
  }

  /// Updates the current state with a new state.
  ///
  /// [newState] The new state to update.
  void _update(S newState) {
    if (_currentEvent != null) {
      _addStateToHistory(newState);
    }
    _stateNotifier.value = newState;
  }

  /// Handles an event and updates the state using the provided updater.
  ///
  /// [event] The event to handle.
  /// [updater] The function to update the state.
  @protected
  void onEvent(E event, StateUpdater<S> updater);

  /// Adds an event to the ViewModel, triggering the event handler and state update.
  ///
  /// [event] The event to add and process.
  void addEvent(E event) {
    _currentEvent = event;
    onEvent(event, _update);
    _currentEvent = null;
  }

  /// Disposes the ViewModel and releases resources.
  void dispose() {
    _stateNotifier.dispose();
  }

  /// Adds a new state transition to the state history.
  ///
  /// [newState] The new state to record in the history.
  void _addStateToHistory(S newState) {
    if (_history.stateHistory.length >= historyLimit) {
      _history.removeFirst();
    }

    final stateHistory = ViewStateHistory(state, newState, _currentEvent!);
    _history.add(stateHistory);
  }

  /// Runs a function on a separate isolate to avoid blocking the UI thread.
  ///
  /// This is useful for CPU-intensive operations that might otherwise cause jank
  /// or unresponsiveness in the UI.
  ///
  /// - [callback]: The function to execute on the new isolate. It must be a
  ///   top-level function or a static method.
  /// - [param]: The parameter to pass to the callback function.
  ///
  /// Returns a [Future] with the result of the callback.
  Future<R> runOnIsolate<Q, R>(
    FutureOr<R> Function(Q param) callback,
    Q param,
  ) async {
    return await compute(
      callback,
      param,
      debugLabel: '$runtimeType.runOnIsolate',
    );
  }
}
