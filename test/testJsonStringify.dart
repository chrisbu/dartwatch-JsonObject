testJsonStringify() {
  print("testJsonStringify");
  JsonObject person = new JsonObject();
  
  //dynamically created some properties
  person.name = "Chris";
  person.languages = new List();
  person.languages.add("Dart");
  person.languages.add("Java");
  
  //create a new JsonObject that we will inject
  JsonObject address = new JsonObject();
  address.line1 = "1 the street";
  address.postcode = "AB12 3DE";
  
  //add the address to the person
  person.address = address;
  
  //convert to a json string:
  String json = JSON.stringify(person);
  print(json);
  var expectedJson = """
{"address":{"line1":"1 the street","postcode":"AB12 3DE"},"name":"Chris","languages":["Dart","Java"]}""";
  
  //assert
  Expect.stringEquals(expectedJson, json);
}