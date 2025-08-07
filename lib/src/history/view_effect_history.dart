import 'package:uniflow/src/event/view_event.dart';
import 'package:uniflow/src/history/view_history.dart';
import 'package:uniflow/src/effect/view_effect.dart';
import 'package:uniflow/src/state/view_state.dart';

/// Stores the history of effects for a given event and state.
///
/// Used internally by UniFlow to track effect changes.
class ViewEffectHistory<
  E extends ViewEvent,
  S extends ViewState,
  F extends ViewEffect
>
    extends ViewHistory {
  final F effect;
  final S state;
  final E? event;

  ViewEffectHistory(this.effect, this.state, this.event);

  @override
  String toString() {
    final eventString = event != null ? ', event: $event' : '';
    return 'ViewEffectHistory ( effect: $effect, state: $state$eventString )';
  }
}
