#library("JsonObjectTest");

#import("../JsonObject.dart");
#import("dart:json");

#source("testStrongTyping.dart");
#source("testSampleData.dart");
#source("testJsonStringify.dart");
#source("testIsExtendable.dart");
#source("testExtendObject.dart");

void main() {
  print("Starting tests");
  
  testSampleData();
  testStrongTyping();
  
  testJsonStringify();
  
  testIsExtendable();
  
  print("Finished tests");
}


