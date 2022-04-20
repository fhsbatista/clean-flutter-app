// Mocks generated by Mockito 5.1.0 from annotations
// in fordev/test/infra/cache/local_storage_adapter.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:flutter/foundation.dart' as _i2;
import 'package:localstorage/localstorage.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeValueNotifier_0<T> extends _i1.Fake implements _i2.ValueNotifier<T> {
}

/// A class which mocks [LocalStorage].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalStorage extends _i1.Mock implements _i3.LocalStorage {
  MockLocalStorage() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.ValueNotifier<Error> get onError => (super.noSuchMethod(
      Invocation.getter(#onError),
      returnValue: _FakeValueNotifier_0<Error>()) as _i2.ValueNotifier<Error>);
  @override
  set onError(_i2.ValueNotifier<Error>? _onError) =>
      super.noSuchMethod(Invocation.setter(#onError, _onError),
          returnValueForMissingStub: null);
  @override
  _i4.Future<bool> get ready => (super.noSuchMethod(Invocation.getter(#ready),
      returnValue: Future<bool>.value(false)) as _i4.Future<bool>);
  @override
  set ready(_i4.Future<bool>? _ready) =>
      super.noSuchMethod(Invocation.setter(#ready, _ready),
          returnValueForMissingStub: null);
  @override
  _i4.Stream<Map<String, dynamic>> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<Map<String, dynamic>>.empty())
          as _i4.Stream<Map<String, dynamic>>);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  dynamic getItem(String? key) =>
      super.noSuchMethod(Invocation.method(#getItem, [key]));
  @override
  _i4.Future<void> setItem(String? key, dynamic value,
          [Object Function(Object)? toEncodable]) =>
      (super.noSuchMethod(
          Invocation.method(#setItem, [key, value, toEncodable]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> deleteItem(String? key) =>
      (super.noSuchMethod(Invocation.method(#deleteItem, [key]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> clear() => (super.noSuchMethod(Invocation.method(#clear, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
}
