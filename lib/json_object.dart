/* (C) 2013 Chris Buckett (chrisbuckett@gmail.com)
 * Released under the MIT licence
 * See LICENCE file
 * http://github.com/chrisbu/dartwatch-JsonObject
 */


library json_object;

import "dart:convert";
import "dart:async";
import 'dart:mirrors' as mirrors;
// import 'package:meta/meta.dart';

part "src/mirror_based_serializer.dart";

// Set to true to as required
var enableJsonObjectDebugMessages = false;
void _log(obj) {
  if (enableJsonObjectDebugMessages) print(obj);
}

/** JsonObject allows .property name access to JSON by using
 * noSuchMethod.
 *
 * When used with the generic type annotation,
 * it uses Dart's mirror system to return a real instance of
 * the specified type.
 */
@proxy
class JsonObject<E> extends Object implements Map, Iterable  {
  /// The original JSON string
  var _jsonString;

  /// Contains either a [List] or [Map]
  var _objectData;
  
  static JsonEncoder encoder = new JsonEncoder();
  static JsonDecoder decoder = new JsonDecoder(null);

  /**
   * Returns a [JSON.decode] representation of the underlying object data
   */
  toString() {
      return encoder.convert(_objectData);
  }

  /**
   * Returns either the underlying parsed data as an iterable list (if the
   * underlying data contains a list), or returns the map.values (if the
   * underlying data contains a map).
   *
   * Returns an empty list if neither of the above is true.
   */
  Iterable toIterable() {
    if (_objectData is Iterable) {
      return _objectData;
    }
    else if (_objectData is Map) {
      return _objectData.values;
    }
    else {
      return new List(); // return an empty list, rather than return null

    }
  }

  /** [isExtendable] decides if a new item can be added to the internal
   * map via the noSuchMethod property, or the functions inherited from the
   * map interface.
   *
   * If set to false, then only the properties that were
   * in the original map or json string passed in can be used.
   *
   * If set to true, then calling o.blah="123" will create a new blah property
   * if it didn't already exist.
   *
   * Setting this to false can help with checking for typos, and is false by
   * default when a JsonObject is created with [JsonObject.fromJsonString()]
   * or [JsonObject.fromMap()].
   * The default constructor [JsonObject()], however will set this value to
   * true, otherwise you can't actually add any new properties.
   */
  bool isExtendable;

  /** default constructor.
   * creates a new empty map.
   */
  JsonObject() {
    _objectData = new Map();
    isExtendable = true;
  }

  /** eager constructor parses the jsonString using
   *  [decode()], and
   *  replaces all maps recursively with JsonObjects
   */
  factory JsonObject.fromJsonString(String _jsonString, [JsonObject t]) {
    if (t == null) {
      t = new JsonObject();
    }
    t._jsonString = _jsonString;
    t._objectData = decoder.convert(t._jsonString);
    t._extractElements(t._objectData);
    t.isExtendable = false;
    return t;

  }

  /** An alternate constructor, allows creating directly from a map
   * rather than a json string.
   */
  JsonObject.fromMap(Map map) {
    _jsonString = encoder.convert(map);
    _objectData = map;
    _extractElements(_objectData);
    isExtendable = false;
  }

  static JsonObject toTypedJsonObject(JsonObject src, JsonObject dest) {
    dest._jsonString = src._jsonString;
    dest._objectData = src._objectData;
    dest.isExtendable = false;
    return dest;
  }

