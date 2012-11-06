part of json_object_test;

testIsExtendable() {
  print("testIsExtendable");

  JsonObject person = new JsonObject();
  //isExtendable is currently set to true, so
  //we can dynamically add new items
  person.name = "Chris";
  person.languages = ["Java","Dart","C#"];
  expect(person.name, equals("Chris"));


  //but we can stop it being extendable, to provide a bit more checking
  person.isExtendable = false;
  JsonObjectException expectedException = null;
  try {
    person.namz = "Bob"; //check for our namz typo - this should throw exception
  }
  on JsonObjectException catch (ex) {
    expectedException = ex;
  }
  
  //assert
  // expect(expectedException, isNotNull);


}
