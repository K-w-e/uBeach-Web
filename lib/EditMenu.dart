import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;

import 'Object/Global.dart';
import 'Object/Menu.dart';
import 'Object/Session.dart';

class EditMenu3 extends StatefulWidget {
  @override
  _EditMenu3State createState() => _EditMenu3State();
}

class _EditMenu3State extends State<EditMenu3> {
  var _menu;
  @override
  void initState() {
    super.initState();
    _menu = getMenu();
  }

  @override
  Widget build(BuildContext context) {
    /*Scrollbar(
                  child: FutureBuilder(
                      future: _menu,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return CardBuilder(snapshot.data.bibite[index],
                                  update, 'bibite', index);
                            },
                            itemCount: snapshot.data.bibite.length,
                          );
                        } else
                          return Center(child: CircularProgressIndicator());
                      }),
                ),*/
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Menu"),
          backgroundColor: Colors.cyan[400],
        ),
        body: SingleChildScrollView(
          child: Row(children: [
            Expanded(
              child: Column(
                children: [
                  ExpansionTile(
                      title: Text("Primi"),
                      initiallyExpanded: true,
                      children: [
                        Container(
                          height: 400,
                          child: FutureBuilder(
                              future: _menu,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return CardBuilder(
                                          snapshot.data.primi[index],
                                          update,
                                          'primi',
                                          index);
                                    },
                                    itemCount: snapshot.data.primi.length,
                                  );
                                } else
                                  return Center(
                                      child: CircularProgressIndicator());
                              }),
                        ),
                      ]),
                  ExpansionTile(
                      title: Text("Primi"),
                      initiallyExpanded: true,
                      children: [
                        Container(
                          height: 400,
                          child: FutureBuilder(
                              future: _menu,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return CardBuilder(
                                          snapshot.data.secondi[index],
                                          update,
                                          'secondi',
                                          index);
                                    },
                                    itemCount: snapshot.data.secondi.length,
                                  );
                                } else
                                  return Center(
                                      child: CircularProgressIndicator());
                              }),
                        ),
                      ]),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  ExpansionTile(
                      title: Text("Bar"),
                      initiallyExpanded: true,
                      children: [
                        Container(
                          height: 400,
                          child: FutureBuilder(
                              future: _menu,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return CardBuilder(
                                          snapshot.data.bar[index],
                                          update,
                                          'bar',
                                          index);
                                    },
                                    itemCount: snapshot.data.bar.length,
                                  );
                                } else
                                  return Center(
                                      child: CircularProgressIndicator());
                              }),
                        ),
                      ]),
                  ExpansionTile(
                      title: Text("Bibite"),
                      initiallyExpanded: true,
                      children: [
                        Container(
                          height: 400,
                          child: FutureBuilder(
                              future: _menu,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return CardBuilder(
                                          snapshot.data.bibite[index],
                                          update,
                                          'bibite',
                                          index);
                                    },
                                    itemCount: snapshot.data.bibite.length,
                                  );
                                } else
                                  return Center(
                                      child: CircularProgressIndicator());
                              }),
                        ),
                      ]),
                ],
              ),
            ),
          ]),
        ),

        /*GridView.count(
              padding: const EdgeInsets.all(5),
              crossAxisCount: 2,
              children: <Widget>[
                ExpansionTile(
                    title: Text("Primi"),
                    initiallyExpanded: true,
                    children: [
                      Container(
                        height: 400,
                        child: FutureBuilder(
                            future: _menu,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CardBuilder(
                                        snapshot.data.primi[index],
                                        update,
                                        'primi',
                                        index);
                                  },
                                  itemCount: snapshot.data.primi.length,
                                );
                              } else
                                return Center(
                                    child: CircularProgressIndicator());
                            }),
                      ),
                    ]),
                ExpansionTile(
                    title: Text("Secondi"),
                    initiallyExpanded: true,
                    children: [
                      Container(
                        height: 400,
                        child: FutureBuilder(
                            future: _menu,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CardBuilder(
                                        snapshot.data.secondi[index],
                                        update,
                                        'secondi',
                                        index);
                                  },
                                  itemCount: snapshot.data.secondi.length,
                                );
                              } else
                                return Center(
                                    child: CircularProgressIndicator());
                            }),
                      ),
                    ]),
                ExpansionTile(
                    title: Text("Bar"),
                    initiallyExpanded: true,
                    children: [
                      Container(
                        height: 400,
                        child: FutureBuilder(
                            future: _menu,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CardBuilder(snapshot.data.bar[index],
                                        update, 'bar', index);
                                  },
                                  itemCount: snapshot.data.bar.length,
                                );
                              } else
                                return Center(
                                    child: CircularProgressIndicator());
                            }),
                      ),
                    ]),
                ExpansionTile(
                    title: Text("Bibite"),
                    initiallyExpanded: true,
                    children: [
                      Container(
                        height: 400,
                        child: FutureBuilder(
                            future: _menu,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CardBuilder(
                                        snapshot.data.bibite[index],
                                        update,
                                        'bibite',
                                        index);
                                  },
                                  itemCount: snapshot.data.bibite.length,
                                );
                              } else
                                return Center(
                                    child: CircularProgressIndicator());
                            }),
                      ),
                    ]),
              ],
            )*/

        floatingActionButton: SpeedDial(
          backgroundColor: Colors.cyan[400],
          animatedIcon: AnimatedIcons.menu_close,
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
              backgroundColor: Colors.cyan[400],
              child: Icon(Icons.add),
              onTap: () => add(),
            )
          ],
        ));
  }

  update() async {
    setState(() {
      _menu = getMenu();
    });
  }

  Future getMenu() async {
    var idToken = Session().session.getIdToken().getJwtToken();

    final credentials =
        new CognitoCredentials(Global.identityPoolId, Global.userPool);
    await credentials.getAwsCredentials(idToken);

    const endpoint =
        'https://be8xujvfxh.execute-api.eu-central-1.amazonaws.com/menu_info';
    final awsSigV4Client = new AwsSigV4Client(
        credentials.accessKeyId, credentials.secretAccessKey, endpoint,
        sessionToken: credentials.sessionToken, region: 'eu-central-1');

    final signedRequest = new SigV4Request(awsSigV4Client,
        method: 'POST',
        path: '/get-menu-info',
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: {});

    http.Response response;

    try {
      response = await http.post(signedRequest.url,
          headers: signedRequest.headers, body: signedRequest.body);
    } catch (e) {
      print(e);
    }
    var jsonResponse = json.decode(response.body);
    return await Menu.fromJson(jsonResponse);
  }

  add() async {
    TextEditingController name = new TextEditingController();
    TextEditingController ingredients = new TextEditingController();
    TextEditingController price = new TextEditingController();
    String dropdownValue = 'Primi';
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Aggiungi articolo'),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Row(
                    children: [
                      Text("Categoria    "),
                      DropdownButton(
                          value: dropdownValue,
                          onChanged: (newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          items:
                              ['Primi', 'Secondi', 'Bar', 'Bibite'].map((val) {
                            return DropdownMenuItem(
                              child: new Text(val),
                              value: val,
                            );
                          }).toList()),
                    ],
                  ),
                  TextField(
                      controller: name,
                      decoration: InputDecoration(
                          labelText: "Name",
                          hintText: "Enter name",
                          hintStyle: TextStyle(color: Colors.grey))),
                  TextField(
                      controller: price,
                      decoration: InputDecoration(
                          labelText: "Price",
                          hintText: "Enter price",
                          hintStyle: TextStyle(color: Colors.grey))),
                  TextField(
                      controller: ingredients,
                      decoration: InputDecoration(
                          labelText: "Ingredients",
                          hintText: "Enter ingredients",
                          hintStyle: TextStyle(color: Colors.grey))),
                ],
              ),
            );
          }),
          actions: <Widget>[
            TextButton(
              child: Text('Aggiungi'),
              onPressed: () {
                addItem(name.text, price.text, ingredients.text, dropdownValue);
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

  addItem(String name, String price, String ingredients,
      String dropdownValue) async {
    var idToken = Session().session.getIdToken().getJwtToken();

    final credentials =
        new CognitoCredentials(Global.identityPoolId, Global.userPool);
    await credentials.getAwsCredentials(idToken);

    const endpoint =
        'https://jf004e1yz6.execute-api.eu-central-1.amazonaws.com/add_item_to_menu';
    final awsSigV4Client = new AwsSigV4Client(
        credentials.accessKeyId, credentials.secretAccessKey, endpoint,
        sessionToken: credentials.sessionToken, region: 'eu-central-1');

    final signedRequest = new SigV4Request(awsSigV4Client,
        method: 'POST',
        path: '/add-item-to-menu',
        headers: {
          "Content-Type": "application/json; charset=utf-8"
        },
        body: {
          'type': dropdownValue.toLowerCase(),
          'name': name,
          'price': double.parse(price),
          'ingredients': ingredients,
          'id': credentials.userIdentityId
        });

    http.Response response;

    try {
      response = await http.post(signedRequest.url,
          headers: signedRequest.headers, body: signedRequest.body);
    } catch (e) {
      print(e);
    }
    update();
  }
}

class CardBuilder extends StatefulWidget {
  Function update;
  var item;
  var index;
  var type;
  CardBuilder(this.item, this.update, this.type, this.index);

  @override
  _CardBuilderState createState() => _CardBuilderState();
}

class _CardBuilderState extends State<CardBuilder> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: Wrap(children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () => delete(widget.index, widget.item['image']),
        ),
        InkWell(
          onTap: () => createPresignedUrl(
              widget.item['name'], widget.type, widget.index),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              widget.item['image'],
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace stackTrace) {
                return SizedBox(
                    width: 40, height: 40, child: Icon(Icons.add_a_photo));
              },
              height: 40,
              width: 40,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ]),
      title: Text(widget.item['name']),
      subtitle: Text(widget.item['price'].toString() +
          "\€ ~ " +
          widget.item['ingredients']),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () => edit(widget.index),
      ),
    ));
  }

  delete(index, image) async {
    var idToken = Session().session.getIdToken().getJwtToken();

    final credentials =
        new CognitoCredentials(Global.identityPoolId, Global.userPool);
    await credentials.getAwsCredentials(idToken);

    const endpoint =
        'https://mbe0nhsvlj.execute-api.eu-central-1.amazonaws.com/remove_item_from_menu';
    final awsSigV4Client = new AwsSigV4Client(
        credentials.accessKeyId, credentials.secretAccessKey, endpoint,
        sessionToken: credentials.sessionToken, region: 'eu-central-1');

    final signedRequest = new SigV4Request(awsSigV4Client,
        method: 'POST',
        path: '/remove-item-from-menu',
        headers: {
          "Content-Type": "application/json; charset=utf-8"
        },
        body: {
          'type': widget.type,
          'index': index,
          'image': image.toString(),
        });

    http.Response response;

    try {
      response = await http.post(signedRequest.url,
          headers: signedRequest.headers, body: signedRequest.body);
    } catch (e) {
      print(e);
    }
    widget.update();
  }

  void createPresignedUrl(name, type, index) async {
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
            'type': type,
            'index': index,
            'name': name + "." + result.files.first.extension,
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
        .then((value) => print(value.body));
  }

  edit(index) async {
    TextEditingController name =
        new TextEditingController(text: widget.item['name']);
    TextEditingController ingredients =
        new TextEditingController(text: widget.item['ingredients']);
    TextEditingController price =
        new TextEditingController(text: widget.item['price'].toString());
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifica articolo'),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                      controller: name,
                      decoration: InputDecoration(
                          labelText: "Name",
                          hintText: "Enter name",
                          hintStyle: TextStyle(color: Colors.grey))),
                  TextField(
                      controller: price,
                      decoration: InputDecoration(
                          labelText: "Price",
                          hintText: "Enter price",
                          hintStyle: TextStyle(color: Colors.grey))),
                  TextField(
                      controller: ingredients,
                      decoration: InputDecoration(
                          labelText: "Ingredients",
                          hintText: "Enter ingredients",
                          hintStyle: TextStyle(color: Colors.grey))),
                ],
              ),
            );
          }),
          actions: <Widget>[
            TextButton(
              child: Text('Salva modifiche'),
              onPressed: () {
                editItem(name.text, price.text, ingredients.text, index);
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

  editItem(name, price, ingredients, index) async {
    var idToken = Session().session.getIdToken().getJwtToken();

    final credentials =
        new CognitoCredentials(Global.identityPoolId, Global.userPool);
    await credentials.getAwsCredentials(idToken);

    const endpoint =
        'https://ipiad1xzp0.execute-api.eu-central-1.amazonaws.com/modify_menu_item';
    final awsSigV4Client = new AwsSigV4Client(
        credentials.accessKeyId, credentials.secretAccessKey, endpoint,
        sessionToken: credentials.sessionToken, region: 'eu-central-1');

    final signedRequest = new SigV4Request(awsSigV4Client,
        method: 'POST',
        path: '/modify-menu-item',
        headers: {
          "Content-Type": "application/json; charset=utf-8"
        },
        body: {
          'type': widget.type,
          'index': index,
          'name': name,
          'price': double.parse(price),
          'ingredients': ingredients,
        });

    http.Response response;

    try {
      response = await http.post(signedRequest.url,
          headers: signedRequest.headers, body: signedRequest.body);
    } catch (e) {
      print(e);
    }
    widget.update();
  }
}
