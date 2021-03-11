import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ubeachweb/CustomSnackBar.dart';

import '../Object/Global.dart';
import '../Object/Order.dart';
import '../Object/Session.dart';

class OrderDisplayer extends StatefulWidget {
  var orders;
  OrderDisplayer(this.orders);

  @override
  _OrderDisplayerState createState() => _OrderDisplayerState();
}

class _OrderDisplayerState extends State<OrderDisplayer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(border: Border.all(color: Colors.cyan[500])),
      child: Scrollbar(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.orders.length,
          itemBuilder: (context, index) {
            return Card(
                child: ExpansionTile(
              leading: Wrap(spacing: 12, children: [
                IconButton(
                  icon: Icon(Icons.check_sharp),
                  onPressed: () => complete(index),
                ),
                IconButton(
                  icon: Icon(Icons.hourglass_bottom),
                  onPressed: () => sendNotification(index, 1),
                ),
                IconButton(
                  icon: Icon(Icons.fastfood),
                  onPressed: () => sendNotification(index, 2),
                ),
              ]),
              title: Text(widget.orders[index].title +
                  " ~ " +
                  widget.orders[index].username +
                  " ~ " +
                  widget.orders[index].tot),
              expandedAlignment: Alignment.bottomLeft,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              childrenPadding: EdgeInsets.all(15),
              children: [
                InsideOrder(widget.orders[index]),
              ],
            ));
          },
        ),
      ),
    );
  }

  sendNotification(index, code) async {
    var idToken = Session().session.getIdToken().getJwtToken();

    final credentials =
        new CognitoCredentials(Global.identityPoolId, Global.userPool);
    await credentials.getAwsCredentials(idToken);

    const endpoint =
        'https://dl8itwsv47.execute-api.eu-central-1.amazonaws.com/send_notification';
    final awsSigV4Client = new AwsSigV4Client(
        credentials.accessKeyId, credentials.secretAccessKey, endpoint,
        sessionToken: credentials.sessionToken, region: 'eu-central-1');

    final signedRequest = new SigV4Request(awsSigV4Client,
        method: 'POST',
        path: '/send-notification',
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: {'order': widget.orders[index].id, 'code': code});

    http.Response response;

    try {
      response = await http.post(signedRequest.url,
          headers: signedRequest.headers, body: signedRequest.body);
    } catch (e) {
      print(e);
    }
    var jsonResponse = json.decode(response.body);
    CustomSnackBar.buildErrorSnackbar(
        context, 'Notifica mandata con successo!', Colors.black);
    print(jsonResponse.body);
    setState(() {});
  }

  send(index, title, body) async {
    var idToken = Session().session.getIdToken().getJwtToken();

    final credentials =
        new CognitoCredentials(Global.identityPoolId, Global.userPool);
    await credentials.getAwsCredentials(idToken);

    const endpoint =
        'https://dl8itwsv47.execute-api.eu-central-1.amazonaws.com/send_notification';
    final awsSigV4Client = new AwsSigV4Client(
        credentials.accessKeyId, credentials.secretAccessKey, endpoint,
        sessionToken: credentials.sessionToken, region: 'eu-central-1');

    final signedRequest = new SigV4Request(awsSigV4Client,
        method: 'POST',
        path: '/send-notification',
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: {'order': widget.orders[index].id, 'title': title, 'body': body});

    http.Response response;

    try {
      response = await http.post(signedRequest.url,
          headers: signedRequest.headers, body: signedRequest.body);
    } catch (e) {
      print(e);
    }
    var jsonResponse = json.decode(response.body);
    //Navigator.of(context).pop();
    CustomSnackBar.buildErrorSnackbar(
        context, 'Notifica mandata con successo!', Colors.black);
    setState(() {});
  }

  complete(index) async {
    var idToken = Session().session.getIdToken().getJwtToken();

    final credentials =
        new CognitoCredentials(Global.identityPoolId, Global.userPool);
    await credentials.getAwsCredentials(idToken);

    const endpoint =
        'https://0c1szrxpm6.execute-api.eu-central-1.amazonaws.com/complete_order';
    final awsSigV4Client = new AwsSigV4Client(
        credentials.accessKeyId, credentials.secretAccessKey, endpoint,
        sessionToken: credentials.sessionToken, region: 'eu-central-1');

    final signedRequest = new SigV4Request(awsSigV4Client,
        method: 'POST',
        path: '/complete-order',
        headers: {
          "Content-Type": "application/json; charset=utf-8"
        },
        body: {
          'item': widget.orders[index].id,
        });

    http.Response response;

    try {
      response = await http.post(signedRequest.url,
          headers: signedRequest.headers, body: signedRequest.body);
    } catch (e) {
      print(e);
    }
    var jsonResponse = json.decode(response.body);
    widget.orders = jsonResponse.map((e) => new Order.fromJson(e)).toList();
    CustomSnackBar.buildErrorSnackbar(
        context, 'Ordine completato con successo!', Colors.black);
    setState(() {});
  }
}

class InsideOrder extends StatelessWidget {
  var order;
  InsideOrder(this.order);
  @override
  Widget build(BuildContext context) {
    String cart = "";
    for (int i = 0; i < order.cart.length; i++) {
      cart += order.cart[i].toString() + ", \n";
    }
    cart = cart.substring(0, cart.length - 3);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Carrello: \n\n" + cart),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Totale: " + order.tot),
              Text("Utente: " + order.username),
            ],
          ),
        ),
      ],
    );
  }
}
