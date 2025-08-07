import 'package:counter_example/src/counter_effect.dart';
import 'package:counter_example/src/counter_event.dart';
import 'package:counter_example/src/counter_state.dart';
import 'package:counter_example/src/counter_view_model.dart';
import 'package:flutter/material.dart';
import 'package:uniflow/uniflow.dart';

class CounterView extends StatefulWidget {
  const CounterView({super.key});

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView>
    with EffectListener<CounterView, CounterEffect> {
  late final CounterViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CounterViewModel();
    listenToEffects(_viewModel.effectEmitter);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

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
        child: ValueListenableBuilder<CounterState>(
          valueListenable: _viewModel,
          builder: (context, state, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Counter:'),
                Text(
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
