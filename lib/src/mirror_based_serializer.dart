part of json_object;

/// Uses mirror based reflection to convert the object passed in to a string
/// of json.  The object passed in may be any object, list or map.
/// see test_mirrors.dart for examples.
Future<String> objectToJson(Object object) {
  var completer = new Completer<String>();
  
  var onSuccess = (value) {
    _log("About to stringify: $value");
    var string = JSON.encode(value);
    completer.complete(string);
  };

  var onError = (error) {
    _log("JsonObject Future Error: $object");
    _log("Object: ${object.runtimeType}");
    _log("Stringified: ${JSON.encode(object)}");
    completer.completeError(error, error.stackTrace);
  };
  
  objectToSerializable(object).then(onSuccess, onError:onError);
  
  return completer.future;
  
}

class _KeyValuePair {
  var key;
  var value;
  
  _KeyValuePair(this.key,this.value);
}

/** Optional [key] is required in case the object passed in came from a map
 *  we need the original map's key to be able to re-constitute the map
 *  later when the future completes. 
 */ 
Future objectToSerializable(Object object, [key=null]) {
  var completer = new Completer();
    
  if (isPrimative(object)) {
    _serializeNative(object, completer, key);
  }
  else if (object is Map) {
    _serializeMap(object, completer, key);
  }
  else if (object is List) {
    _serializeList(object, completer, key);
  }
  else {
    var instanceMirror = mirrors.reflect(object);
    _serializeObject(instanceMirror, completer, key);
    // all other processing of regular classes    
  }
   
  return completer.future;
}

bool isPrimative(Object object){
  if (object is num || 
      object is bool || 
      object is String || 
      object == null) {
    return true;
  } else {
    return false;
  }
}

void _serializeNative(Object object, Completer completer, key) {
  _log("native: $object");
  // "native" object types - just complete with that type
  _complete(completer,object,key);
}

void _serializeMap(Map object, Completer completer, key) {
  _log("map: $object");
  
  // convert the map into a serialized map
  // each value in the map may itself be a complex object or a "native" type.
  // so we need to test for this  
  Map<String, Future> mapItemsToComplete = new Map<String, Future>();
  object.forEach((key,value) {
    mapItemsToComplete[key] = objectToSerializable(value,key); 
  });
  
  var onAllItemsComplete = (List keyValuePairs) {
    // at this point (via the Future.wait callback)
    // all items in the map are complete.
    // but how to match the items back to the keys?
    var mapResult = new Map();
    keyValuePairs.forEach((kv) => mapResult[kv.key] = kv.value);
    _complete(completer,mapResult,key);
  };
  
  var onItemsError = (error) => completer.completeError(error);
  
  Future.wait(mapItemsToComplete.values)
    .then(onAllItemsComplete, onError:onItemsError);
}

void _serializeList(List object, Completer completer, key) {
  _log("list: $object");
  
  // each item in the list will be an object to serialize.
  List<Future> listItemsToComplete = new List<Future>();
  object.forEach((item) {
    listItemsToComplete.add(objectToSerializable(item));
  });
  
  var onAllItemsComplete = (items) => _complete(completer,items,key);
  var onItemsError = (error) => completer.completeError(error);
  
  Future.wait(listItemsToComplete)
    .then(onAllItemsComplete, onError:onItemsError);
}

void _serializeObject(mirrors.InstanceMirror instanceMirror, Completer completer, key) {
  _log("object: $instanceMirror");
  var classMirror = instanceMirror.type;
  
  var resultMap = new Map();
  var futuresList = new List<Future>();
  
    // for each getter:
   classMirror.getters.forEach((getterKey, getter) {
      if (!getter.isPrivate && !getter.isStatic) {
        _log("getter: ${getter.qualifiedName}");
        var futureField = instanceMirror.getField(getterKey);
        _log("got future field: $futureField");

        var onGetFutureFieldError = (error) {
          _log("Error: $error");
          completer.completeError(error);
        };

        var onGetFutureFieldSuccess = (mirrors.InstanceMirror instanceMirrorField) {
          Object reflectee = instanceMirrorField.reflectee;
          _log("Got reflectee for $getterKey: ${reflectee}");
          if (isPrimative(reflectee)){
            resultMap[getterKey] = reflectee;
          } else {
            Future<String> recursed = objectToJson(reflectee).catchError(onGetFutureFieldError);
            recursed.then((json) => resultMap[getterKey] = json);
            futuresList.add(recursed);
          }
        };

        futureField.then(onGetFutureFieldSuccess, onError:onGetFutureFieldError);
        futuresList.add(futureField);
      }
    });
    
    // for each field
    classMirror.variables.forEach((varKey, variable) {
      if (!variable.isPrivate && !variable.isStatic) {
        var futureField = instanceMirror.getField(varKey);

        var onGetFutureFieldError = (error) => completer.completeError(error);

        var onGetFutureFieldSuccess = (mirrors.InstanceMirror instanceMirrorField) {
          Object reflectee = instanceMirrorField.reflectee;
          _log("Got reflectee for $varKey: ${reflectee}");
          if (isPrimative(reflectee)){
            resultMap[varKey] = reflectee;
          } else {
            Future<String> recursed = objectToJson(reflectee).catchError(onGetFutureFieldError);
            recursed.then((json) => resultMap[varKey] = json);
            futuresList.add(recursed);
          }
        };
        
        futureField.then(onGetFutureFieldSuccess, onError:onGetFutureFieldError);
        futuresList.add(futureField);
      }
      
    });  
  
    
    Future.wait(futuresList).then((vals) {
      _complete(completer,resultMap,key);
    });
    
  
}

