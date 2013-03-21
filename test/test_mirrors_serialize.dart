part of json_object_test;

// classes that we will try and serialize
class Basic {
  String aString = "This is a string";
  bool aBool = true;
  num aNum = 123;
  double aDouble = 234.56;
  int anInt = 234;
  var aNull = null;
  final aFinal = "final";
}

class ContainsBasicList {
  List<String> strings = ["aaa","bbb","ccc"];
  List<int> ints = [1,2,3,4];
  List<double> doubles = [1.1,2.2,3.3];
  List nulls = [null, null];
  List bools = [true,false,true];
  List mixed = ["String",123,true,null];
}

class ContainsBasicMap {
  Map<String,String> strings = {"Foo":"Foo1","Bar":"Bar1"};
  Map<String,int> stringInts = {"Foo":1,"Bar":2};
  Map<String,bool> stringBools = {"Foo":true,"Bar":false};
  Map mixed = {"nullVal":null,"string":"aString","aNum":123};
  
}

class ContainsGetters {
  String _aString = "This is a string";
  String get aString => _aString;
  
  bool _aBool = true;
  bool get aBool => _aBool;
  set aBool(value) => _aBool = value;
  
  num _aNum = 123;
  num get aNum => _aNum;
  set aNum(value) => _aNum = value;
  
  double _aDouble = 234.56;
  double get aDouble => _aDouble;
  set aDouble(value) => _aDouble = value;
  
  int _anInt = 234;
  int get anInt => _anInt;
  set anInt(value) => _anInt = value;
  
  var _aNull = null;
  get aNull => _aNull;
  set aNull(value) => _aNull = value;
  
  final _aFinal = "final";
  get aFinal => _aFinal;
}

class ContainsGettersAndObject {
  String _aString = "This is a string";
  String get aString => _aString;
  
  bool _aBool = true;
  bool get aBool => _aBool;
  set aBool(value) => _aBool = value;
  
  num _aNum = 123;
  num get aNum => _aNum;
  set aNum(value) => _aNum = value;
  
  double _aDouble = 234.56;
  double get aDouble => _aDouble;
  set aDouble(value) => _aDouble = value;
  
  int _anInt = 234;
  int get anInt => _anInt;
  set anInt(value) => _anInt = value;
  
  var _aNull = null;
  get aNull => _aNull;
  set aNull(value) => _aNull = value;
  
  final _aFinal = "final";
  get aFinal => _aFinal;
  
  Basic _basic = new Basic();
  Basic get basic => _basic;
  set basic(value) => _basic = value;
}

class ContainsStatic {
  static String iAmStatic = "static";
  
  var iAmInstance = "instance";
}

class ContainsPrivate {
  var _iAmPrivate = "private";
  
  var iAmPublic = "public";
}

class ContainsMethods {
  _privateMethod() => "private method";
  
  publicMethod() => "public method";
  
  var field = "serialize me";
}

class AnObject {
  Basic basic = new Basic();
}

class ContainsSimpleObject {
  AnObject anObject = new AnObject();
  AnObject anObject2 = new AnObject();
  AnObject anObject3 = new AnObject();
  List<AnObject> objects = new List<AnObject>();
  Map<String, AnObject> objMap = new Map<String, AnObject>();
  
  ContainsSimpleObject() {
    objects.add(new AnObject());
    objects.add(new AnObject());
    objMap["aaa"] = new AnObject();
    objMap["bbb"] = new AnObject();
  }
}

class ContainsObject {
  Basic basic = new Basic();
  String aString = "aString";
}

class ContainsObjectList {
  List<Basic> basicList = new List<Basic>();
  String aString = "aString";
  
  ContainsObjectList() {
    basicList.add(new Basic());
    basicList.add(new Basic());
  }
}

class ContainsObjectMap {
  Map<String, Basic> basicMap = new Map<String,Basic>();
  Map<String, ContainsObject> objectMap = new Map<String,ContainsObject>();
  Map<String, ContainsObjectList> objectListMap = new Map<String, ContainsObjectList>();
  Map<String, List<Basic>> listObjectMap = new Map<String,List<Basic>>();
  
