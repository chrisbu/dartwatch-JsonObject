
//Define some interfaces
//that we want our JSON structure to look like

interface Person default _PersonImpl{
   AddressList addresses;
   Person.fromString(String jsonString);
}

class _PersonImpl extends JsonObject implements Person {
  _PersonImpl();
  factory _PersonImpl.fromString(String jsonString) {
    return new JsonObject.fromJsonString(jsonString, new _PersonImpl());  
  } 
}


interface AddressList extends List, JsonObject {
  Address address;
}

interface Address extends JsonObject {
   String line1;
   String postcode;
}

// this test will fail.  But it would be great if it didn't!
// does anyone have any ideas?
testStrongTyping() {
  print("testStrongTyping");
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
  catch (NoSuchMethodException ex) {
    noSuchMethodException = ex;
  }

  expect(noSuchMethodException != null);

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