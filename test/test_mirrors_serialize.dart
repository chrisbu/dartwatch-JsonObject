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
    
    /* There are two types of objects: 
     1. Those that contain ONLY 
     basic seralizable types num, String, bool, Null, or Maps and lists
     that only contain the serializable types.
     2. Those that contain child objects, or maps and lists of child objects
     (possibly along with the serializable types).
     */
    
    group('basic:', () {
      // Check we can serialize basic types: 
      // [num], [String], [bool], [Null],
      test('Basic', () {
        // Test a class that contains basic type fields
        var object = new Basic();
        print("Object: $object");
        var json = objectToJson(object);
        print("Json: $json");
        var map = JSON.parse(json);
        expect(map["aString"], equals(object.aString));
        expect(map["aNum"], equals(object.aNum));
        expect(map["aDouble"], equals(object.aDouble));
        expect(map["aBool"], equals(object.aBool));
        expect(map["anInt"], equals(object.anInt));
        expect(map["aNull"], equals(object.aNull));
        expect(map["aFinal"], equals(object.aFinal));
      });
    
      test('ContainsBasicList', () {
        // Test a class that contains lists
        var object = new ContainsBasicList();
        var json = objectToJson(object);
        var map = JSON.parse(json);
        expect(map["strings"], equals(object.strings));
        expect(map["ints"], equals(object.ints));
        expect(map["doubles"], equals(object.doubles));
        expect(map["bools"], equals(object.bools));
        expect(map["mixed"], equals(object.mixed));
        expect(map["nulls"], equals(object.nulls));
      });
    
      test('ContainsBasicMap', () {
        // Test a class that contains maps
        var object = new ContainsBasicMap();
        var json = objectToJson(object);
        var map = JSON.parse(json);
        expect(map["strings"], equals(object.strings));
        expect(map["stringInts"], equals(object.stringInts));
        expect(map["stringBools"], equals(object.stringBools));
        expect(map["mixed"], equals(object.mixed));
      });
      
    });
    
    group('complex', () {
      test('ContainsObject', () {
        // Test a class that contains a child object
        var object = new ContainsObject();
        var json = objectToJson(object);
        var map = JSON.parse(json);
        expect(map["aString"],equals(object.aString));
        expect(map["basic"]["aString"],equals(object.basic.aString));
        expect(map["basic"]["aBool"],equals(object.basic.aBool));
        expect(map["basic"]["aNum"],equals(object.basic.aNum));
        expect(map["basic"]["aDouble"],equals(object.basic.aDouble));
        expect(map["basic"]["anInt"],equals(object.basic.anInt));
        expect(map["basic"]["aNull"],equals(object.basic.aNull));
        expect(map["basic"]["aFinal"],equals(object.basic.aFinal));
      }); 
    
      test('ContainsObjectList', () {
        // Test a class that has a list of child objects
        var object = new ContainsObjectList();
        var json = objectToJson(object);
        var map = JSON.parse(json);
        expect(map["aString"],equals(object.aString));
        expect(map["basicList"].length,equals(2));
        expect(map["basicList"][0]["aString"],equals(object.basicList[0].aString));
        expect(map["basicList"][0]["aBool"],equals(object.basicList[0].aBool));
        expect(map["basicList"][0]["aNum"],equals(object.basicList[0].aNum));
        expect(map["basicList"][0]["aDouble"],equals(object.basicList[0].aDouble));
        expect(map["basicList"][0]["anInt"],equals(object.basicList[0].anInt));
        expect(map["basicList"][0]["aNull"],equals(object.basicList[0].aNull));
        expect(map["basicList"][0]["aFinal"],equals(object.basicList[0].aFinal));
      }); 
      
      
      test('ContainsObjectMap', () {
        // Test a class that contains maps of real objects
        var object = new ContainsObjectMap();
        
        // The call under test
        var json = objectToJson(object);
        
        // Parse and test the output json
        var map = JSON.parse(json);
        expect(map["basicMap"]["basic1"]["aString"],equals(object.basicMap["basic1"].aString));
        expect(map["basicMap"]["basic1"]["aBool"],equals(object.basicMap["basic1"].aBool));
        expect(map["basicMap"]["basic1"]["aNum"],equals(object.basicMap["basic1"].aNum));
        expect(map["basicMap"]["basic1"]["aDouble"],equals(object.basicMap["basic1"].aDouble));
        expect(map["basicMap"]["basic1"]["anInt"],equals(object.basicMap["basic1"].anInt));
        expect(map["basicMap"]["basic1"]["aNull"],equals(object.basicMap["basic1"].aNull));
        expect(map["basicMap"]["basic1"]["aFinal"],equals(object.basicMap["basic1"].aFinal));
        expect(map["basicMap"]["basic2"]["aString"],equals(object.basicMap["basic2"].aString));

        expect(map["objectMap"]["object1"]["basic"]["aString"],
            equals(object.objectMap["object1"].basic.aString));
        expect(map["objectMap"]["object2"]["basic"]["aString"],
            equals(object.objectMap["object2"].basic.aString));
        
        expect(map["objectListMap"]["objectList1"]["basicList"][0]["aString"],
            equals(object.objectListMap["objectList1"].basicList[0].aString));
        
        expect(map["listObjectMap"]["list1"][0]["aString"],
            equals(object.listObjectMap["list1"][0].aString));
        expect(map["listObjectMap"]["list1"][1]["aString"],
            equals(object.listObjectMap["list1"][1].aString));
        expect(map["listObjectMap"]["list2"][0]["aString"],
            equals(object.listObjectMap["list2"][0].aString));
      });
    });
    
    group('lists and maps', () {
      test('List<Basic>', () {
          var list = new List<Basic>();
          list.add(new Basic());
          list.add(new Basic());
          
          // The call under test
          var json = objectToJson(list);
          print(json);
          
          // Parse the output json
          var parsed = JSON.parse(json);
          expect(parsed.length,equals(2));
          expect(parsed[0]["aString"], equals(list[0].aString)); 
          expect(parsed[1]["aString"], equals(list[1].aString));
      });
      
      test('Map<Basic>', () {
        var map = new Map<String,Basic>();
        map["item1"] = new Basic();
        map["item2"] = new Basic();

        // The call under test
        var json = objectToJson(map);
        
        var parsed = JSON.parse(json);
        expect(parsed.keys.length,equals(2));
        expect(parsed["item1"]["aString"], equals(map["item1"].aString)); 
        expect(parsed["item2"]["aString"], equals(map["item2"].aString));
        
      });
    });
    
    group('getters setters private static', () {
      test('ContainsGetters', () {
        var object = new ContainsGetters();
        
        // The call under test
        var json = objectToJson(object);
        var map = JSON.parse(json);
        
        expect(map["aString"], equals(object.aString));
        expect(map["aNum"], equals(object.aNum));
        expect(map["aDouble"], equals(object.aDouble));
        expect(map["aBool"], equals(object.aBool));
        expect(map["anInt"], equals(object.anInt));
        expect(map["aNull"], equals(object.aNull));
        expect(map["aFinal"], equals(object.aFinal));
        expect(map["basic"]["aString"], equals(object.aString));
      });
    
      test('ContainsPrivate', () {
        var object = new ContainsPrivate();
        
        // The call under test
        var json = objectToJson(object);
        var map = JSON.parse(json);
        
        expect(map.keys.length,equals(1));
        expect(map["_iAmPrivate"], isNull);
        expect(map["iAmPublic"], equals(object.iAmPublic));
      });
      
      test('ContainsStatic', () {
        var object = new ContainsStatic();
        
        // The call under test
        var json = objectToJson(object);
        var map = JSON.parse(json);
        
        expect(map.keys.length,equals(1));
        expect(map["iAmStatic"], isNull);
        expect(map["iAmInstance"], equals(object.iAmInstance));
      });
      
      test('ContainsMethods', () {
        var object = new ContainsMethods();
        
        // The call under test
        var json = objectToJson(object);
        var map = JSON.parse(json);
        
        expect(map.keys.length,equals(1));
        expect(map["field"], equals(object.field));
      });
    });

    
  });
  
}


// Individual tests

 