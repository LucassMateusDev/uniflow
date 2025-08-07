import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uniflow/src/effect/effect_emitter.dart';
import 'package:uniflow/src/effect/view_effect.dart';

/// Mixin that provides effect listening capabilities for Flutter widgets.
///
/// Use this mixin to listen to effects emitted by a EffectEmitter and handle them in your widget.
///
/// Example:
/// ```dart
/// class MyWidgetState extends State<MyWidget> with EffectListener<MyWidget, MyEffect> {
///   // ...
/// }
/// ```
mixin EffectListener<T extends StatefulWidget, F extends ViewEffect>
    on State<T> {
  StreamSubscription<F>? _effectSubscription;
  EffectEmitter<F>? _effectEmitter;

  void listenToEffects(EffectEmitter<F> emitter) {
    _cancelEffectSubscription();

    _effectEmitter = emitter;

    _effectSubscription = emitter.effects.listen((effect) {
      if (mounted) {
        onEffect(effect);
      }
    });
  }

  void onEffect(F effect);

  void _cancelEffectSubscription() {
    _effectSubscription?.cancel();
    _effectSubscription = null;
  }

  @override
  void dispose() {
    _cancelEffectSubscription();
    _effectEmitter?.dispose();
    _effectEmitter = null;
    super.dispose();
  }
}
