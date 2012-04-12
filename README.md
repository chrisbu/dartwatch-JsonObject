JsonObject for DART (http://www.dartlang.org)

Takes a json string representation, and uses dart:json to parse it.
From the parsed output, it converts any maps (recursively) into 
JsonObjects, which allow use of dot notation for property access 
(via noSuchMethod).    Also allows creating an empty object and populating
it using dot notation.

For example:

    var person = new JsonObject('{"name":"Chris"}');
    print(person.name);
    person.name = "Chris B";
    person.namz = "Bob"; //throws an exception, as it wasn't in the original json
                         //good for catching typos
                          
    person.isExtendable = true;
    person.namz = "Bob" //this is allowed now
    
It implements Map, so you can convert it back to Json using JSON.stringify():
    
    var person = new JsonObject();
    person.name = "Chris";
    person.languages = ["Dart","Java"];
    var json = JSON.stringify(person);

By coding against an interface, you can get a bit of stronger typing:

    //interface Person implements JsonObject { //should be allowed by not in Dart VM yet
    interface Person {  //so we have to use this instead
      String name;
      List languages;
    }
    
    //...snip
    Person person = new JsonObject();
    person.name = "Chris";
    person.languages = //etc...  
    //will get strongly type checked.

Take a look at the unit tests to get an idea of how you can use it.


TODO:
* I still feel that there aren't enough tests - let me know if it works for you.