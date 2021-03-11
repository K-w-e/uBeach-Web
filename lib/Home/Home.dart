import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:ubeachweb/CustomSnackBar.dart';
import 'package:ubeachweb/Object/SalesData.dart';
import '../AllOrders.dart';
import 'GraphBuilder.dart';
import 'InfoDisplayer.dart';
import '../Object/Global.dart';
import '../Object/Order.dart';
import '../Object/Session.dart';
import 'OrderDisplayer.dart';
import '../Object/Chalet.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import '../EditMenu.dart';
import 'StatsBuilder.dart';

class Home extends StatefulWidget {
  final Chalet chalet;
  Home(this.chalet);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          child: Column(
        children: [
          Row(children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: InfoDisplayer(widget.chalet),
                width: screenSize.width / 3,
              ),
            ),
            Expanded(
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
          ]),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                GraphBuilder(_allOrders),
                StatsBuilder(_allOrders),
              ],
            ),
          )
        ],
      )),
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
