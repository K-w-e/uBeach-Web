import 'dart:convert';
//import 'dart:html' as html;
import 'dart:io';
import 'dart:typed_data';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ubeachweb/CustomSnackBar.dart';
import 'package:ubeachweb/Object/Chalet.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../Object/Global.dart';
import '../Object/Session.dart';

class InfoDisplayer extends StatefulWidget {
  Chalet chalet;
  InfoDisplayer(this.chalet);

  @override
  _InfoDisplayerState createState() => _InfoDisplayerState();
}

class _InfoDisplayerState extends State<InfoDisplayer> {
  File file;
  var _chalet;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    _chalet = getChaletInfo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: screenSize.width / 2,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            FutureBuilder(
                future: _chalet,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Text("Informazioni chalet "),
                        Text(snapshot.data.name,
                            style: TextStyle(fontSize: 20)),
                        Text(
                          snapshot.data.description,
                          style: TextStyle(fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(snapshot.data.location,
                            style: TextStyle(fontSize: 20)),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => editChalet(context),
                          ),
                        ),
                        Container(
                            width: 300,
                            child: InkWell(
                              onTap: () => createPresignedUrl(),
                              child: Image.network(
                                widget.chalet.image,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace stackTrace) {
                                  return SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: Icon(Icons.add_a_photo));
                                },
                                width: 250,
                              ),
                            ))
                      ],
                    );
                  } else
                    return Container();
                }),
          ]),
        ));
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

  void createPresignedUrl() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    result.files.first.extension;
    if (result != null) {
      PlatformFile file = result.files.first;

      var idToken = Session().session.getIdToken().getJwtToken();

      final credentials =
          new CognitoCredentials(Global.identityPoolId, Global.userPool);
      await credentials.getAwsCredentials(idToken);

      const endpoint =
          'https://yjviz01zh5.execute-api.eu-central-1.amazonaws.com/upload_file';
      final awsSigV4Client = new AwsSigV4Client(
          credentials.accessKeyId, credentials.secretAccessKey, endpoint,
          sessionToken: credentials.sessionToken, region: 'eu-central-1');

      final signedRequest = new SigV4Request(awsSigV4Client,
          method: 'PUT',
          path: '/upload-file',
          headers: {
            "Content-Type": "application/json; charset=utf-8"
          },
          body: {
            'name': 'background.' + result.files.first.extension,
          });

      http.Response response;
      try {
        response = await http.put(signedRequest.url,
            headers: signedRequest.headers, body: signedRequest.body);
      } catch (e) {
        print(e);
      }
      String link = json.decode(response.body);
      usePresignedUrl(link, file);
    } else {
      // User canceled the picker
    }
  }

  void usePresignedUrl(link, file) async {
    var request = http
        .put(Uri.parse(link), body: file.bytes)
        .then((value) => () {
              print(value.statusCode);
              if (value.statusCode == 200) getData();
            })
        .then((value) => CustomSnackBar.buildErrorSnackbar(
            context, "Immagine cambiata con successo", Colors.black));
  }

  Future<void> editChalet(context) async {
    TextEditingController name =
        new TextEditingController(text: widget.chalet.name);
    TextEditingController description =
        new TextEditingController(text: widget.chalet.description);
    TextEditingController location =
        new TextEditingController(text: widget.chalet.location);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifica chalet'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: "Enter your name...",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
                TextFormField(
                  controller: description,
                  decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: "Enter your description...",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
                TextFormField(
                  controller: location,
                  decoration: InputDecoration(
                      labelText: 'Location',
                      hintText: "Enter your location...",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Salva'),
              onPressed: () {
                saveChaletInfo(name.text, description.text, location.text);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Annulla'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
    getData();
  }
}
