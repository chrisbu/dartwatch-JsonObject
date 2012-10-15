#library("JsonObjectTest");

#import('package:JsonObject/JsonObject.dart');
#import('package:unittest/unittest.dart');
#import("dart:json");

#source("testStrongTyping.dart");
#source("testSampleData.dart");
#source("testJsonStringify.dart");
#source("testIsExtendable.dart");
#source("testExtendObject.dart");
#source("testToString.dart");
#source("testDartlangArticle.dart");
#source("testTodoVO.dart");

void main() {
  test('sample data', () {
    print(1);
    testSampleData(); // passes build 8942
  });

  group('strong typing', () {
    test('new', () {
      print(2);
      testStrongTyping_new();
    });

    test('from json string', () {
      testStrongTyping_fromJsonString(); // passes build 8942
    });
  });

  test('json stringify', () {
    print(3);
    testJsonStringify();  // passes build 8942
  });

  test('is extendable', () {
    print(4);
    testIsExtendable(); // passes build 8942
  });

  test('extend object', () {
    print(5);
    testExtendObject(); // passes build 8942
  });

  test('toString', () {
    print(6);
    testToString();
  });

  group('dartlang article', () {
    test('fromJson', () {
      print(7);
      testDartlangArticle_fromJson();
    });

    test('new', () {
      testDartlangArticle_new();
    });

  });

  test('toTodoVO', () {
    print(7);
    testTodoVO();
  });

}


