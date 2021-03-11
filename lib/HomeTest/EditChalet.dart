import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ubeachweb/CustomSnackBar.dart';
import 'package:ubeachweb/Object/Chalet.dart';
import 'package:ubeachweb/Object/Global.dart';
import 'package:ubeachweb/Object/Session.dart';
import 'package:http/http.dart' as http;

class EditChalet extends StatelessWidget {
  var chalet;
  EditChalet(this.chalet);
  @override
  Widget build(BuildContext context) {
    TextEditingController name = new TextEditingController(text: chalet.name);
    TextEditingController description =
        new TextEditingController(text: chalet.description);
    TextEditingController location =
        new TextEditingController(text: chalet.location);
    return Container(
      height: 500,
      width: 300,
      child: Column(
        children: [
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
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
                width: 250,
                child: InkWell(
                  onTap: () => createPresignedUrl(context),
                  child: Image.network(
                    chalet.image,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                      return SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(Icons.add_a_photo));
                    },
                    width: 200,
                  ),
                )),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
          )
        ],
      ),
    );
  }

  void createPresignedUrl(context) async {
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
      usePresignedUrl(link, file, context);
    } else {
      // User canceled the picker
    }
  }

  void usePresignedUrl(link, file, context) async {
    var request = http
        .put(Uri.parse(link), body: file.bytes)
        .then((value) => () {
              print(value.statusCode);
              //if (value.statusCode == 200) getData();
            })
        .then((value) => {
              CustomSnackBar.buildErrorSnackbar(
                  context, "Immagine cambiata con successo", Colors.black),
              Navigator.of(context).pop()
            });
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
    chalet = Chalet.fromJson(jsonResponse);
    //CustomSnackBar.buildErrorSnackbar(context, "Test", Colors.black);
  }
}
