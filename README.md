# uniflow

A lightweight Flutter package for building reactive, testable, and scalable apps using the MVI (Model-View-Intent) architecture and Stateflow pattern. 

**uniflow** is based on Flutter's native `ValueListenable` and provides a simple, unidirectional data flow for your app's state, events, and effects.

---

## Features

- Native integration with Flutter's `ValueListenable` for efficient UI updates
- MVI architecture: clear separation of State, Event, Effect, and ViewModel
- Stateflow pattern for predictable, unidirectional data flow
- Effect system for one-off actions (snackbars, dialogs, navigation, etc.)
- Built-in `runOnIsolate` for offloading heavy computations
- Simple, testable, and scalable code structure
- No external dependencies beyond Flutter and Equatable

---

## Getting started

Add uniflow to your `pubspec.yaml`:

```yaml
dependencies:
  uniflow: 1.0.0
```

Import in your Dart code:

```dart
import 'package:uniflow/uniflow.dart';
```

---

## Usage

Here's a generic example of how to use uniflow in your Flutter project:

```dart
// 1. Define your State by extending ViewState
class MyState extends ViewState { /* ... */ }

// 2. Define your Events by extending ViewEvent
sealed class MyEvent extends ViewEvent {}

// 3. (Optional) Define your Effects by extending ViewEffect
sealed class MyEffect extends ViewEffect {}

// 4. Create your ViewModel by extending ViewModel and (optionally) using EffectEmitter
class MyViewModel extends ViewModel<MyEvent, MyState> {
  MyViewModel() : super(/* initial state */) {
    // if you want to track history of effects, you can enable it: 
    effectEmitter.enableHistoryTracking(this);
  }
  
  final effectEmitter = EffectEmitter<MyEffect>(); // Optional: for effects
  
  @override
  void onEvent(/* ... */) { 
    // Handle events and optionally emit effects using _effectEmitter.emit(effect)
  }
}

// 5. Connect your View (Widget) to the ViewModel using ValueListenableBuilder
//    and (optionally) listen to effects with EffectListener.

// Example of using EffectListener:
class _MyWidgetState extends State<MyWidget> with EffectListener<MyWidget, MyEffect> {
  late final MyViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MyViewModel();
    // Listen to effects from the ViewModel
    listenToEffects(_viewModel.effectEmitter);
  }

  @override
  void onEffect(MyEffect effect) {
    // Handle the effect (e.g., show a SnackBar, navigate, etc.)
  }

  @override
  Widget build(BuildContext context) {}
}
```

For a complete usage example, see the [`example/`](example/) folder.

---

## Architecture

<div align="center">
  <img src="https://raw.githubusercontent.com/LucassMateusDev/uniflow/refs/heads/main/assets/images/architecture_diagram.jpg" alt="Logo" width="300"/>
</div>

- **State**: Immutable data for your UI
- **Event**: User or system actions
- **Effect**: One-off actions (snackbars, navigation, etc.)
- **ViewModel**: Handles business logic, processes events, updates state, and emits effects
- **View**: Flutter widgets that render state and send events

The uniflow package is inspired by the Stateflow pattern and leverages Flutter's `ValueListenable` for efficient, native state management.

---

## Additional information

- For more details and advanced usage, see the [example](example/) folder.
- Contributions, issues, and suggestions are welcome!
- MIT License
