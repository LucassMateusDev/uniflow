import 'package:uniflow/src/history/view_history.dart';
import 'package:uniflow/src/event/view_event.dart';
import 'package:uniflow/src/state/view_state.dart';

/// Stores the history of state transitions for a given event.
///
/// Used internally by UniFlow to track state changes.
class ViewStateHistory<E extends ViewEvent, S extends ViewState>
    extends ViewHistory {
  final S fromState;
  final S toState;
  final E event;

  ViewStateHistory(this.fromState, this.toState, this.event);

  @override
  String toString() {
    return 'ViewStateHistory ( event: $event, from: $fromState, to: $toState )';
  }
}
