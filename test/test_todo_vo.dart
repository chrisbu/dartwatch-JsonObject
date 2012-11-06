part of json_object_test;

abstract class TodoVO {

  // Instance members
  String id;
  String title;
  bool completed;

  // Filter settings
  static const String FILTER_ALL              = "filter/setting/all";
  static const String FILTER_ACTIVE           = "filter/setting/active";
  static const String FILTER_COMPLETED        = "filter/setting/completed";

  // the from JsonString constructor
  factory TodoVO.fromString( String jsonString ) => new _TodoVOImpl.fromString(jsonString); 

  // the default constructor
  factory TodoVO() => new _TodoVOImpl();

  // Serialize to JSON
  String toJson();
}

class _TodoVOImpl extends JsonObject implements TodoVO   {
  // Instance members not required - they are implemented by noSuchMethod
  //String id = '';
  //String title = '';
  //bool completed = false;

  // need a default, private constructor
  _TodoVOImpl();

  factory _TodoVOImpl.fromString( String jsonString ) {
    return new JsonObject.fromJsonString( jsonString, new _TodoVOImpl() );
  }

  // Serialize this object to JSON
  String toJson() {

    StringBuffer buffer = new StringBuffer();
    buffer.add('{');
    buffer.add('"id":"'); // add the missing "
    buffer.add(id);
    buffer.add('", '); // add the missing "

    buffer.add('"title":"');
    buffer.add( title );
    buffer.add('", ');

    buffer.add('"completed":');
    buffer.add(completed.toString());
    buffer.add('}');

    print(buffer.toString()); // add a print for debugging
    return buffer.toString();
  }
}

testTodoVO() {

  // Create a Todo
  TodoVO todo = new TodoVO();
  todo.id="99-plural-z-alpha";
  todo.title="Make way for new hyperspace bypass";
  todo.completed = false;

  // marshall and unmarshall
  String json = todo.toJson();
  TodoVO reconstituted = new TodoVO.fromString( json );

  // test
  expect( reconstituted.id, equals( todo.id) );
  expect( reconstituted.title, equals( todo.title) );
  expect( reconstituted.completed, equals( todo.completed) );

}