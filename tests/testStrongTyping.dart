
//Define some interfaces
//that we want our JSON structure to look like

interface Person extends JsonObject {
   AddressList addresses; 
}

interface AddressList extends List, JsonObject {
  Address address;
}

interface Address extends JsonObject {
   String line1;
   String postcode;
}


testStrongTyping() {
  print("testStrongTyping");
  var jsonString = _getStrongTypingJsonString();

  //Create a new JSON object which looks like our Person
  //A Person Interface extends the JsonObject, so no 
  //warning is reported
  Person person = new JsonObject.fromJsonString(jsonString);
  //verify property access
  Expect.stringEquals("1 the street", person.addresses[0].address.line1);
  
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
  
  Expect.isNotNull(noSuchMethodException);
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
}