JsonObject  for DART

Takes a json string representation, and uses dart:json to parse it.
From the parsed output, it converts any maps (recursively) into 
JsonObjects, which allow use of dot notation for property access 
(via noSuchMethod).

For example:

    var obj = new JsonObject('{"name":"Chris"}');
    print(obj.name);
    obj.name = "Chris B";


TODO:
* Full set of unit tests
* Implement MAP (so that it can be converted back to JSON by JSON.stringify()