  /** noSuchMethod() is where the magic happens.
   * If we try to access a property using dot notation (eg: o.wibble ), then
   * noSuchMethod will be invoked, and identify the getter or setter name.
   * It then looks up in the map contained in _objectData (represented using
   * this (as this class implements [Map], and forwards it's calls to that
   * class.
   * If it finds the getter or setter then it either updates the value, or
   * replaces the value.
   *
   * If isExtendable = true, then it will allow the property access
   * even if the property doesn't yet exist.
   */
  noSuchMethod(Invocation mirror) {
    int positionalArgs = 0;
    if (mirror.positionalArguments != null) positionalArgs = mirror.positionalArguments.length;

    var property = _symbolToString(mirror.memberName);

    if (mirror.isGetter && (positionalArgs == 0)) {
      //synthetic getter
      if (this.containsKey(property)) {
        return this[property];
      }
    }
    else if (mirror.isSetter && positionalArgs == 1) {
      //synthetic setter
      //if the property doesn't exist, it will only be added
      //if isExtendable = true
      property = property.replaceAll("=", "");
      this[property] = mirror.positionalArguments[0]; // args[0];
      return this[property];
    }

    //if we get here, then we've not found it - throw.
    _log("Not found: ${property}");
    _log("IsGetter: ${mirror.isGetter}");
    _log("IsSetter: ${mirror.isGetter}");
    _log("isAccessor: ${mirror.isAccessor}");
    super.noSuchMethod(mirror);
  }

  /**
   * If the [data] object passed in is a MAP, then we iterate through each of
   * the values of the map, and if any value is a map, then we create a new
   * [JsonObject] replacing that map in the original data with that [JsonObject]
   * to a new [JsonObject].  If the value is a Collection, then we call this
   * function recursively.
   *
   * If the [data] object passed in is a Collection, then we iterate through
   * each item.  If that item is a map, then we replace the item with a
   * [JsonObject] created from the map.  If the item is a Collection, then we
   * call this function recursively.
   */
  _extractElements(data) {
    if (data is Map) {
      //iterate through each of the k,v pairs, replacing maps with jsonObjects
      data.forEach((key,value) {

        if (value is Map) {
          //replace the existing Map with a JsonObject
          data[key] = new JsonObject.fromMap(value);
        }
        else if (value is List) {
          //recurse
          _extractElements(value);
        }

      });
    }
    else if (data is List) {
      //iterate through each of the items
      //if any of them is a list, check to see if it contains a map

      for (int i = 0; i < data.length; i++) {
        //use the for loop so that we can index the item to replace it if req'd
        var listItem = data[i];
        if (listItem is List) {
          //recurse
          _extractElements(listItem);
        }
        else if (listItem is Map) {
          //replace the existing Map with a JsonObject
          data[i] = new JsonObject.fromMap(listItem);
        }
      }
    }

  }

  String _symbolToString(value) {
    if (value is Symbol) {
      return mirrors.MirrorSystem.getName(value);
    }
    else {
      return value.toString();
    }
  }

  /***************************************************************************
   * Iterable implementation methods and properties *
   */

  // pass through to the underlying iterator
  Iterator<E> get iterator => this.toIterable().iterator;

  Iterable map(f(E element)) => this.toIterable().map(f);

  Iterable<E> where(bool f(E element)) => this.toIterable().where(f);

  Iterable expand(Iterable f(E element)) => this.toIterable().expand(f);

  bool contains(E element) => this.toIterable().contains(element);

  dynamic reduce(E combine(E value, E element)) => this.toIterable().reduce(combine);

  bool every(bool f(E element)) => this.toIterable().every(f);

  String join([String separator]) => this.toIterable().join(separator);

  bool any(bool f(E element)) => this.toIterable().any(f);

  Iterable<E> take(int n) => this.toIterable().take(n);

  Iterable<E> takeWhile(bool test(E value)) => this.toIterable().takeWhile(test);

  Iterable<E> skip(int n) => this.toIterable().skip(n);

  Iterable<E> skipWhile(bool test(E value)) => this.toIterable().skipWhile(test);

  E get first => this.toIterable().first;

  E get last => this.toIterable().last;

  E get single => this.toIterable().single;
  
  E fold(initialValue, dynamic combine(a,b)) => this.toIterable().fold(initialValue, combine);

  @deprecated
  E firstMatching(bool test(E value), { E orElse() : null }) {
    if (orElse != null) this.toIterable().firstWhere(test, orElse: orElse);
    else this.toIterable().firstWhere(test);
  }

  @deprecated
  E lastMatching(bool test(E value), {E orElse() : null}) {
    if (orElse != null) this.toIterable().lastWhere(test, orElse: orElse);
    else this.toIterable().lastWhere(test);
  }

