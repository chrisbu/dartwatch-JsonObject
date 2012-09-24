class LanguageWebsite extends JsonObject  {
  LanguageWebsite();  // default constructor (empty) implementation

  factory LanguageWebsite.fromJsonString(String json) { // from JSON constructor implementation
    var languageWebsite = new LanguageWebsite(); // create an empty instance of this class
    var jsonObject = new JsonObject.fromJsonString(json, languageWebsite); // create an instance of JsonObject, 
                                                                           // populated with the json string and 
                                                                           // injecting the _LanguageWebsite instance.
    return jsonObject; // return the populated JsonObject instance
  }
  
  factory LanguageWebsite.fromJsonObject(JsonObject jsonObject) {
    return JsonObject.toTypedJsonObject(jsonObject, new LanguageWebsite());    
  }
}

class Language extends JsonObject {
  Language(); // empty, default constructor

  factory Language.fromJsonString(String json) { // from JSON constructor implementation
    return new JsonObject.fromJsonString(json, new Language()); // as _LangaugeWebsite, return an instance
                                                                 // of JsonObject, containing the json string and
                                                                 // injecting a _Language instance
  }
}

void testDartlangArticle_fromJson() {
  final responseText = """
{
  "language": "dart", 
  "targets": ["dartium","javascript"], 
  "website": {
    "homepage": "www.dartlang.org",
    "api": "api.dartlang.org"
  }
}""";
  
  
  Language data = new Language.fromJsonString(responseText);
  
  

// tools can now validate the property access
  expect(data.language, equals("dart"));
  expect(data.targets[0], equals("dartium"));
  
  // nested types are also strongly typed
  LanguageWebsite website = new LanguageWebsite.fromJsonObject(data.website); // contains a JsonObject
  website.homepage = "http://www.dartlang.org";
  expect(website.homepage,equals("http://www.dartlang.org"));
  
  
}

void testDartlangArticle_new() {
  Language data = new Language();
  data.language = "Dart";
  data.website = new LanguageWebsite();
  data.website.homepage = "http://www.dartlang.org";
  
  expect(data.website.homepage, equals("http://www.dartlang.org"));
  
}

