// (C) 2012 Chris Buckett (chrisbuckett@gmail.com)
// Released under the MIT licence
// See LICENCE file
// http://github.com/chrisbu/dartwatch-JsonObject


library json_object;

import "dart:json" as JSON;

var enableJsonObjectDebugMessages = false;
void _log(obj) { 
  if (enableJsonObjectDebugMessages) print(obj);
}

/// JsonObject allows .property name access to JSON by using
/// noSuchMethod.  
///
/// When used with the generic type annotation, 
/// it uses Dart's mirror system to return a real instance of 
/// the specified type.
class JsonObject extends Object implements Map {
  var _jsonString;
  var _objectData;

  toString() {
    if (_objectData is List) {
      return JSON.stringify(_objectData);
    }
    else {
      JSON.stringify(this);
    }
  }

  ///[isExtendable] decides if a new item can be added to the internal
  ///map via the noSuchMethod property, or the functions inherited from the
  ///map interface.
  ///
  ///If set to false, then only the properties that were
  ///in the original map or json string passed in can be used.
  ///
  ///If set to true, then calling o.blah="123" will create a new blah property
  ///if it didn't already exist.
  ///
  ///Setting this to false can help with checking for typos, and is false by
  ///default when a JsonObject is created with [JsonObject.fromJsonString()]
  ///or [JsonObject.fromMap()].
  ///The default constructor [JsonObject()], however will set this value to
  ///true, otherwise you can't actually add any new properties.
  bool isExtendable;

  // default constructor.
  // creates a new empty map.
  JsonObject() {
    _objectData = new Map();
    isExtendable = true;
  }
  
  /// eager constructor parses the jsonString using
  /// JSON.parse(), and
  /// replaces all maps recursively with JsonObjects
  factory JsonObject.fromJsonString(String _jsonString, [JsonObject t]) {
    if (t == null) {
      t = new JsonObject();
    }
    t._jsonString = _jsonString;
    t._objectData = JSON.parse(t._jsonString);
    t._extractElements(t._objectData);
    t.isExtendable = false;
    return t;

  }

  ///An alternate constructor, allows creating directly from a map
  ///rather than a json string.
  JsonObject.fromMap(Map map) {
    _jsonString = JSON.stringify(map);
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

  ///noSuchMethod() is where the magic happens.
  ///If we try to access a property using dot notation (eg: o.wibble ), then
  ///noSuchMethod will be invoked, and identify the getter or setter name.
  ///It then looks up in the map contained in _objectData (represented using
  ///this (as this class implements [Map], and forwards it's calls to that
  ///class.
  ///If it finds the getter or setter then it either updates the value, or
  ///replaces the value.
  ///
  ///If isExtendable = true, then it will allow the property access
  ///even if the property doesn't yet exist.
  noSuchMethod(InvocationMirror mirror) {
    int positionalArgs = 0;
    if (mirror.positionalArguments != null) positionalArgs = mirror.positionalArguments.length;
    
    if (mirror.isGetter && (positionalArgs == 0)) {
      //synthetic getter
      var property = mirror.memberName;
      if (this.containsKey(property)) {
        return this[property];
      }
    }
    else if (mirror.isSetter && positionalArgs == 1) {
      //synthetic setter
      var property = mirror.memberName.replaceAll("=", ""); 
      //if the property doesn't exist, it will only be added
      //if isExtendable = true
      this[property] = mirror.positionalArguments[0]; // args[0];
      return this[property];
    }

    //if we get here, then we've not found it - throw.
    _log("Not found: ${mirror.memberName}");
    _log("IsGetter: ${mirror.isGetter}");
    _log("IsSetter: ${mirror.isGetter}");
    _log("isAccessor: ${mirror.isAccessor}");
    super.noSuchMethod(mirror);
  }

  ///Private:
  ///If the [data] object passed in is a MAP, then we iterate through each of
  ///the values of the map, and if any value is a map, then we create a new
  ///[JsonObject] replacing that map in the original data with that [JsonObject]
  ///to a new [JsonObject].  If the value is a Collection, then we call this
  ///function recursively.
  ///
  ///If the [data] object passed in is a Collection, then we iterate through
  ///each item.  If that item is a map, then we replace the item with a
  ///[JsonObject] created from the map.  If the item is a Collection, then we
  ///call this function recursively.
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
        if (listItem is Collection) {
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
  
  

  //***************************************************************************
  //*** Map implementation methods and properties ***
  //Pass through to the inner _objectData map.
  bool containsValue(value) => _objectData.containsValue(value);
  bool containsKey(value) => _objectData.containsKey(value);
  operator [](key) => _objectData[key];
  forEach(func(key,value)) => _objectData.forEach(func);
  Collection get keys => _objectData.keys;
  Collection get values => _objectData.values;
  int get length => _objectData.length;
  bool get isEmpty => _objectData.isEmpty;

  //Specific implementations which check isExtendable to determine if an
  //unknown key should be allowed

  ///If [isExtendable] is true, or the key already exists,
  ///then allow the edit.
  ///Throw [JsonObjectException] if we're not allowed to add a new
  ///key
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

  ///If [isExtendable] is true, or the key already exists,
  ///then allow the edit.
  ///Throw [JsonObjectException] if we're not allowed to add a new
  ///key
  putIfAbsent(key,ifAbsent()) {
    if (this.isExtendable == true || this.containsKey(key)) {
      return _objectData.putIfAbsent(key, ifAbsent);
    }
    else {
      throw new JsonObjectException("JsonObject is not extendable");
    }
  }

  ///If [isExtendable] is true, or the key already exists,
  ///then allow the removal.
  ///Throw [JsonObjectException] if we're not allowed to remove a
  ///key
  remove(key) {
    if (this.isExtendable == true || this.containsKey(key)) {
      return _objectData.remove(key);
    }
    else {
      throw new JsonObjectException("JsonObject is not extendable");
    }
  }

  ///If [isExtendable] is true, then allow the map to be cleared
  ///Throw [JsonObjectException] if we're not allowed to clear.
  clear() {
    if (this.isExtendable == true) {
      _objectData.clear();
    }
    else {
      throw new JsonObjectException("JsonObject is not extendable");
    }

  }

}


class JsonObjectException implements Exception {
  const JsonObjectException([String message]) : this._message = message;
  String toString() => (this._message != null
                        ? "JsonObjectException: $_message"
                        : "JsonObjectException");
  final String _message;
}




