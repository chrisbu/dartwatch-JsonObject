part of json_object_test;

// test issue #4
testToString() {
  var user = new User();
  user.name = "Mike";
  _log(user.toString());
  expect(user.toString(),equals('{"name":"Mike"}'));
}


class User extends JsonObject {

}

