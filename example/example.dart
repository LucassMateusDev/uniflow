import 'package:flutter/material.dart';
import 'package:uniflow/uniflow.dart';

// =================================================================================
// STEP 1: DEFINE THE STATE (ViewState)
// =================================================================================
// The State is an immutable object that contains all the data needed
// for the UI to rebuild itself.

class CounterState extends ViewState {
  // Data that the UI will use.
  final int count;

  // Default constructor.
  CounterState({required this.count});

  // Initial state that the ViewModel will use when created.
  CounterState.initial() : count = 0;

  // Helper method to create a copy of the state with updated values.
  // This ensures state immutability.
  CounterState copyWith({int? count}) {
    return CounterState(count: count ?? this.count);
  }

  // Part of the Equatable contract.
  // Specify which properties should be used to compare two CounterState objects.
  @override
  List<Object?> get props => [count];
}

// =================================================================================
// STEP 2: DEFINE THE EVENTS (ViewEvent)
// =================================================================================
// Events represent the actions that the UI can trigger.
// Using a 'sealed class' is a good practice to ensure all event types
// are handled in the ViewModel.

sealed class CounterEvent extends ViewEvent {}

// Event to increment the counter.
class IncrementCounterEvent extends CounterEvent {}

// Event to decrement the counter.
class DecrementCounterEvent extends CounterEvent {}

// =================================================================================
// STEP 3: (OPTIONAL) DEFINE THE EFFECTS (ViewEffect)
// =================================================================================
// Effects are for one-off actions. They are not kept in the state.
// They are perfect for showing notifications, alerts, etc.

sealed class CounterEffect extends ViewEffect {}

// Effect to be triggered when the counter limit is reached.
class LimitReachedEffect extends CounterEffect {
  final String message = "Counter limit reached!";
}

// Effect to be triggered when the counter value cannot be negative.
class NegativeValueNotAllowedEffect extends CounterEffect {
  final String message = "Counter value cannot be negative!";
}

// =================================================================================
// STEP 4: CREATE THE VIEWMODEL
// =================================================================================
// The ViewModel is the heart of the business logic. It connects Events, States, and Effects.
class CounterViewModel extends ViewModel<CounterEvent, CounterState> {
  // In the constructor, we pass the initial state to the parent class (ViewModel).
  CounterViewModel() : super(CounterState.initial());

  // Create an EffectEmitter instance to handle effects.
  final effectEmitter = EffectEmitter<CounterEffect>();

  // This method is the central point where events are processed.
  @override
  void onEvent(
    CounterEvent event,
    StateUpdater<CounterState> updater, // Function to emit a new state.
  ) {
    // Use a 'switch' to handle the different types of events.
    switch (event) {
      case IncrementCounterEvent():
        if (state.count >= 10) {
          // If the limit is reached, emit an effect to the UI.
          effectEmitter.emit(LimitReachedEffect());
          return;
        }
        // If logic allows, use the 'updater' to emit a new state.
        updater(state.copyWith(count: state.count + 1));

      case DecrementCounterEvent():
        if (state.count == 0) {
          // If the counter is already zero, emit an effect to the UI.
          effectEmitter.emit(NegativeValueNotAllowedEffect());
          return;
        }
        // To decrement, simply emit a new state with the reduced value.
        updater(state.copyWith(count: state.count - 1));
    }
  }

  @override
  void dispose() {
    effectEmitter.dispose();
    super.dispose();
  }
}

// =================================================================================
// STEP 5: CONNECT THE VIEW TO THE VIEWMODEL
// =================================================================================
// The View (Widget) is responsible for rendering the state and sending events.
// We use a StatefulWidget to manage the ViewModel's lifecycle.

class CounterView extends StatefulWidget {
  const CounterView({super.key});

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView>
        // The 'EffectListener' mixin gives us the ability to listen to effects from the ViewModel.
        with
        EffectListener<CounterView, CounterEffect> {
  late final CounterViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    // 1. Create the ViewModel instance.
    _viewModel = CounterViewModel();
    // 2. Register the View to listen to effects emitted by the ViewModel.
    listenToEffects(_viewModel.effectEmitter);
  }

  @override
  void dispose() {
    // 3. It is CRUCIAL to dispose the ViewModel to release resources and avoid memory leaks.
    _viewModel.dispose();
    super.dispose();
  }

  // 4. This method is automatically called whenever the ViewModel emits an effect.
  @override
  void onEffect(CounterEffect effect) {
    switch (effect) {
      case LimitReachedEffect():
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(effect.message)));
        break;
      case NegativeValueNotAllowedEffect():
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(effect.message)));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Uniflow Counter')),
      body: Center(
        // 5. The 'ValueListenableBuilder' is the reactive bridge between the ViewModel and the UI.
        //    It listens to state changes in the ViewModel and automatically rebuilds its 'builder'
        //    whenever a new CounterState is emitted.
        child: ValueListenableBuilder<CounterState>(
          valueListenable: _viewModel, // The ViewModel is the ValueListenable.
          builder: (context, state, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Counter:'),
                Text(
                  // The UI is built using the data from 'state'.
                  '${state.count}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            // 6. When pressing the button, we send an event to the ViewModel.
            //    This starts the unidirectional data flow cycle.
            onPressed: () => _viewModel.addEvent(IncrementCounterEvent()),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => _viewModel.addEvent(DecrementCounterEvent()),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: CounterView());
  }
}
