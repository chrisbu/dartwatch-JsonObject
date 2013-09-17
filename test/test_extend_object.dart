part of json_object_test;

@proxy
class Person2 extends JsonObject {

}

testExtendObject() {
  Person2 person = new Person2();
  person.name = "blah";
  var s = new JsonEncoder().convert(person);
  expect(s, equals('{"name":"blah"}'));


}


