#library("JsonObjectTest");

#import("../packages/unittest/unittest.dart");
// #import("packages:unittest/unittest.dart"); // should work but doesn't yet

#import("../JsonObject.dart");
#import("dart:json");

#source("testStrongTyping.dart");
#source("testSampleData.dart");
#source("testJsonStringify.dart");
#source("testIsExtendable.dart");
#source("testExtendObject.dart");
#source("testToString.dart");

void main() {
  test('sample data', () {
    testSampleData(); // passes build 8942
  });

  test('strong typing', () {
    testStrongTyping(); // passes build 8942
  });

  test('json stringify', () {
    testJsonStringify();  // fails build 8942
  });

  test('is extendable', () {
    testIsExtendable(); // passes build 8942
  });

  test('extend object', () {
    testExtendObject(); // passes build 8942
  });

  test('toString', () {
    testToString();
  });

}


