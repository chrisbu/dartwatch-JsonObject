#import("JsonObject.dart");
#import("dart:json");

void main() {
 
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
  
  JsonObject o = new JsonObject.fromJsonString(jsonString);
  //basic access
  print(o.name);
  print(o.languages[0]);
  print(o.languages[1]);
  
  //maps within maps
  print(o.handles.googlePlus.name);
  print(o.handles.twitter.name);
  
  //maps within lists
  print(o.blogs[0].name);
  print(o.blogs[0].url);
  print(o.blogs[1].name);
  print(o.blogs[1].url);
  
  //maps within lists within maps 
  print(o.books[0].chapters[0].chapter1);
  print(o.books[0].chapters[0].pages[0]);
  print(o.books[0].chapters[0].pages[1]);
  
  o.handles.googlePlus.name="+ChrisB";
  print(o.handles.googlePlus.name);
  
  
}


