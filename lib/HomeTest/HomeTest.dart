import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
//import 'package:ubeachweb/Home/GraphBuilder.dart';
import 'package:ubeachweb/HomeTest/EditChalet.dart';
import 'package:ubeachweb/HomeTest/OrderDisplayer.dart';
import '../AllOrders.dart';
import '../CustomSnackBar.dart';
import '../Object/Global.dart';
import '../Object/Order.dart';
import '../Object/Session.dart';
import '../Object/Chalet.dart';
import 'package:http/http.dart' as http;
import '../EditMenu.dart';
import 'StatsBuilder.dart';
import 'GraphBuilder2.dart';

class HomeTest extends StatefulWidget {
  Chalet chalet;
  HomeTest(this.chalet);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeTest> {
  var _uncompletedOrders;
  var _allOrders;
  @override
  void initState() {
    super.initState();
    _uncompletedOrders = getUncompletedOrders();
    _allOrders = getAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.cyan[400],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [StatsBuilder(_allOrders)],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: GraphBuilder(_allOrders),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(children: [
                      Text('Ordini: '),
                      IconButton(
                          iconSize: 20,
                          icon: Icon(Icons.replay_outlined),
                          onPressed: () {
                            setState(() {
                              _uncompletedOrders = getUncompletedOrders();
                              _allOrders = getAllOrders();
                            });
                          })
                    ]),
                  ),
                  FutureBuilder(
                      future: _uncompletedOrders,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return OrderDisplayer(snapshot.data);
                        } else
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                            padding: EdgeInsets.only(top: 20),
                          );
                      }),
                ],
              ),
            ),
          ),
        ]),
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.cyan[400],
        animatedIcon: AnimatedIcons.menu_close,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              backgroundColor: Colors.cyan[400],
              child: Icon(Icons.edit),
              label: 'Modifica menu',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditMenu3()),
                  )),
          SpeedDialChild(
              backgroundColor: Colors.cyan[400],
              child: Icon(Icons.list),
              label: 'Storico ordini',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllOrders()),
                  )),
          SpeedDialChild(
              backgroundColor: Colors.cyan[400],
              child: Icon(Icons.settings),
              label: 'Modifica chalet',
              onTap: () => editChalet(widget.chalet)),
          /*SpeedDialChild(
            backgroundColor: Colors.cyan[400],
            child: Icon(Icons.list),
            label: 'Test Add Menu',
            onTap: () => testAddMenu(),
          ),*/
          /*SpeedDialChild(
              backgroundColor: Colors.cyan[400],
              child: Icon(Icons.list),
              label: 'Snack Bar',
              onTap: () => CustomSnackBar.buildErrorSnackbar(context, "Test")),*/
        ],
      ),
    );
  }

  editChalet(chalet) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: EditChalet(chalet),
            actions: [],
          );
        }).then((value) => {
          getData(),
          CustomSnackBar.buildErrorSnackbar(
              context, "Informazioni cambiate con successo", Colors.black),
        });
  }

  getData() async {
    widget.chalet = await getChaletInfo();
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

saveChaletInfo(String name, String description, String location) async {
  var idToken = Session().session.getIdToken().getJwtToken();

  final credentials =
      new CognitoCredentials(Global.identityPoolId, Global.userPool);
  await credentials.getAwsCredentials(idToken);

  const endpoint =
      'https://69hvw51s2c.execute-api.eu-central-1.amazonaws.com/edit_chalet';
  final awsSigV4Client = new AwsSigV4Client(
      credentials.accessKeyId, credentials.secretAccessKey, endpoint,
      sessionToken: credentials.sessionToken, region: 'eu-central-1');

  final signedRequest = new SigV4Request(awsSigV4Client,
      method: 'POST',
      path: '/edit-chalet',
      headers: {
        "Content-Type": "application/json; charset=utf-8"
      },
      body: {
        'name': name.isEmpty ? "" : name,
        'description': description.isEmpty ? "" : description,
        'location': location.isEmpty ? "" : location
      });

  http.Response response;

  try {
    response = await http.post(signedRequest.url,
        headers: signedRequest.headers, body: signedRequest.body);
  } catch (e) {
    print(e);
  }
  var jsonResponse = json.decode(response.body);
}

testAddMenu() async {
  final credentials =
      new CognitoCredentials(Global.identityPoolId, Global.userPool);
  var idToken = Session().session.getIdToken().getJwtToken();

  await credentials.getAwsCredentials(idToken);
  const endpoint =
      'https://txqjmzytpb.execute-api.eu-central-1.amazonaws.com/add_menu';
  final awsSigV4Client = new AwsSigV4Client(
      credentials.accessKeyId, credentials.secretAccessKey, endpoint,
      sessionToken: credentials.sessionToken, region: 'eu-central-1');

  final signedRequest = new SigV4Request(awsSigV4Client,
      method: 'POST',
      path: '/add-menu',
      headers: new Map<String, String>.from(
          {'Content-Type': 'application/json; charset=utf-8'}),
      body: new Map<String, dynamic>.from({}));

  http.Response response;
  try {
    response = await http.post(
      signedRequest.url,
      headers: signedRequest.headers,
      body: signedRequest.body,
    );
  } catch (e) {
    print(e);
  }
  var jsonResponse = json.decode(response.body);
}

Future getUncompletedOrders() async {
  final credentials =
      new CognitoCredentials(Global.identityPoolId, Global.userPool);
  var idToken = Session().session.getIdToken().getJwtToken();

  await credentials.getAwsCredentials(idToken);
  const endpoint =
      'https://m25kk1z63b.execute-api.eu-central-1.amazonaws.com/get_incompleted_orders';
  final awsSigV4Client = new AwsSigV4Client(
      credentials.accessKeyId, credentials.secretAccessKey, endpoint,
      sessionToken: credentials.sessionToken, region: 'eu-central-1');

  final signedRequest = new SigV4Request(awsSigV4Client,
      method: 'POST',
      path: '/get-incompleted-orders',
      headers: new Map<String, String>.from(
          {'Content-Type': 'application/json; charset=utf-8'}),
      body: new Map<String, dynamic>.from({}));

  http.Response response;
  try {
    response = await http.post(
      signedRequest.url,
      headers: signedRequest.headers,
      body: signedRequest.body,
    );
  } catch (e) {
    print(e);
  }
  var jsonResponse = json.decode(response.body);
  return await jsonResponse.map((e) => new Order.fromJson(e)).toList();
}

Future getAllOrders() async {
  final credentials =
      new CognitoCredentials(Global.identityPoolId, Global.userPool);
  var idToken = Session().session.getIdToken().getJwtToken();

  await credentials.getAwsCredentials(idToken);
  const endpoint =
      'https://6a0t7a3kh9.execute-api.eu-central-1.amazonaws.com/orders';
  final awsSigV4Client = new AwsSigV4Client(
      credentials.accessKeyId, credentials.secretAccessKey, endpoint,
      sessionToken: credentials.sessionToken, region: 'eu-central-1');

  final signedRequest = new SigV4Request(awsSigV4Client,
      method: 'POST',
      path: '/get-orders',
      headers: new Map<String, String>.from(
          {'Content-Type': 'application/json; charset=utf-8'}),
      body: new Map<String, dynamic>.from({
        'object': 'chalet',
      }));

  http.Response response;
  try {
    response = await http.post(
      signedRequest.url,
      headers: signedRequest.headers,
      body: signedRequest.body,
    );
  } catch (e) {
    print(e);
  }
  var jsonResponse = json.decode(response.body);
  return await jsonResponse.map((e) => new Order.fromJson(e)).toList();
}
