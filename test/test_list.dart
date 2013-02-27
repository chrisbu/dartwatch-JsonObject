part of json_object_test;

// http://stackoverflow.com/questions/14462007/parsing-json-list-with-jsonobject-library-in-dart

testList() {
  test("list", () { 
    var testJson = """
        [{"Dis":1111.1,"Flag":0,"Obj":{"ID":1,"Title":"Volvo 140"}},
        {"Dis":2222.2,"Flag":0,"Obj":{"ID":2,"Title":"Volvo 240"}}]
        """;
    MyList list = new MyList.fromString(testJson);
    print(list[0].Obj.Title);
    expect(list[0].Obj.Title, equals("Volvo 140"));
  });
  
}

testListIterator() {
  test("list iterator", () {
    var testJson = """
        [{"Dis":1111.1,"Flag":0,"Obj":{"ID":1,"Title":"Volvo 140"}},
        {"Dis":2222.2,"Flag":0,"Obj":{"ID":2,"Title":"Volvo 240"}}]
        """;
    MyList jsonObject = new MyList.fromString(testJson);
    
    var firstTitle= "";
    var secondTitle = "";
    
    for (var item in jsonObject.toIterable()) {
      if (firstTitle == "") {
        firstTitle = item.Obj.Title;
      }
      else {
        secondTitle = item.Obj.Title;
      }
    }
    
    expect(firstTitle, equals("Volvo 140"));
    expect(secondTitle, equals("Volvo 240"));
  });
}

class MyList extends JsonObject { 
  MyList();

  factory MyList.fromString(String jsonString) {
    return new JsonObject.fromJsonString(jsonString, new MyList());
  }
}