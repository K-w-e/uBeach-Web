import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatsBuilder extends StatefulWidget {
  var orders;
  StatsBuilder(this.orders);
  @override
  _StatsBuilderState createState() => _StatsBuilderState();
}

class _StatsBuilderState extends State<StatsBuilder> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Column(
            children: [
              SizedBox(
                width: 250,
                height: 70,
                child: FutureBuilder(
                    future: widget.orders,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      num guadagno = 0;
                      if (snapshot.hasData) {
                        for (int i = 0; i < snapshot.data.length; i++)
                          if (DateTime.now()
                                  .difference(snapshot.data[i].date)
                                  .inDays ==
                              0)
                            guadagno += int.parse(snapshot.data[i].tot
                                .substring(0, snapshot.data[i].tot.length - 1));
                        return ListTile(
                            leading: Icon(Icons.monetization_on),
                            title: Text("Guadagno giornaliero"),
                            subtitle: Text(guadagno.toString() + "\$"));
                      } else
                        return Center(child: CircularProgressIndicator());
                    }),
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            children: [
              SizedBox(
                width: 250,
                height: 70,
                child: FutureBuilder(
                    future: widget.orders,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      num nOrders = 0;
                      if (snapshot.hasData) {
                        for (int i = 0; i < snapshot.data.length; i++)
                          if (DateTime.now()
                                  .difference(snapshot.data[i].date)
                                  .inDays ==
                              0) nOrders++;
                        return ListTile(
                            leading: Icon(Icons.format_list_bulleted),
                            title: Text("Ordini giornalieri"),
                            subtitle: Text(nOrders.toString()));
                      } else
                        return Center(child: CircularProgressIndicator());
                    }),
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            children: [
              SizedBox(
                width: 250,
                height: 70,
                child: FutureBuilder(
                    future: widget.orders,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      List temp = [];
                      if (snapshot.hasData) {
                        for (int i = 0; i < snapshot.data.length; i++)
                          if (DateTime.now()
                                  .difference(snapshot.data[i].date)
                                  .inDays ==
                              0) if (temp.contains(snapshot.data[i].username))
                            break;
                          else
                            temp.add(snapshot.data[i].username);
                        return ListTile(
                            leading: Icon(Icons.account_tree),
                            title: Text("Utilizzatori giornalieri"),
                            subtitle: Text(temp.length.toString()));
                      } else
                        return Center(child: CircularProgressIndicator());
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