  @deprecated
  E singleMatching(bool test(E value)) => this.toIterable().singleWhere(test);

  E elementAt(int index) => this.toIterable().elementAt(index);

  List<dynamic> toList({ bool growable: true }) => this.toIterable().toList(growable:growable);

  Set<dynamic> toSet() => this.toIterable().toSet();

  @deprecated
  E min([int compare(E a, E b)]) { throw "Deprecated in iterable interface"; }

  @deprecated
  E max([int compare(E a, E b)]) { throw "Deprecated in iterable interface"; }

  dynamic firstWhere(test, {orElse}) => this.toIterable().firstWhere(test, orElse:orElse);
  dynamic lastWhere(test, {orElse}) => this.toIterable().firstWhere(test, orElse:orElse);
  dynamic singleWhere(test, {orElse}) => this.toIterable().firstWhere(test, orElse:orElse);
//
  /***************************************************************************
   * Map implementation methods and properties *
   *
   */

  // Pass through to the inner _objectData map.
  bool containsValue(value) => _objectData.containsValue(value);

  // Pass through to the inner _objectData map.
  bool containsKey(value) {
    return _objectData.containsKey(_symbolToString(value));
  }
  
  // Pass through to the innter _objectData map.
  bool get isNotEmpty => _objectData.isNotEmpty;

  // Pass through to the inner _objectData map.
  operator [](key) => _objectData[key];

  // Pass through to the inner _objectData map.
  forEach(func) => _objectData.forEach(func);

  // Pass through to the inner _objectData map.
  Iterable get keys => _objectData.keys;

  // Pass through to the inner _objectData map.
  Iterable get values => _objectData.values;

  // Pass through to the inner _objectData map.
  int get length => _objectData.length;

  // Pass through to the inner _objectData map.
  bool get isEmpty => _objectData.isEmpty;

  // Pass through to the inner _objectData map.
  addAll(items) => _objectData.addAll(items);

  /**
   * Specific implementations which check isExtendable to determine if an
   *
   * unknown key should be allowed
   *
   * If [isExtendable] is true, or the key already exists,
   * then allow the edit.
   * Throw [JsonObjectException] if we're not allowed to add a new
   * key
   */
  operator []=(key,value) {
    //if the map isExtendable, or it already contains the key, then
    if (this.isExtendable == true || this.containsKey(key)) {
      //allow the edit, as we don't care if it's a new key or not
      return _objectData[key] = value;
    }
    else {
      throw new JsonObjectException("JsonObject is not extendable");
    }
  }

  /** If [isExtendable] is true, or the key already exists,
   * then allow the edit.
   * Throw [JsonObjectException] if we're not allowed to add a new
   * key
   */
  putIfAbsent(key,ifAbsent()) {
    if (this.isExtendable == true || this.containsKey(key)) {
      return _objectData.putIfAbsent(key, ifAbsent);
    }
    else {
      throw new JsonObjectException("JsonObject is not extendable");
    }
  }

  /** If [isExtendable] is true, or the key already exists,
   * then allow the removal.
   * Throw [JsonObjectException] if we're not allowed to remove a
   * key
   */
  remove(key) {
    if (this.isExtendable == true || this.containsKey(key)) {
      return _objectData.remove(key);
    }
    else {
      throw new JsonObjectException("JsonObject is not extendable");
    }
  }

  /** If [isExtendable] is true, then allow the map to be cleared
   * Throw [JsonObjectException] if we're not allowed to clear.
   */
  clear() {
    if (this.isExtendable == true) {
      _objectData.clear();
    }
    else {
      throw new JsonObjectException("JsonObject is not extendable");
    }
  }  
}

/**
 * Exception class thrown by JSON Object
 */
class JsonObjectException implements Exception {
  const JsonObjectException([String message]) : this._message = message;
  String toString() => (this._message != null
                        ? "JsonObjectException: $_message"
                        : "JsonObjectException");
  final String _message;
}




