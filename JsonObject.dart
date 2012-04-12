// (C) 2012 Chris Buckett (chrisbuckett@gmail.com)
// Released under the MIT licence
// See LICENCE file
// http://github.com/chrisbu/dartwatch-JsonObject


#library("JsonObject");
#import("dart:json");

///JsonObject allows .property name access to JSON by using
///noSuchMethod.
class JsonObject extends Object implements Map { 
  var _jsonString;
  Map _objectData;
  
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
  
  //default constructor.
  //creates a new empty map.
  JsonObject() {
    _objectData = new Map();
    isExtendable = true;
  }
  
  /// eager constructor parses the jsonString using
  /// JSON.parse(), and
  /// replaces all maps recursively with JsonObjects 
  JsonObject.fromJsonString(this._jsonString) {
    _objectData = JSON.parse(_jsonString);   
    
    _extractElements(_objectData);
    isExtendable = false;
  }
  
  ///An alternate constructor, allows creating directly from a map 
  ///rather than a json string.
  JsonObject.fromMap(Map map) {
    _objectData = map;
    _extractElements(_objectData);
    isExtendable = false;
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
  noSuchMethod(String function_name, List args) {
    //print("Called: $function_name with $args");
    
    if (args.length == 0 && function_name.startsWith("get:")) {
      //synthetic getter
      var property = function_name.replaceFirst("get:", "");
      if (this.containsKey(property)) {
        return this[property];
      }
    }
    else if (args.length == 1 && function_name.startsWith("set:")) {
      //synthetic setter
      var property = function_name.replaceFirst("set:", "");
      //if the property doesn't exist, it will only be added
      //if isExtendable = true
      this[property] = args[0];
      return this[property];
    }
    
    //if we get here, then we've not found it - throw.
    super.noSuchMethod(function_name, args);
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
        else if (value is Collection) {
          //recurse
          _extractElements(value);
        }
        
      });
    }
    else if (data is Collection) {
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
  Collection getKeys() => _objectData.getKeys();
  Collection getValues() => _objectData.getValues();
  int get length() => _objectData.length;
  bool isEmpty() => _objectData.isEmpty();
  
  //Specific implementations which check isExtendable to determine if an
  //unknown key should be allowed
  
  ///If [isExtendable] is true, or the key already exists,
  ///then allow the edit.  
  ///Throw [UnsupportedOperationException] if we're not allowed to add a new
  ///key
  operator []=(key,value) {
    //if the map isExtendable, or it already contains the key, then
    if (this.isExtendable == true || this.containsKey(key)) {
      //allow the edit, as we don't care if it's a new key or not
      return _objectData[key] = value;
    }
    else {
      throw new UnsupportedOperationException("JsonObject is not extendable");  
    } 
  } 
  
  ///If [isExtendable] is true, or the key already exists,
  ///then allow the edit.  
  ///Throw [UnsupportedOperationException] if we're not allowed to add a new
  ///key
  putIfAbsent(key,ifAbsent()) {
    if (this.isExtendable == true || this.containsKey(key)) {
      return _objectData.putIfAbsent(key, ifAbsent);
    }
    else {
      throw new UnsupportedOperationException("JsonObject is not extendable");  
    }
  }
   
  ///If [isExtendable] is true, or the key already exists,
  ///then allow the removal.  
  ///Throw [UnsupportedOperationException] if we're not allowed to remove a
  ///key
  remove(key) {
    if (this.isExtendable == true || this.containsKey(key)) {
      return _objectData.remove(key);
    }
    else {
      throw new UnsupportedOperationException("JsonObject is not extendable");  
    }
  }

  ///If [isExtendable] is true, then allow the map to be cleared
  ///Throw [UnsupportedOperationException] if we're not allowed to clear.
  clear() {
    if (this.isExtendable == true) {
      _objectData.clear();
    }
    else {
      throw new UnsupportedOperationException("JsonObject is not extendable");  
    }
    
  }
  
}


