JsonObject for DART (http://www.dartlang.org)

[![](https://drone.io/chrisbu/json_object/status.png)](https://drone.io/chrisbu/json_object/latest)

Usage: Add to pubspec.yaml:

    dependencies:
  	  json_object: any    

Now *M3* compatible.

All tests passing with build **17657**

You can use JsonObject in two different ways.  

## 1 Accessing JSON Maps in a class-based fashion

Read the article about using this on the dartlang website: http://www.dartlang.org/articles/json-web-service/

JsonObject takes a json string representation, and uses the `dart:json` library to parse 
it back into a map.  JsonObject then takes the parsed output, 
and converts any maps (recursively) into 
JsonObjects, which allow use of dot notation for property access 
(via `noSuchMethod`).    

Examples:

    // create from existing JSON
    var person = new JsonObject.fromJsonString('{"name":"Chris"}');
    print(person.name);
    person.name = "Chris B";
    person.namz = "Bob"; //throws an exception, as it wasn't in the original json
                         //good for catching typos
                          
    person.isExtendable = true;
    person.namz = "Bob" //this is allowed now
    String jsonString = JSON.stringify(person); // convert back to JSON

It implements Map, so you can convert it back to Json using JSON.stringify():
    
    // starting from an empty map
    var animal = new JsonObject();  
    animal.legs = 4;  // equivalent to animal["legs"] = 4;
    animal.name = "Fido"; // equivalent to animal["name"] = "Fido";
    String jsonString = JSON.stringify(animal); // convert to JSON
    

Take a look at the unit tests to get an idea of how you can use it.

---- 

## 2. Experimental :Using reflection to serialize from a real class instance to JSON

(Requires use of a the experimental `mirrors` branch)

    dependencies:
      json_object:
        git:
          url: git://github.com/chrisbu/dartwatch-JsonObject.git
          ref: mirrors

Use `objectToJson(myObj)` to return a future containing the serialized string.

Example:
    import 'package:json_object/json_object.dart'; 
   
   	class Other {
   		String name = "My Name";
   	}
   
    class Basic {
       String myString = "foo";
       int myInt = 42;
       Other name = new Other();
    }
    
    main() {
      var basic = new Basic();
      objectToJson(basic).then((jsonStr) => print(jsonStr));
    }
  
----



TODO:
* I still feel that there aren't enough tests - let me know if it works for you.

Many of the unit tests are based around specific questions from users, 
either here or on stack overflow.
