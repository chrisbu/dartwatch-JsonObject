part of json_object_test;

@proxy
class Person extends JsonObject {
  // need a default, private constructor
  Person();

  factory Person.fromString(String jsonString) {
    return new JsonObject.fromJsonString(jsonString, new Person());
  }
}


abstract class AddressList extends JsonObject implements List {
  Address address;
}

abstract class Address extends JsonObject {
   String line1;
   String postcode;
}

testStrongTyping_new() {
  Person person = new Person();
  person.name = "Chris";
  expect(person.name,equals("Chris"));
}

testStrongTyping_fromJsonString() {
  _log("testStrongTyping");
  var jsonString = _getStrongTypingJsonString();

  // Create a new JSON object which looks like our Person
  // A Person Interface extends the JsonObject, so no
  // warning is reported

  Person person = new Person.fromString(jsonString); // this will not fail



  //verify property access
  expect(person.addresses[0].address.line1, equals("1 the street"));

  var noSuchMethodException = null;
  try {
    //this should throw an exception
    //as it doesn't exist on Person
    //and it is a valid warning
    person.wibble;
  }
  catch (ex) {
    noSuchMethodException = ex;
  }

  //expect(noSuchMethodException != null);

}


_getStrongTypingJsonString() {
//Create the JSON which looks like our interface structure
  var jsonString = """
      {
        "addresses" : [
          { "address": {
              "line1": "1 the street",
              "postcode": "ab12 3de"
            }
          },
          { "address": {
              "line1": "1 the street",
              "postcode": "ab12 3de"
            }
          }
        ]
      }
      """;
  return jsonString;
}