import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ubeachweb/Home/OrderDisplayer.dart';
import 'Object/Global.dart';
import 'Object/Order.dart';
import 'Object/Session.dart';

class AllOrders extends StatefulWidget {
  var orders;
  @override
  _AllOrdersState createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  @override
  void initState() {
    super.initState();
    widget.orders = getOrders();
    print(widget.orders);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          backgroundColor: Colors.cyan[400],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(child: Text("Ordini")),
              FutureBuilder(
                  future: widget.orders,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Card(
                              child: ExpansionTile(
                            title: Text(snapshot.data[index].title +
                                " - " +
                                snapshot.data[index].username),
                            expandedAlignment: Alignment.bottomLeft,
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            childrenPadding: EdgeInsets.all(15),
                            children: [
                              InsideOrder(snapshot.data[index]),
                            ],
                          ));
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  })
            ],
          ),
        ));
  }
}

getOrders() async {
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
        'id': credentials.userIdentityId,
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
