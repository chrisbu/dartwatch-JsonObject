
bool testSampleData() {
  print("testSampleData");
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
      Expect.stringEquals("Chris", o.name);
      Expect.stringEquals("Dart", o.languages[0]);
      Expect.stringEquals("Java", o.languages[1]);
      
      //maps within maps
      Expect.stringEquals("+Chris Buckett", o.handles.googlePlus.name);
      Expect.stringEquals("@ChrisDoesDev", o.handles.twitter.name);
      
      //maps within lists
      Expect.stringEquals("Dartwatch", o.blogs[0].name);
      Expect.stringEquals("http://dartwatch.com", o.blogs[0].url);
      Expect.stringEquals("ChrisDoesDev",o.blogs[1].name);
      Expect.stringEquals("http://chrisdoesdev.com", o.blogs[1].url);
      
      //maps within lists within maps 
      Expect.stringEquals("Introduction to Dart", o.books[0].chapters[0].chapter1);
      Expect.stringEquals("page1", o.books[0].chapters[0].pages[0]);
      Expect.stringEquals("page2", o.books[0].chapters[0].pages[1]);
      
      //try an update
      o.handles.googlePlus.name="+ChrisB";
      Expect.stringEquals("+ChrisB",o.handles.googlePlus.name);
      
      for (JsonObject o in o.books) {
        print(o.chapters);  
      }
      
       
}