part of json_object_test;

bool testSampleData() {
  _log("testSampleData");
  var jsonString = """
      {
        "name" : "Chris",
        "languages" : ["Dart","Java","C#","Python"],
        "handles" : {
          "googlePlus": {"name":"+Chris Buckett"},
          "twitter" : {"name":"@ChrisDoesDev"}
        },
        "blogs" : [
          {
             "name": "Dartwatch",
             "url": "http://dartwatch.com"
          },
          {
             "name": "ChrisDoesDev",
             "url": "http://chrisdoesdev.com"
          }
        ],
        "books" : [
          {
            "title": "Dart in Action",
            "chapters": [
              { 
                 "chapter1" : "Introduction to Dart",
                 "pages" : ["page1","page2","page3"]
              },
              { "chapter2" : "Dart tools"}
            ]
          }
        ]
      }
      """;
        
    var  o = new JsonObject.fromJsonString(jsonString);
    
    //basic access
    expect("Chris", equals(o.name));
    expect("Dart", equals(o.languages[0]));
    expect("Java", equals(o.languages[1]));
    
    //maps within maps
    expect("+Chris Buckett", equals(o.handles.googlePlus.name));
    expect("@ChrisDoesDev", equals(o.handles.twitter.name));
    
    //maps within lists
    expect("Dartwatch", equals(o.blogs[0].name));
    expect("http://dartwatch.com", equals(o.blogs[0].url));
    expect("ChrisDoesDev",equals(o.blogs[1].name));
    expect("http://chrisdoesdev.com", equals(o.blogs[1].url));
    
    //maps within lists within maps 
    expect("Introduction to Dart", equals(o.books[0].chapters[0].chapter1));
    expect("page1", equals(o.books[0].chapters[0].pages[0]));
    expect("page2", equals(o.books[0].chapters[0].pages[1]));
    
    //try an update
    o.handles.googlePlus.name="+ChrisB";
    expect("+ChrisB",equals(o.handles.googlePlus.name));
    
    for (JsonObject o in o.books) {
      _log(o.chapters);  
    }
      
       
}