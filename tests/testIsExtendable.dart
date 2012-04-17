testIsExtendable() {
  print("testIsExtendable");
  
  JsonObject person = new JsonObject();
  //isExtendable is currently set to true, so 
  //we can dynamically add new items
  person.name = "Chris"; 
  person.languages = ["Java","Dart","C#"];
  Expect.stringEquals("Chris", person.name);
  
  
  //but we can stop it being extendable, to provide a bit more checking
  person.isExtendable = false;
  UnsupportedOperationException expectedException = null;
  try {
    person.namz = "Bob"; //check for our namz typo - this should throw exception
  }
  catch (UnsupportedOperationException ex) {
    expectedException = ex;
  }
  //assert
  Expect.isNotNull(expectedException);
  
}