void _complete(Completer completer, object, key) {
  if (key != null) {      
    completer.complete(new _KeyValuePair(key,object)); // complete, because we can't reflect any deeper
  }
  else {
    completer.complete(object); // complete, because we can't reflect any deeper
  }
}

///// Converts an [object] to JSON.  if the object is a List, then each item in the list
///// must be of the same type.  The default implementation is to use reflection, and will
///// convert each getter / field into a Map, on which JSON.stringify() is called.
///// The [deserializer] argument takes a custom function that will be used to convert
///// the object to a string.  The [deserializerList] is used to provide a function
///// for each class that might be encountered. (eg, Vehicle.Make could contain a
///// "Vehicle" deserializer function and a "Make" deserializer function).
//dynamic objectToSerializable(Object object) {
//  var result;
//  
//  if (object is num || 
//      object is bool ||
//      object is String ||
//      object == null) {
//    print("std");
//    result = object; // is it just a standard serializable object?
//  }
//  else if (object is Map) {
//    print("map");
//    // convert the map into a serialized map.
//    // each value in the map may be a complex object, so we need to test this.
//    result = _serializeEachValue(object);
//  }
//  else if (object is List) {
//    // is the object passed in a list?  If so, we need to convert each
//    // item in the list to something that is serializable, and add it to the list
//    result = new List(); 
//    object.forEach((value) => result.add(objectToSerializable(value)));
//  }
//  else {
//    print("else");
//    // otherwise, it is one of our classes, in which case, we need to 
//    // try and serialize it
//    var instanceMirror = mirrors.reflect(object);
//    result = _getFutureValues(instanceMirror);  
//  }
//  
//  return result;
//  
//}
//
//
///// When we get a reflected instance, the values come back as futures.  This 
///// method waits for all the future values to be returned, and then returns
///// an object map containing the serialized values.
///// For example:
/////     class {
/////        String aString = "foo";       
/////     }
///// 
///// becomes
/////     map = {"aString":"foo"};
/////
//_getFutureValues(instanceMirror) {
//  var objectMap; // this will contain our objects k:v pairs.
//  
//  if (instanceMirror.reflectee is Map == false) {
//    objectMap = new Map<String,dynamic>(); 
//    
//    var classMirror = instanceMirror.type;
//    
//    // for each field (that is not private or static
//    var futureValues = new List<Future>();
//    
//    print("Getters: ${classMirror.getters}");
//    print("Variables: ${classMirror.variables}");
//    
//    // for each getter:
//    classMirror.getters.forEach((key, getter) {
//      if (!getter.isPrivate && !getter.isStatic) {
//        _getFutureValue(objectMap,key,instanceMirror,getter,futureValues);
//      }
//    });
//    
//    // for each field
//    classMirror.variables.forEach((key, variable) {
//      print("Variable: $key:$variable");
//      if (!variable.isPrivate && !variable.isStatic) {
//        print("recursing: $objectMap,$key,$instanceMirror,$variable,$futureValues");
//        _getFutureValue(objectMap,key,instanceMirror,variable,futureValues);
//      }
//    });
//    
//    // wait for all the future values to be retrieved
//    Future.wait(futureValues); // TODO: Convert this to be really async.  
//  }
//  else {
//    // the input is a map, so each value needs to be serialized
//    objectMap = objectToSerializable(instanceMirror.reflectee);
//  }
//    
//  return objectMap;
//}
//
///// Adds the future value to the futureValues list.  In the future's oncomplete
///// function, if the type is a simple type, it will populate the 
///// objectMap's value for the specified key.  If it is 
//_getFutureValue(objectMap, key, instanceMirror, value, futureValues) {
//  Future futureValue = instanceMirror.getField(key);
//  print("Getting future: $key");
//  futureValue.asStream().listen((value) {
//    print("FutureValue has value");
//    if (value.hasValue) {
//      var instanceMirror = value.value;
//      if (instanceMirror.hasReflectee) {
//
//        // If not directly serializable, we need to recurse.
//        // Directly serializable are: [num], [String], [bool], [Null], [List] and [Map].
//        // Lists are handled differently - ie, we assume that a list contains some
//        // JSON parsed data
//        if (instanceMirror.reflectee is num || 
//            instanceMirror.reflectee is bool ||
//            instanceMirror.reflectee is String ||
//            instanceMirror.reflectee == null) {
//          // directly serializable
//          objectMap[key] = instanceMirror.reflectee;
//        }
//        else if (instanceMirror.reflectee is Map) {
//          // if any of the map's values are not one of the serializable types
//          // then we need to recurse
//          objectMap[key] = _serializeEachValue(instanceMirror.reflectee);
//        }
//        else {
//          // it's some non directly serializable object or a list
//          // recurse
//          // print("RECURSE: some other object $key");
//          objectMap[key] = objectToSerializable(instanceMirror.reflectee);          
//        }
//      }
//    }
//  });
//  
//  futureValues.add(futureValue);
//}
//
//// each item in the map may be a simple item, or 
//// a complex type.  Serialize it properly
//_serializeEachValue(Map inputMap) {
//  var map = new Map();
//  
//  inputMap.forEach((key,value) {
//    map[key] = objectToSerializable(value);
//  });  
//  
//  return map;
//}
