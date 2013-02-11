
part of json_object_test;

// github: issue 15

void testPrintList() {
  MyList2 list = new MyList2.fromString('[{"x":161,"y":37},{"x":143,"y":177}]');
  print(list[0]);
  print(list.length);
  print(list);
}

class MyList2 extends JsonObject {

  MyList2();

  factory MyList2.fromString(String jsonString) {
    return new JsonObject.fromJsonString(jsonString, new MyList2());
  }

}