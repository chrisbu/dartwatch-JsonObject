part of json_object_test;

testListSerialization() {
  var tags = new List<String>();
  tags.add("Foo");
  tags.add("Bar");
  var filter = searchElements(tags);
  
  expect(filter.filter.tags[0],"Foo");
  expect(filter.filter.tags[1],"Bar");
}


searchElements(List<String> tags) {
  JsonObject filter = new JsonObject();
  filter.filter = new JsonObject(); //this is on purpose
  if( tags != null && ! tags.isEmpty) {
    filter.filter.tags = tags;
  }
  
  return filter;
}

