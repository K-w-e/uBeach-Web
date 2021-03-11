import 'dart:convert';
import 'dart:io';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:ubeachweb/CustomSnackBar.dart';

import 'HomeTest/HomeTest.dart';
import 'Object/Chalet.dart';
import 'Object/Global.dart';
import 'Object/Order.dart';
import 'Object/Session.dart';
import 'Home/Home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogging = false;
  @override
  void initState() {
    super.initState();
    isLogging = false;
  }

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('uBeach - Web'),
        backgroundColor: Colors.cyan[400],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Container(
            height: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 25.0,
                  spreadRadius: 5.0,
                  offset: Offset(
                    15.0,
                    15.0,
                  ),
                )
              ],
            ),
            width: screenSize.width / 3,
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextField(
                    controller: username,
                    decoration: InputDecoration(
                        hintText: "Enter your username",
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  TextField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Enter your password",
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                              color: Color.fromRGBO(0, 160, 227, 1))),
                      onPressed: () => login(),
                      padding: EdgeInsets.all(10.0),
                      color: Colors.cyan[500],
                      textColor: Colors.white,
                      child: Text("Login", style: TextStyle(fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              width: 300,
              height: 400,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Logging in...",
                      style: TextStyle(fontSize: 36),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
          );
        });
    Global.cognitoUser = new CognitoUser(username.text, Global.userPool);
    final authDetails = new AuthenticationDetails(
        username: username.text, password: password.text);

    CognitoUserSession session;
    try {
      session = await Global.cognitoUser.authenticateUser(authDetails);
      Session(session: session);
      Chalet chalet = await getChaletInfo();
      Navigator.pop(context);
      /*Navigator.push(
          context, MaterialPageRoute(builder: (context) => Home(chalet)));*/
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeTest(chalet)));
    } on CognitoUserNewPasswordRequiredException catch (e) {
      // handle New Password challenge
    } on CognitoUserMfaRequiredException catch (e) {
      // handle SMS_MFA challenge
    } on CognitoUserSelectMfaTypeException catch (e) {
      // handle SELECT_MFA_TYPE challenge
    } on CognitoUserMfaSetupException catch (e) {
      // handle MFA_SETUP challenge
    } on CognitoUserTotpRequiredException catch (e) {
      // handle SOFTWARE_TOKEN_MFA challenge
    } on CognitoUserCustomChallengeException catch (e) {
      // handle CUSTOM_CHALLENGE challenge
    } on CognitoUserConfirmationNecessaryException catch (e) {
      // handle User Confirmation Necessary
    } on CognitoClientException catch (e) {
      // handle Wrong Username and Password and Cognito Client
      Navigator.pop(context);
      CustomSnackBar.buildErrorSnackbar(
          context, 'Username o password errati!', Colors.red);
      print(e);
    } catch (e) {
      print(e);
    }
  }

  getChaletInfo() async {
    var idToken = Session().session.getIdToken().getJwtToken();

    final credentials =
        new CognitoCredentials(Global.identityPoolId, Global.userPool);
    await credentials.getAwsCredentials(idToken);

    const endpoint =
        'https://kp49ihfd95.execute-api.eu-central-1.amazonaws.com/chalet_info';
    final awsSigV4Client = new AwsSigV4Client(
        credentials.accessKeyId, credentials.secretAccessKey, endpoint,
        sessionToken: credentials.sessionToken, region: 'eu-central-1');

    final signedRequest = new SigV4Request(awsSigV4Client,
        method: 'POST',
        path: '/chalet-info',
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: {});

    http.Response response;

    try {
      response = await http.post(signedRequest.url,
          headers: signedRequest.headers, body: signedRequest.body);
    } catch (e) {
      print(e);
    }
    var chalet = json.decode(response.body);
    return Chalet.fromJson(chalet);
  }
}