  ContainsObjectMap() {
    basicMap["basic1"] = new Basic();
    basicMap["basic2"] = new Basic();
    
    objectMap["object1"] = new ContainsObject();
    objectMap["object2"] = new ContainsObject();
    
    objectListMap["objectList1"] = new ContainsObjectList();
    objectListMap["objectList2"] = new ContainsObjectList();
    
    listObjectMap["list1"] = new List<Basic>();
    listObjectMap["list1"].add(new Basic());
    listObjectMap["list1"].add(new Basic());
    listObjectMap["list2"] = new List<Basic>();
    listObjectMap["list2"].add(new Basic());
  }
}



// Main test method

testMirrorsSerialize() {
  
  group('mirrors:', () {
    var obj = new ContainsSimpleObject();
    test('ContainsSimpleObject', () =>
        objectToJson(obj).then((string) => print("--> $string"))
    );
    
    /* There are two types of objects: 
     1. Those that contain ONLY 
     basic seralizable types num, String, bool, Null, or Maps and lists
     that only contain the serializable types.
     2. Those that contain child objects, or maps and lists of child objects
     (possibly along with the serializable types).
     */
    
    group('native', () {
      // "native" types should be parsed in exactly the same way as JSON.stringify/
      test('string', () {
        var val = "String";
        var future = objectToJson(val);
        future.catchError((error) => registerException(error));
        expect(future, completion(JSON.stringify(val)));        
      });
      
      test('bool', () {
        var val = true;
        var future = objectToJson(val);
        future.catchError((error) => registerException(error));
        expect(future, completion(JSON.stringify(val)));        
      });
      
      test('num', () {
        var val = 123;
        var future = objectToJson(val);
        future.catchError((error) => registerException(error));
        expect(future, completion(JSON.stringify(val)));        
      });
      
      test('double', () {
        var val = 123.45;
        var future = objectToJson(val);
        future.catchError((error) => registerException(error));
        expect(future, completion(JSON.stringify(val)));        
      });
      
      test('null', () {
        var val = null;
        var future = objectToJson(val);
        future.catchError((error) => registerException(error));
        expect(future, completion(JSON.stringify(val)));        
      });
      
    });
    
    group('listOfNative', () {
      // "native types should be parsed in exactly the same way as JSON.stringify/
      test('string', () {
        var val = ["String","String2"];
        var future = objectToJson(val);
        future.catchError((error) => registerException(error));
        expect(future, completion(JSON.stringify(val)));        
      });
      
      test('bool', () {
        var val = [true,false];
        var future = objectToJson(val);
        future.catchError((error) => registerException(error));
        expect(future, completion(JSON.stringify(val)));        
      });
      
      test('num', () {
        var val = [123,456];
        var future = objectToJson(val);
        future.catchError((error) => registerException(error));
        expect(future, completion(JSON.stringify(val)));        
      });
      
      test('double', () {
        var val = [123.45,6.789];
        var future = objectToJson(val);
        future.catchError((error) => registerException(error));
        expect(future, completion(JSON.stringify(val)));        
      });
      
      test('null', () {
        var val = [null,null];
        var future = objectToJson(val);
        future.catchError((error) => registerException(error));
        expect(future, completion(JSON.stringify(val)));        
      });
      
      test('mixed', () {
        var val = ["String",true,123,35.6,null];
        var future = objectToJson(val);
        future.catchError((error) => registerException(error));
        expect(future, completion(JSON.stringify(val)));        
      });
      
      test('list', () {
        var val = [[1,2],["a","b"]];
        var future = objectToJson(val);
        future.catchError((error) => registerException(error));
        expect(future, completion(JSON.stringify(val)));
      });
      
    });
    
    group('mapOfNative', () {
      // "native types should be parsed in exactly the same way as JSON.stringify/
      test('string', () {
        var val = {"key1":"string1","key2":"string2"};
        var future = objectToJson(val);
        future.catchError((error) => registerException(error));
        expect(future, completion(new JsonMapMatcher(val)));        
      });
      
      test('bool', () {
        var val = {"key1":true,"key2":false};
        var future = objectToJson(val);
        future.catchError((error) => registerException(error));
        expect(future, completion(new JsonMapMatcher(val)));        
      });
      
      test('num', () {
        var val = {"key1":123,"key2":456};
        var future = objectToJson(val);
        future.catchError((error) => registerException(error));
        expect(future, completion(new JsonMapMatcher(val)));        
      });
      
      test('double', () {
        var val = {"key1":123.45,"key2":456.78};
        var future = objectToJson(val);
        future.catchError((error) => registerException(error));
        expect(future, completion(new JsonMapMatcher(val)));        
      });
      
      test('null', () {
        var val = {"key1":null,"key2":null};
        var future = objectToJson(val);
        future.catchError((error) => registerException(error));
        expect(future, completion(new JsonMapMatcher(val)));        
      });
      
      test('mixed', () {
        var val = {"key1":"string","key2":true,"key3":123,"key4":123.45,"key5":null};
        var future = objectToJson(val);
        future.catchError((error) => registerException(error));
        expect(future, completion(new JsonMapMatcher(val)));        
      });
      
      test('list', () {
        var val = {"list1":[1,2]};
        var future = objectToJson(val);
        future.catchError((error) => registerException(error));
        expect(future, completion(new JsonMapMatcher(val)));
      });
      
    });
    
    group('basic:', () {
      // Check we can serialize basic types: 
      // [num], [String], [bool], [Null],
      test('Basic', () {
        // Test a class that contains basic type fields
        var object = new Basic();
        var future = objectToJson(object);
        future.catchError((error) => registerException(error));
        var expectation = new Map();
        expectation["aString"] = object.aString;
        expectation["aNum"] = object.aNum;
        expectation["aDouble"] = object.aDouble;
        expectation["aBool"] = object.aBool;
        expectation["anInt"] = object.anInt;
        expectation["aNull"] = object.aNull;
        expectation["aFinal"] = object.aFinal;
        
        expect(future, completion(new JsonMapMatcher(expectation)));
      });
    
      test('ContainsBasicList', () {
        // Test a class that contains lists
        var object = new ContainsBasicList();
        var future = objectToJson(object);
        future.catchError((error) => registerException(error));
        var expectation = new Map();
          
        expectation["strings"] = object.strings;
        expectation["ints"] = object.ints;
        expectation["doubles"] = object.doubles;
        expectation["bools"] = object.bools;
        expectation["mixed"] = object.mixed;
        expectation["nulls"] = object.nulls;
        
        expect(future, completion(new JsonMapMatcher(expectation)));
      });
    
      test('ContainsBasicMap', () {
        // Test a class that contains maps
        var object = new ContainsBasicMap();
        var future = objectToJson(object);
        future.catchError((error) => registerException(error));
        var expectation = new Map();
          
        expectation["strings"] = object.strings;
        expectation["stringInts"] = object.stringInts;
        expectation["stringBools"] = object.stringBools;
        expectation["mixed"] = object.mixed;
        
        expect(future, completion(new JsonMapMatcher(expectation)));
      });
      
    });
    
    group('complex', () {
      test('ContainsSimpleObject', () {
        // Test a class that contains a child object
        var object = new ContainsSimpleObject();
        var future = objectToJson(object);
        future.catchError((error) => registerException(error));
        var expectation = new Map();
        expectation["anObject"] = new Map(); 
        expectation["anObject2"] = new Map();
        expectation["anObject3"] = new Map();
        
        expect(future, completion(new JsonMapMatcher(expectation)));
      }); 
      
      test('ContainsObject', () {
        // Test a class that contains a child object
        var object = new ContainsObject();
        var future = objectToJson(object);
        future.catchError((error) => registerException(error));
        var expectation = new Map();
        expectation["aString"] = object.aString;
        expectation["basic"] = new Map();
        expectation["basic"]["aString"] = object.basic.aString;
        expectation["basic"]["aBool"] = object.basic.aBool;
        expectation["basic"]["aNum"] = object.basic.aNum;
        expectation["basic"]["aDouble"] = object.basic.aDouble;
        expectation["basic"]["anInt"] = object.basic.anInt;
        expectation["basic"]["aNull"] = object.basic.aNull;
        expectation["basic"]["aFinal"] = object.basic.aFinal;
        
        expect(future, completion(new JsonMapMatcher(expectation)));
      }); 
    
      test('ContainsObjectList', () {
        // Test a class that has a list of child objects
        var object = new ContainsObjectList();
        var future = objectToJson(object);
        future.catchError((error) => registerException(error));
        
        var expectation = new Map();
        expectation["aString"] = object.aString;
        expectation["basicList"] = new List();
        expectation["basicList"].add(new Map());
        expectation["basicList"][0]["aString"] = object.basicList[0].aString;
        expectation["basicList"][0]["aBool"] = object.basicList[0].aBool;
        expectation["basicList"][0]["aNum"] = object.basicList[0].aNum;
        expectation["basicList"][0]["aDouble"] = object.basicList[0].aDouble;
        expectation["basicList"][0]["anInt"] = object.basicList[0].anInt;
        expectation["basicList"][0]["aNull"] = object.basicList[0].aNull;
        expectation["basicList"][0]["aFinal"] = object.basicList[0].aFinal;
        
        expectation["basicList"].add(new Map());
        expectation["basicList"][1]["aString"] = object.basicList[1].aString;
        expectation["basicList"][1]["aBool"] = object.basicList[1].aBool;
        expectation["basicList"][1]["aNum"] = object.basicList[1].aNum;
        expectation["basicList"][1]["aDouble"] = object.basicList[1].aDouble;
        expectation["basicList"][1]["anInt"] = object.basicList[1].anInt;
        expectation["basicList"][1]["aNull"] = object.basicList[1].aNull;
        expectation["basicList"][1]["aFinal"] = object.basicList[1].aFinal;
        
        expect(future, completion(new JsonMapMatcher(expectation)));
      }); 
      
      
      test('ContainsObjectMap', () {
        // Test a class that contains maps of real objects
        var object = new ContainsObjectMap();
        
        // The call under test
        var future = objectToJson(object);
        future.catchError((error) => registerException(error));
        
        var expectation = new Map();
        
        // Parse and test the output json
        expectation["basicMap"] = new Map();
        expectation["basicMap"]["basic1"] = new Map();
        expectation["basicMap"]["basic1"]["aString"] = object.basicMap["basic1"].aString;
        expectation["basicMap"]["basic1"]["aBool"] = object.basicMap["basic1"].aBool;
        expectation["basicMap"]["basic1"]["aNum"] = object.basicMap["basic1"].aNum;
        expectation["basicMap"]["basic1"]["aDouble"] = object.basicMap["basic1"].aDouble;
        expectation["basicMap"]["basic1"]["anInt"] = object.basicMap["basic1"].anInt;
        expectation["basicMap"]["basic1"]["aNull"] = object.basicMap["basic1"].aNull;
        expectation["basicMap"]["basic1"]["aFinal"] = object.basicMap["basic1"].aFinal;
        expectation["basicMap"]["basic2"] = new Map();
        expectation["basicMap"]["basic2"]["aString"] = object.basicMap["basic2"].aString;

        expectation["objectMap"] = new Map();
        expectation["objectMap"]["object1"] = new Map();
        expectation["objectMap"]["object1"]["basic"] = new Map();
        expectation["objectMap"]["object1"]["basic"]["aString"] = object.objectMap["object1"].basic.aString;
        expectation["objectMap"]["object2"] = new Map();
        expectation["objectMap"]["object2"]["basic"] = new Map();
        expectation["objectMap"]["object2"]["basic"]["aString"] = object.objectMap["object2"].basic.aString;
        
        expectation["objectListMap"] = new Map();
        expectation["objectListMap"]["objectList1"] = new Map();
        expectation["objectListMap"]["objectList1"]["basicList"] = new List();
        expectation["objectListMap"]["objectList1"]["basicList"].add(new Map());
        expectation["objectListMap"]["objectList1"]["basicList"][0]["aString"] = object.objectListMap["objectList1"].basicList[0].aString;
        
        expectation["listObjectMap"] = new Map();
        expectation["listObjectMap"]["list1"] = new List();
        expectation["listObjectMap"]["list1"].add(new Map());
        expectation["listObjectMap"]["list1"][0]["aString"] = object.listObjectMap["list1"][0].aString;
        expectation["listObjectMap"]["list1"].add(new Map());
        expectation["listObjectMap"]["list1"][1]["aString"] = object.listObjectMap["list1"][1].aString;
        expectation["listObjectMap"]["list2"] = new List();
        expectation["listObjectMap"]["list2"].add(new Map());
        expectation["listObjectMap"]["list2"][0]["aString"] = object.listObjectMap["list2"][0].aString;
     
        expect(future, completion(new JsonMapMatcher(expectation)));
      });
    });
    
    group('lists and maps', () {
      test('List<Basic>', () {
          var list = new List<Basic>();
          list.add(new Basic());
          list.add(new Basic());
          
          // The call under test
          var future = objectToJson(list);
          future.catchError((error) => registerException(error));
          
          var expectation = new List();
          expectation.add(new Map());
          expectation[0]["aString"] = list[0].aString;
          expectation[0]["aBool"] = list[0].aBool;
          expectation[0]["aNum"] = list[0].aNum;
          expectation[0]["aDouble"] = list[0].aDouble;
          expectation[0]["anInt"] = list[0].anInt;
          expectation[0]["aNull"] = list[0].aNull;
          expectation[0]["aFinal"] = list[0].aFinal;
          expectation.add(new Map());    
          expectation[1]["aString"] = list[1].aString;
          expectation[1]["aString"] = list[1].aString;
          expectation[1]["aBool"] = list[1].aBool;
          expectation[1]["aNum"] = list[1].aNum;
          expectation[1]["aDouble"] = list[1].aDouble;
          expectation[1]["anInt"] = list[1].anInt;
          expectation[1]["aNull"] = list[1].aNull;
          expectation[1]["aFinal"] = list[1].aFinal;
          
          
          expect(future, completion(new JsonMapMatcher(expectation)));
      });
      
      test('Map<Basic>', () {
        var map = new Map<String,Basic>();
        map["item1"] = new Basic();
        map["item2"] = new Basic();

        // The call under test
        var future = objectToJson(map);
        future.catchError((error) => registerException(error));
        
        var expectation = new Map();
        
        expectation["item1"] = new Map();
        expectation["item1"]["aString"] = map["item1"].aString;
        expectation["item1"]["aBool"] = map["item1"].aBool;
        expectation["item1"]["aNum"] = map["item1"].aNum;
        expectation["item1"]["aDouble"] = map["item1"].aDouble;
        expectation["item1"]["anInt"] = map["item1"].anInt;
        expectation["item1"]["aNull"] = map["item1"].aNull;
        expectation["item1"]["aFinal"] = map["item1"].aFinal;
        expectation["item2"] = new Map();
        expectation["item2"]["aString"] = map["item2"].aString;
        expectation["item2"]["aBool"] = map["item2"].aBool;
        expectation["item2"]["aNum"] = map["item2"].aNum;
        expectation["item2"]["aDouble"] = map["item2"].aDouble;
        expectation["item2"]["anInt"] = map["item2"].anInt;
        expectation["item2"]["aNull"] = map["item2"].aNull;
        expectation["item2"]["aFinal"] = map["item2"].aFinal;
        
        expect(future, completion(new JsonMapMatcher(expectation)));
      });
    });
    
    group('getters setters private static', () {
      test('ContainsGetters', () {
        var object = new ContainsGetters();
        
        // The call under test
        var future = objectToJson(object);
        future.catchError((error) => registerException(error));
        
        var expectation = new Map();
        
        expectation["aString"] = object.aString;
        expectation["aNum"] = object.aNum;
        expectation["aDouble"] = object.aDouble;
        expectation["aBool"] = object.aBool;
        expectation["anInt"] = object.anInt;
        expectation["aNull"] = object.aNull;
        expectation["aFinal"] = object.aFinal;
        
        expect(future, completion(new JsonMapMatcher(expectation)));
      });
      
      test('ContainsGettersAndObject', () {
        var object = new ContainsGettersAndObject();
        
        // The call under test
        var future = objectToJson(object);
        future.catchError((error) => registerException(error));
        
        var expectation = new Map();
        
        expectation["aString"] = object.aString;
        expectation["aNum"] = object.aNum;
        expectation["aDouble"] = object.aDouble;
        expectation["aBool"] = object.aBool;
        expectation["anInt"] = object.anInt;
        expectation["aNull"] = object.aNull;
        expectation["aFinal"] = object.aFinal;
        expectation["basic"] = new Map();
        expectation["basic"]["aString"] = object.aString;
        
        
        
        expect(future, completion(new JsonMapMatcher(expectation)));
      });
    
      test('ContainsPrivate', () {
        var object = new ContainsPrivate();
        
        // The call under test
        var future = objectToJson(object);
        future.catchError((error) => registerException(error));
        
        var expectation = new Map();
        
        expectation["_iAmPrivate"] = null;
        expectation["iAmPublic"] = object.iAmPublic;
        
        expect(future, completion(new JsonMapMatcher(expectation)));
      });
      
      test('ContainsStatic', () {
        var object = new ContainsStatic();
        
        // The call under test
        var future = objectToJson(object);
        future.catchError((error) => registerException(error));
        
        var expectation = new Map();
        
        expectation["iAmStatic"] = null;
        expectation["iAmInstance"] = object.iAmInstance;
        
        expect(future, completion(new JsonMapMatcher(expectation)));
      });
      
      test('ContainsMethods', () {
        var object = new ContainsMethods();
        
        // The call under test
        var future = objectToJson(object);
        future.catchError((error) => registerException(error));
        
        var expectation = new Map();
        
        expectation["field"] = object.field;
        
        expect(future, completion(new JsonMapMatcher(expectation)));
      });
    });
    
  });
  
}




 
/*
 * A map serialized to JSON may contain the same elements but in a different
 * order.
 */
