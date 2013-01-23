part of json_object;

/// Converts an [object] to JSON.  if the object is a List, then each item in the list
/// must be of the same type.  The default implementation is to use reflection, and will
/// convert each getter / field into a Map, on which JSON.stringify() is called.
/// The [deserializer] argument takes a custom function that will be used to convert
/// the object to a string.  The [deserializerList] is used to provide a function
/// for each class that might be encountered. (eg, Vehicle.Make could contain a
/// "Vehicle" deserializer function and a "Make" deserializer function).
dynamic objectToSerializable(Object object) {
  var result;
  
  if (object is num || 
      object is bool ||
      object is String ||
      object == null) {
    print("std");
    result = object; // is it just a standard serializable object?
  }
  else if (object is Map) {
    print("map");
    // convert the map into a serialized map.
    // each value in the map may be a complex object, so we need to test this.
    result = _serializeEachValue(object);
  }
  else if (object is List) {
    print(list);
    // is the object passed in a list?  If so, we need to convert each
    // item in the list to something that is serializable, and add it to the list
    result = new List(); 
    object.forEach((value) => result.add(objectToSerializable(value)));
  }
  else {
    print("else");
    // otherwise, it is one of our classes, in which case, we need to 
    // try and serialize it
    var instanceMirror = mirrors.reflect(object);
    result = _getFutureValues(instanceMirror);  
  }
  
  return result;
  
}


/// When we get a reflected instance, the values come back as futures.  This 
/// method waits for all the future values to be returned, and then returns
/// an object map containing the serialized values.
/// For example:
///     class {
///        String aString = "foo";       
///     }
/// 
/// becomes
///     map = {"aString":"foo"};
///
_getFutureValues(instanceMirror) {
  var objectMap; // this will contain our objects k:v pairs.
  
  if (instanceMirror.reflectee is Map == false) {
    objectMap = new Map<String,dynamic>(); 
    
    var classMirror = instanceMirror.type;
    
    // for each field (that is not private or static
    var futureValues = new List<Future>();
    
    print("Getters: ${classMirror.getters}");
    print("Variables: ${classMirror.variables}");
    
    // for each getter:
    classMirror.getters.forEach((key, getter) {
      if (!getter.isPrivate && !getter.isStatic) {
        _getFutureValue(objectMap,key,instanceMirror,getter,futureValues);
      }
    });
    
    // for each field
    classMirror.variables.forEach((key, variable) {
      print("Variable: $key:$variable");
      if (!variable.isPrivate && !variable.isStatic) {
        print("recursing: $objectMap,$key,$instanceMirror,$variable,$futureValues");
        _getFutureValue(objectMap,key,instanceMirror,variable,futureValues);
      }
    });
    
    // wait for all the future values to be retrieved
    Future.wait(futureValues); // TODO: Convert this to be really async.  
  }
  else {
    // the input is a map, so each value needs to be serialized
    objectMap = objectToSerializable(instanceMirror.reflectee);
  }
    
  return objectMap;
}

/// Adds the future value to the futureValues list.  In the future's oncomplete
/// function, if the type is a simple type, it will populate the 
/// objectMap's value for the specified key.  If it is 
_getFutureValue(objectMap, key, instanceMirror, value, futureValues) {
  Future futureValue = instanceMirror.getField(key);
  print("Getting future: $key");
  futureValue.asStream().listen((value) {
    print("FutureValue has value");
    if (value.hasValue) {
      var instanceMirror = value.value;
      if (instanceMirror.hasReflectee) {

        // If not directly serializable, we need to recurse.
        // Directly serializable are: [num], [String], [bool], [Null], [List] and [Map].
        // Lists are handled differently - ie, we assume that a list contains some
        // JSON parsed data
        if (instanceMirror.reflectee is num || 
            instanceMirror.reflectee is bool ||
            instanceMirror.reflectee is String ||
            instanceMirror.reflectee == null) {
          // directly serializable
          objectMap[key] = instanceMirror.reflectee;
        }
        else if (instanceMirror.reflectee is Map) {
          // if any of the map's values are not one of the serializable types
          // then we need to recurse
          objectMap[key] = _serializeEachValue(instanceMirror.reflectee);
        }
        else {
          // it's some non directly serializable object or a list
          // recurse
          // print("RECURSE: some other object $key");
          objectMap[key] = objectToSerializable(instanceMirror.reflectee);          
        }
      }
    }
  });
  
  futureValues.add(futureValue);
}

// each item in the map may be a simple item, or 
// a complex type.  Serialize it properly
_serializeEachValue(Map inputMap) {
  var map = new Map();
  
  inputMap.forEach((key,value) {
    map[key] = objectToSerializable(value);
  });  
  
  return map;
}
