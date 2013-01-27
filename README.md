JsonObject for DART (http://www.dartlang.org)

[![](https://drone.io/chrisbu/json_object/status.png)](https://drone.io/chrisbu/json_object/latest)

Usage: Add to pubspec.yaml:

    dependencies:
  	  json_object: any    

Now *M3* compatible.

All tests passing with build 17328

You can use JsonObject in two different ways.  is the objectToJson method
which uses reflection to convert an object into json.  The other is two-way 
conversion of JSON into a class.

## Using reflection to serialize

Serialize to JSON with reflection is currently not working fully.
`objectToJson` is now returns a future.  It can currently be used 
to serialize objects, or lists / maps of objects that contain simple fields and 
getters that return string / num / bool (rather than other embedded objects). 
(That's next on the todo list). 

Example:
    import 'package: 
   
    class Basic {
       String myString = "foo";
       int myInt = 42;
    }
    
    main() {
      var basic = new Basic();
      objectToJson(basic).then((jsonStr) => print(jsonStr));
    }
  
----

## Accessing JSON Maps in a class-based fashion

Read the article about using this on the dartlang website: http://www.dartlang.org/articles/json-web-service/

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

Take a look at the unit tests to get an idea of how you can use it.


TODO:
* I still feel that there aren't enough tests - let me know if it works for you.
