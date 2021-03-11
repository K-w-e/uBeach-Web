import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Object/SalesData.dart';

class GraphBuilder extends StatefulWidget {
  var _allOrders;
  GraphBuilder(this._allOrders);
  @override
  _GraphBuilderState createState() => _GraphBuilderState();
}

class _GraphBuilderState extends State<GraphBuilder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      child: DefaultTabController(
        length: 2,
        child: SizedBox(
          height: 300.0,
          child: Column(
            children: <Widget>[
              TabBar(
                labelColor: Colors.black,
                tabs: <Widget>[
                  Tab(
                    text: "Vendite",
                  ),
                  Tab(
                    text: "Guadagni",
                  )
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    Container(
                      child: FutureBuilder(
                          future: widget._allOrders,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              Map vendite = {};
                              for (int i = 0; i < snapshot.data.length; i++)
                                if (vendite.containsKey(snapshot.data[i].title))
                                  vendite[snapshot.data[i].title]++;
                                else
                                  vendite[snapshot.data[i].title] = 1;
                              return SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                series: <LineSeries<SalesData, String>>[
                                  LineSeries<SalesData, String>(
                                      dataSource: [
                                        for (var key in vendite.keys)
                                          SalesData(key, vendite[key]),
                                      ],
                                      xValueMapper: (SalesData sales, _) =>
                                          sales.date,
                                      yValueMapper: (SalesData sales, _) =>
                                          sales.orders,
                                      dataLabelSettings:
                                          DataLabelSettings(isVisible: true)),
                                ],
                              );
                            } else
                              return Center(child: CircularProgressIndicator());
                          }),
                    ),
                    Container(
                      child: FutureBuilder(
                          future: widget._allOrders,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              Map guadagni = {};
                              for (int i = 0; i < snapshot.data.length; i++)
                                if (guadagni
                                    .containsKey(snapshot.data[i].title))
                                  guadagni[snapshot.data[i].title] += int.parse(
                                      snapshot.data[i].tot.substring(
                                          0, snapshot.data[i].tot.length - 1));
                                else
                                  guadagni[snapshot.data[i].title] = int.parse(
                                      snapshot.data[i].tot.substring(
                                          0, snapshot.data[i].tot.length - 1));
                              return SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                series: <SplineSeries<SalesData, String>>[
                                  SplineSeries<SalesData, String>(
                                      dataSource: [
                                        for (var key in guadagni.keys)
                                          SalesData(key, guadagni[key]),
                                      ],
                                      xValueMapper: (SalesData sales, _) =>
                                          sales.date,
                                      yValueMapper: (SalesData sales, _) =>
                                          sales.orders,
                                      dataLabelSettings:
                                          DataLabelSettings(isVisible: true)),
                                ],
                              );
                            } else
                              return Center(child: CircularProgressIndicator());
                          }),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
