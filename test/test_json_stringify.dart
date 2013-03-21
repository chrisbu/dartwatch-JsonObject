part of json_object_test;

testJsonStringify() {
  _log("testJsonStringify");
  JsonObject person = new JsonObject();
  
  // dynamically created some properties
  person.name = "Chris";
  person.languages = new List();
  person.languages.add("Dart");
  person.languages.add("Java");
  
  // create a new JsonObject that we will inject
  JsonObject address = new JsonObject();
  address.line1 = "1 the street";
  address.postcode = "AB12 3DE";
  
  // add the address to the person
  person.address = address;
  
  // convert to a json string:
  String json = JSON.stringify(person);
  // convert back to a json map - the JSON stringifg changes periodically,
  // breaking this test
  Map convertedBack = JSON.parse(json);
  
  // assert
  expect(convertedBack["address"]["line1"], equals(address.line1));
  expect(convertedBack["name"], equals(person.name));
 
  
}