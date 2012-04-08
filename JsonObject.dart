#library("JsonObject");
#import("dart:json");

///JsonObject allows .property name access to JSON by using
///noSuchMethod
class JsonObject  { //todo: implement map
  var _jsonString;
  Map _objectData;
  
  /// eager constructor parses the jsonString using
  /// JSON.parse(), and
  /// replaces all maps recursively with JsonObjects 
  JsonObject.fromJsonString(this._jsonString) {
    _objectData = JSON.parse(_jsonString);   
    
    _extractMaps(_objectData);
  }
  
  JsonObject._fromMap(Map map) {
    print("creating new jsonObject from map: $map");
    _objectData = map;
    _extractMaps(_objectData);
  }
  
  _extractMaps(data) {
    if (data is Map) {
      //iterate through each of the k,v pairs, replacing maps with jsonObjects
      data.forEach((key,value) {
        
        if (value is Map) {
          //replace the existing Map with a JsonObject
          data[key] = new JsonObject._fromMap(value);
        }
        else if (value is List) {
          _extractMaps(value);
        }
        
      });
    }
    else if (data is List) {
      //iterate through each of the items
      //if any of them is a list, check to see if it contains a map
      for (int i = 0; i < data.length; i++) {
        var listItem = data[i];
        if (listItem is List) {
          print("recursing from list");
          _extractMaps(listItem);
        }
        else if (listItem is Map) {
          data[i] = new JsonObject._fromMap(listItem); 
        }
      }          
    }
        
  }
  
  noSuchMethod(String function_name, List args) {
    //print("Called: $function_name with $args");
    
    if (args.length == 0 && function_name.startsWith("get:")) {
      //synthetic getter
      var property = function_name.replaceFirst("get:", "");
      if (_objectData.containsKey(property)) {
        return _objectData[property];
      }
    }
    else if (args.length == 1 && function_name.startsWith("set:")) {
      //synthetic setter
      var property = function_name.replaceFirst("set:", "");
      if (_objectData.containsKey(property)) {
        _objectData[property] = args[0];
        return _objectData[property];
      }
    }
    
    //if we get here, then we've not found it - throw.
    throw new NoSuchMethodException(this,function_name,args);
  }
  
}
