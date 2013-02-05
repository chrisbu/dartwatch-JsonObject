library json_object_test;

import "package:unittest/unittest.dart"; 

import "../lib/json_object.dart";

import "dart:json" as JSON;

part "test_strong_typing.dart";
part "test_sample_data.dart";
part "test_json_stringify.dart";
part "test_is_extendable.dart";
part "test_extend_object.dart";
part "test_to_string.dart";
part "test_dartlang_article.dart";
part "test_todo_vo.dart";
// part "test_mirrors_serialize.dart";
part "test_list.dart";

void main() { 
  enableJsonObjectDebugMessages = true;
  
  test('sample data', () {
    print(1);
    testSampleData(); // passes build 14458
  });

  group('strong typing', () {
    test('new', () {
      print(2);
      testStrongTyping_new(); // passes build 14458
    });
    
    test('from json string', () {
      testStrongTyping_fromJsonString(); // passes build 14458
    });
  });

  test('json stringify', () {
    print(3);
    testJsonStringify();  // passes build 8942
  });

  test('is extendable', () {
    print(4);
    testIsExtendable(); // passes build 14458
  });

  test('extend object', () {
    print(5);
    testExtendObject(); // passes build 14458
  });

  test('toString', () {
    print(6);
   testToString(); // passes build 14458
  });
  
  group('dartlang article', () {
    test('fromJson', () {
      print(7);
      testDartlangArticle_fromJson(); // passes build 14458
    });
    
    test('new', () {
      testDartlangArticle_new(); // passes build 14458
    });
    
  });
  
   test('toTodoVO', () {
    print(8);
    testTodoVO();     
  });
   
   test('list', () {
     print(9);
     testList();
   });
   

//   testMirrorsSerialize(); // tests converting a class to JSON
}


