
//Define some interfaces
//that we want our JSON structure to look like

interface Person //extends JsonObject - not yet implemented in the VM 
{
   AddressList addresses; 
}

interface AddressList extends List {
  Address address;
}

interface Address {
   String line1;
   String postcode;
}


testStrongTyping() {
  print("testStrongTyping");
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


  //Create a new JSON object which looks like our Person
  //this will get a warning until Person can 
  //implement the JsonObject class in the VM
  Person person = new JsonObject.fromJsonString(jsonString);
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
