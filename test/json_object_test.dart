library json_object_test;

import "package:unittest/unittest.dart";

import "../lib/json_object.dart";

import "dart:convert";
//import 'package:meta/meta.dart';

part "test_strong_typing.dart";
part "test_sample_data.dart";
part "test_json_stringify.dart";
part "test_is_extendable.dart";
part "test_extend_object.dart";
part "test_to_string.dart";
part "test_dartlang_article.dart";
part "test_todo_vo.dart";
part "test_print_list.dart";
part "test_list_serialization.dart";
part "test_mirrors_serialize.dart";
part "test_list.dart";

void _log(obj) {
  if (enableJsonObjectDebugMessages) print(obj);
}

void main() {
  enableJsonObjectDebugMessages = true;

  test('sample data', () {
    testSampleData(); // passes build 14458
  });

  group('strong typing', () {
    test('new', () {
      testStrongTyping_new(); // passes build 14458
    });

    test('from json string', () {
      testStrongTyping_fromJsonString(); // passes build 14458
    });
  });

  test('json stringify', () {
    testJsonStringify();  // passes build 8942
  });

  test('is extendable', () {
    testIsExtendable(); // passes build 14458
  });

  test('extend object', () {
    testExtendObject(); // passes build 14458
  });

  test('toString', () {
    testToString(); // passes build 14458
  });

  group('dartlang article', () {
    test('fromJson', () {
      testDartlangArticle_fromJson(); // passes build 14458
    });

    test('new', () {
      testDartlangArticle_new(); // passes build 14458
    });

  });

   test('toTodoVO', () {
    testTodoVO();
  });

   test('list', () {
     testList();
     testListIterator();
     testPrintList();
   });

   test('list seralization', () {
     testListSerialization();
   });



  // Broken
  // testMirrorsSerialize(); // tests converting a class to JSON
}


