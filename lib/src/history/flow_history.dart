import 'package:uniflow/src/history/view_effect_history.dart';
import 'package:uniflow/src/history/view_history.dart';
import 'package:uniflow/src/history/view_state_history.dart';
import 'package:uniflow/src/event/view_event.dart';

/// Manages the history of states and effects for a ViewModel.
///
/// This class stores and provides access to the state and effect history.
class FlowHistory<E extends ViewEvent> {
  final List<ViewHistory> _history = List.empty(growable: true);

  List<ViewHistory> get history => List.unmodifiable(_history);

  List<ViewStateHistory> get stateHistory =>
      _history.whereType<ViewStateHistory>().toList();

  List<ViewEffectHistory> get effectHistory =>
      _history.whereType<ViewEffectHistory>().toList();

  void add(ViewHistory history) {
    _history.add(history);
  }

  void removeFirst() {
    if (_history.isNotEmpty) {
      _history.removeAt(0);
    }
  }
}
