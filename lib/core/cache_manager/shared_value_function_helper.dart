library;

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedValue<T> {
  static final Random random = Random();

  static final Map<SharedValue<dynamic>, double> stateNonceMap =
      <SharedValue<dynamic>, double>{};

  static bool didWrap = false;

  /// Initalize Shared value.
  ///
  /// Internally, this inserts an [InheritedModel] widget into the widget tree.
  ///
  /// This must be done exactly once for the whole application.

  T _value;

  double? nonce;
  StreamController<T>? _controller;

  /// The key to use for storing this value in shared preferences.
  final String? key;

  /// automatically save to shared preferences when the value changes
  final bool autosave;

  SharedValue({this.key, required T value, this.autosave = false})
      : _value = value {
    _update(init: true);
  }

  /// The value held by this state.
  T get $ => _value;

  /// Update the value and rebuild the dependent widgets if it changed.
  set $(T newValue) {
    _value = newValue;
  }

  /// A stream of [$]s that gets updated everytime the internal value is changed.
  Stream<T> get stream {
    _controller ??= StreamController<T>.broadcast();
    return _controller!.stream;
  }

  /// Set [$] to [value], but only if they're different
  void setIfChanged(T value) {
    if (value == $) return;
    $ = value;
  }

  /// Set [$] to the return value of [fn],
  /// and rebuild the dependent widgets if it changed.
  void update(T Function(T) fn) {
    $ = fn(_value);
  }

  Future<void> _update({bool init = false}) async {
    // update the nonce
    nonce = random.nextDouble();
    stateNonceMap[this] = nonce!;

    // add value to stream
    _controller?.add($);

    if (!init && autosave) {
      await save();
    }
  }

  Future<T> waitUntil(bool Function(T) predicate) async {
    // short-circuit if predicate already satisfied
    if (predicate($)) return $;
    // otherwise, run predicate on every change
    await for (T value in this.stream) {
      if (predicate(value)) break;
    }
    return $;
  }

  /// Try to load the value stored at [key] in shared preferences.
  /// If no value is found, return immediately.
  /// Else, udpdate [$] and rebuild dependent widgets if it changed.
  Future<void> load() async {
    assert(key != null);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? str = pref.getString(key!);
    if (str == null) return;
    $ = deserialize(str);
  }

  /// Store the current [$] at [key] in shared preferences.
  Future<void> save() async {
    assert(key != null);
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(key!, serialize(_value));
  }

  String serialize(T obj) {
    return jsonEncode(obj); // Default JSON serialization for other types
  }

  T deserialize(String str) {
    return jsonDecode(str) as T; // Default JSON deserialization for other types
  }
}
