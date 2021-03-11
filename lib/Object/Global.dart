import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class Global {
  static final userPool = new CognitoUserPool(
    'eu-central-1_YaGDENYWc',
    '64n15gq0rdiihj02dri2qbiunt',
  );

  static final identityPoolId =
      "eu-central-1:c89c34ee-d26d-4785-b24a-633616d7d144";

  static CognitoUser cognitoUser;
}