class JsonMapMatcher implements Matcher {
  var _map;
  
  
  JsonMapMatcher(this._map);

  // JSON parse the item back into a map, and compare the two maps
  // (brute force, innefficient)
  bool matches(String item, MatchState matchState) {
    var result = true;
    _log("matcher before JSON: $item");
    _log("matcher after JSON:  $item");
    _log("matcher map:         ${JSON.stringify(_map)}");
    
    if (JSON.stringify(_map) == item) {
      // if the map and item are equal, then pass
      return true;
    }
    else {
      var map = JSON.parse(item);
      // try and compare the item and the map
      return _mapsAreEqual(map, _map);       
    }
  }
  
  Description describe(Description description) {
    description.add("_map: ${_map.toString()}");
    return description;
  }
  
  Description describeMismatch(item, Description mismatchDescription,
                               MatchState matchState, bool verbose) {
    mismatchDescription.add("item: ${item.toString()}");
    return mismatchDescription;
    
  }
  
  bool _listsAreEqual(List one, List two) {
    var i = -1;
    return one.every((element) {
      i++;

      return two[i] == element;
    });
  }
  
  bool _mapsAreEqual(Map one, Map two) {
    var result = true;
    
    one.forEach((k,v) {
      if (two[k] != v) {
        
        if (v is List) {
          if (!_listsAreEqual(one[k], v)) {
            result = false;
          }
        }
        else if (v is Map) {
          if (!_mapsAreEqual(one[k], v)) {
            result = false;
          }
        }
        else {
          result = false;
        }
        
      }
    });
    
    two.forEach((k,v) {
      if (one[k] != v) {
        
        if (v is List) {
          if (!_listsAreEqual(two[k], v)) {
            result = false;
          }
        }
        else if (v is Map) {
          if (!_mapsAreEqual(two[k], v)) {
            result = false;
          }
        }
        else {
          result = false;
        }
      }
    });
    
    return result;
  }
}