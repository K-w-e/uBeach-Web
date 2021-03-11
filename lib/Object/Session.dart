import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class Session {
  CognitoUserSession session;
  static final Session _inst = Session._internal();

  Session._internal();

  factory Session({var session}) {
    if (session != null) _inst.session = session;
    return _inst;
  }

  CognitoUserSession getInstance() {
    return session;
  }
}
