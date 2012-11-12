JsonObject for DART (http://www.dartlang.org)

Usage: Add to pubspec.yaml:
    dependencies:
      json_object: 
        git: git://github.com/chrisbu/dartwatch-JsonObject.git

Now *M1* compatible, with new noSuchMethod InvocationMirror syntax.

## NEW 12/Nov/2012: Serialize to JSON with mirrors

This does not use the JsonObject class itself - instead, it is a top-level
function called `objectToJson` which will serialize an Object, a List of objects
or a map of objects that have String keys.

Example: 
  
    import 'package:json_object/json_object.dart';

    class Person {
     String name;
     List<Address> addresses = new List<Address>();
    }

    class Address {
      String line1;
      String zipcode;
      Address(this.line1,this.zipcode);
    }

    void main() {
      var person = new Person();
      person.name = "Mr Smith";
      person.addresses.add(new Address("1 the street", "98765"));
      person.addresses.add(new Address("2 some road", "87654"));
   
      var json = objectToJson(person);  // Here is the magic
   
      print(json); // outputs valid json  
    }
   
   
Coming soon - deserialize json back to real objects with mirrors.
Note: At the time of writing, dart2js does not have mirrors built in, so this
is likely most useful at the moment on the server side.  See [this post on google groups](https://groups.google.com/a/dartlang.org/forum/#!topic/misc/6SwESxJS4F4) 

----

## JsonObject class (map to dot notation converter)

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

By coding against an interface, you can get stronger typing.
An interface can now extend a Class (which is also implicitly an interface) :

    interface Person extends JsonObject { 
      String name;
      List languages;
    }
    
    //...snip
    Person person = new JsonObject(); //this works without warning
                                      //because Person extends JsonObject
    person.name = "Chris";
    person.languages = //etc...  
    //will get strongly type checked.

Take a look at the unit tests to get an idea of how you can use it.


TODO:
* I still feel that there aren't enough tests - let me know if it works for you.
