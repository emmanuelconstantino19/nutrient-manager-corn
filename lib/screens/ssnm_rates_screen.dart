import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tabbar/tabbar.dart';

class SSNMRatesScreen extends StatefulWidget {
  final Map<dynamic,dynamic> targetData, econData, prices;
  final double area;
  final List<String> fertilizerCombination;

  SSNMRatesScreen({Key key,
    @required this.targetData,
    @required this.econData,
    @required this.area,
    @required this.fertilizerCombination,
    @required this.prices});

  @override
  _SSNMRatesScreenState createState() => _SSNMRatesScreenState();
}

class _SSNMRatesScreenState extends State<SSNMRatesScreen> {
  final controller = PageController();
  final formatter = new NumberFormat("#,###.##");

  String capitalize(word) {
    return "${word[0].toUpperCase()}${word.substring(1)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SSNM Rates"),
        centerTitle: true,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  print("View summary");
                },
                child: Icon(
                    Icons.read_more
                ),
              )
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: TabbarHeader(
            controller: controller,
            tabs: [
              Tab(text: "Economic Yield"),
              Tab(text: "Target Yield"),
            ],
          ),
        ),
      ),
      body: TabbarContent(
        controller: controller,
        children: <Widget>[
          ListView(children: <Widget>[
            SizedBox(height:10),
            Center(
                child: Text(
                  'Fertilizer Rate Recommendation (kg)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            DataTable(
              columnSpacing: 25,
              columns: [
                DataColumn(label: Text('')),
                DataColumn(label: Text('N')),
                DataColumn(label: Text('P₂O₅')),
                DataColumn(label: Text('K₂O')),
              ],
              rows: [
                  DataRow(cells: [
                    DataCell(Text("per hectare")),
                    DataCell(Text( (widget.econData['frr']['n']/widget.area).toStringAsFixed(2) )),
                    DataCell(Text( (widget.econData['frr']['p']/widget.area).toStringAsFixed(2) )),
                    DataCell(Text( (widget.econData['frr']['k']/widget.area).toStringAsFixed(2) )),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("farmer's area")),
                    DataCell(Text(widget.econData['frr']['n'].toStringAsFixed(2))),
                    DataCell(Text(widget.econData['frr']['p'].toStringAsFixed(2))),
                    DataCell(Text(widget.econData['frr']['k'].toStringAsFixed(2))),
                  ])
              ],
            ),
            SizedBox(height:20),
            Center(
                child: Text(
                  'Amount of Fertilizer',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            Center(
                child: Text(
                  "per hectare",
                  style: TextStyle(fontSize: 15),
                )),
            DataTable(
              columnSpacing: 25,
              columns: [
                DataColumn(label: Text('')),
                DataColumn(label: Text('kg')),
                DataColumn(label: Text('Bag')),
                DataColumn(label: Text('Cost\n(PHP)',overflow: TextOverflow.ellipsis,)),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text(capitalize((widget.fertilizerCombination[0]=='muriateOfPotash') ? "muriate of potash" : widget.fertilizerCombination[0]))),
                  DataCell(Text( formatter.format((widget.econData['amf'][widget.fertilizerCombination[0]]/widget.area)) )),
                  DataCell(Text( formatter.format(((widget.econData['amf'][widget.fertilizerCombination[0]]/widget.area)/50))  )),
                  DataCell(Text(  formatter.format((((widget.econData['amf'][widget.fertilizerCombination[0]]/widget.area)/50)*widget.prices['n'])).toString()))
                ]),
                DataRow(cells: [
                  DataCell(Text(capitalize(widget.fertilizerCombination[1]))),
                  DataCell(Text( formatter.format((widget.econData['amf'][widget.fertilizerCombination[1]]/widget.area)) )),
                  DataCell(Text( formatter.format(((widget.econData['amf'][widget.fertilizerCombination[1]]/widget.area)/50)) )),
                  DataCell(Text( formatter.format((((widget.econData['amf'][widget.fertilizerCombination[1]]/widget.area)/50)*widget.prices['p'])) )),
                ]),
                DataRow(cells: [
                  DataCell(Text(capitalize(widget.fertilizerCombination[2]))),
                  DataCell(Text( formatter.format((widget.econData['amf'][widget.fertilizerCombination[2]]/widget.area)) )),
                  DataCell(Text( formatter.format(((widget.econData['amf'][widget.fertilizerCombination[2]]/widget.area)/50)) )),
                  DataCell(Text( formatter.format((((widget.econData['amf'][widget.fertilizerCombination[2]]/widget.area)/50)*widget.prices['k'])) )),
                ]),
                DataRow(cells: [
                  DataCell(Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text('')),
                  DataCell(Text('')),
                  DataCell(
                      Text(
                          formatter.format(
                              (((widget.econData['amf'][widget.fertilizerCombination[0]]/widget.area)/50)*widget.prices['n']) +
                                  (((widget.econData['amf'][widget.fertilizerCombination[1]]/widget.area)/50)*widget.prices['p']) +
                                  (((widget.econData['amf'][widget.fertilizerCombination[2]]/widget.area)/50)*widget.prices['k'])

                          ), style: TextStyle(fontWeight: FontWeight.bold)
                      )
                  ),
                ]),
              ],
            ),
            SizedBox(height:20),
            Center(
                child: Text(
                  'Amount of Fertilizer',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            Center(
                child: Text(
                  "farmer's area",
                  style: TextStyle(fontSize: 15),
                )),
            DataTable(
              columnSpacing: 25,
              columns: [
                DataColumn(label: Text('')),
                DataColumn(label: Text('kg')),
                DataColumn(label: Text('Bag')),
                DataColumn(label: Text('Cost\n(PHP)',overflow: TextOverflow.ellipsis,)),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text(capitalize((widget.fertilizerCombination[0]=='muriateOfPotash') ? "muriate of potash" : widget.fertilizerCombination[0]))),
                  DataCell(Text( formatter.format(widget.econData['amf'][widget.fertilizerCombination[0]]) )),
                  DataCell(Text( formatter.format((widget.econData['amf'][widget.fertilizerCombination[0]]/50)) )),
                  DataCell(Text( formatter.format(((widget.econData['amf'][widget.fertilizerCombination[0]]/50)*widget.prices['n'])) )),
                ]),
                DataRow(cells: [
                  DataCell(Text(capitalize(widget.fertilizerCombination[1]))),
                  DataCell(Text( formatter.format(widget.econData['amf'][widget.fertilizerCombination[1]]) )),
                  DataCell(Text( formatter.format((widget.econData['amf'][widget.fertilizerCombination[1]]/50)) )),
                  DataCell(Text( formatter.format(((widget.econData['amf'][widget.fertilizerCombination[1]]/50)*widget.prices['p'])) )),
                ]),
                DataRow(cells: [
                  DataCell(Text(capitalize(widget.fertilizerCombination[2]))),
                  DataCell(Text( formatter.format(widget.econData['amf'][widget.fertilizerCombination[2]]) )),
                  DataCell(Text( formatter.format((widget.econData['amf'][widget.fertilizerCombination[2]]/50)) )),
                  DataCell(Text( formatter.format(((widget.econData['amf'][widget.fertilizerCombination[2]]/50)*widget.prices['k'])) )),
                ]),
                DataRow(cells: [
                  DataCell(Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text('')),
                  DataCell(Text('')),
                  DataCell(
                      Text(
                          formatter.format(
                              ((widget.econData['amf'][widget.fertilizerCombination[0]]/50)*widget.prices['n'])+
                                  ((widget.econData['amf'][widget.fertilizerCombination[1]]/50)*widget.prices['p'])+
                                  ((widget.econData['amf'][widget.fertilizerCombination[2]]/50)*widget.prices['k'])
                          ), style: TextStyle(fontWeight: FontWeight.bold)
                      )
                  ),
                ]),
              ],
            ),
            SizedBox(height:20),
            Center(
                child: Text(
                  'Nutrient Cost Analysis',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            DataTable(
              columns: [
                DataColumn(label: Text('nutrient')),
                DataColumn(label: Text('per hectare',overflow: TextOverflow.ellipsis,)),
                DataColumn(label: Text("farmer's area",overflow: TextOverflow.ellipsis,)),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text('N')),
                  DataCell(Text(formatter.format(widget.econData['cost']['n']/widget.area))),
                  DataCell(Text(formatter.format(widget.econData['cost']['n']))),
                ]),
                DataRow(cells: [
                  DataCell(Text('P₂O₅')),
                  DataCell(Text(formatter.format(widget.econData['cost']['p']/widget.area))),
                  DataCell(Text(formatter.format(widget.econData['cost']['p']))),
                ]),
                DataRow(cells: [
                  DataCell(Text('K₂O')),
                  DataCell(Text(formatter.format(widget.econData['cost']['k']/widget.area))),
                  DataCell(Text(formatter.format(widget.econData['cost']['k']))),
                ]),
              ],
            ),
          ]),
          ListView(children: <Widget>[
            SizedBox(height:10),
            Center(
                child: Text(
                  'Fertilizer Rate Recommendation (kg)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            DataTable(
              columnSpacing: 25,
              columns: [
                DataColumn(label: Text('')),
                DataColumn(label: Text('N')),
                DataColumn(label: Text('P₂O₅')),
                DataColumn(label: Text('K₂O')),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text("per hectare")),
                  DataCell(Text( (widget.targetData['frr']['n']/widget.area).toStringAsFixed(2) )),
                  DataCell(Text( (widget.targetData['frr']['p']/widget.area).toStringAsFixed(2) )),
                  DataCell(Text( (widget.targetData['frr']['k']/widget.area).toStringAsFixed(2) )),
                ]),
                DataRow(cells: [
                  DataCell(Text("farmer's area")),
                  DataCell(Text(widget.targetData['frr']['n'].toStringAsFixed(2))),
                  DataCell(Text(widget.targetData['frr']['p'].toStringAsFixed(2))),
                  DataCell(Text(widget.targetData['frr']['k'].toStringAsFixed(2))),
                ])
              ],
            ),
            SizedBox(height:20),
            Center(
                child: Text(
                  'Amount of Fertilizer',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            Center(
                child: Text(
                  "per hectare",
                  style: TextStyle(fontSize: 15),
                )),
            DataTable(
              columnSpacing: 25,
              columns: [
                DataColumn(label: Text('')),
                DataColumn(label: Text('kg')),
                DataColumn(label: Text('Bag')),
                DataColumn(label: Text('Cost\n(PHP)',overflow: TextOverflow.ellipsis,)),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text(capitalize((widget.fertilizerCombination[0]=='muriateOfPotash') ? "muriate of potash" : widget.fertilizerCombination[0]))),
                  DataCell(Text( formatter.format((widget.targetData['amf'][widget.fertilizerCombination[0]]/widget.area)) )),
                  DataCell(Text( formatter.format(((widget.targetData['amf'][widget.fertilizerCombination[0]]/widget.area)/50))  )),
                  DataCell(Text(  formatter.format((((widget.targetData['amf'][widget.fertilizerCombination[0]]/widget.area)/50)*widget.prices['n'])).toString()))
                ]),
                DataRow(cells: [
                  DataCell(Text(capitalize(widget.fertilizerCombination[1]))),
                  DataCell(Text( formatter.format((widget.targetData['amf'][widget.fertilizerCombination[1]]/widget.area)) )),
                  DataCell(Text( formatter.format(((widget.targetData['amf'][widget.fertilizerCombination[1]]/widget.area)/50)) )),
                  DataCell(Text( formatter.format((((widget.targetData['amf'][widget.fertilizerCombination[1]]/widget.area)/50)*widget.prices['p'])) )),
                ]),
                DataRow(cells: [
                  DataCell(Text(capitalize(widget.fertilizerCombination[2]))),
                  DataCell(Text( formatter.format((widget.targetData['amf'][widget.fertilizerCombination[2]]/widget.area)) )),
                  DataCell(Text( formatter.format(((widget.targetData['amf'][widget.fertilizerCombination[2]]/widget.area)/50)) )),
                  DataCell(Text( formatter.format((((widget.targetData['amf'][widget.fertilizerCombination[2]]/widget.area)/50)*widget.prices['k'])) )),
                ]),
                DataRow(cells: [
                  DataCell(Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text('')),
                  DataCell(Text('')),
                  DataCell(
                      Text(
                          formatter.format(
                              (((widget.targetData['amf'][widget.fertilizerCombination[0]]/widget.area)/50)*widget.prices['n']) +
                                  (((widget.targetData['amf'][widget.fertilizerCombination[1]]/widget.area)/50)*widget.prices['p']) +
                                  (((widget.targetData['amf'][widget.fertilizerCombination[2]]/widget.area)/50)*widget.prices['k'])

                          ), style: TextStyle(fontWeight: FontWeight.bold)
                      )
                  ),
                ]),
              ],
            ),
            SizedBox(height:20),
            Center(
                child: Text(
                  'Amount of Fertilizer',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            Center(
                child: Text(
                  "farmer's area",
                  style: TextStyle(fontSize: 15),
                )),
            DataTable(
              columnSpacing: 25,
              columns: [
                DataColumn(label: Text('')),
                DataColumn(label: Text('kg')),
                DataColumn(label: Text('Bag')),
                DataColumn(label: Text('Cost\n(PHP)',overflow: TextOverflow.ellipsis,)),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text(capitalize((widget.fertilizerCombination[0]=='muriateOfPotash') ? "muriate of potash" : widget.fertilizerCombination[0]))),
                  DataCell(Text( formatter.format(widget.targetData['amf'][widget.fertilizerCombination[0]]) )),
                  DataCell(Text( formatter.format((widget.targetData['amf'][widget.fertilizerCombination[0]]/50)) )),
                  DataCell(Text( formatter.format(((widget.targetData['amf'][widget.fertilizerCombination[0]]/50)*widget.prices['n'])) )),
                ]),
                DataRow(cells: [
                  DataCell(Text(capitalize(widget.fertilizerCombination[1]))),
                  DataCell(Text( formatter.format(widget.targetData['amf'][widget.fertilizerCombination[1]]) )),
                  DataCell(Text( formatter.format((widget.targetData['amf'][widget.fertilizerCombination[1]]/50)) )),
                  DataCell(Text( formatter.format(((widget.targetData['amf'][widget.fertilizerCombination[1]]/50)*widget.prices['p'])) )),
                ]),
                DataRow(cells: [
                  DataCell(Text(capitalize(widget.fertilizerCombination[2]))),
                  DataCell(Text( formatter.format(widget.targetData['amf'][widget.fertilizerCombination[2]]) )),
                  DataCell(Text( formatter.format((widget.targetData['amf'][widget.fertilizerCombination[2]]/50)) )),
                  DataCell(Text( formatter.format(((widget.targetData['amf'][widget.fertilizerCombination[2]]/50)*widget.prices['k'])) )),
                ]),
                DataRow(cells: [
                  DataCell(Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text('')),
                  DataCell(Text('')),
                  DataCell(
                      Text(
                          formatter.format(
                              ((widget.targetData['amf'][widget.fertilizerCombination[0]]/50)*widget.prices['n'])+
                                  ((widget.targetData['amf'][widget.fertilizerCombination[1]]/50)*widget.prices['p'])+
                                  ((widget.targetData['amf'][widget.fertilizerCombination[2]]/50)*widget.prices['k'])
                          ), style: TextStyle(fontWeight: FontWeight.bold)
                      )
                  ),
                ]),
              ],
            ),
            SizedBox(height:20),
            Center(
                child: Text(
                  'Nutrient Cost Analysis',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            DataTable(
              columns: [
                DataColumn(label: Text('nutrient')),
                DataColumn(label: Text('per hectare',overflow: TextOverflow.ellipsis,)),
                DataColumn(label: Text("farmer's area",overflow: TextOverflow.ellipsis,)),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text('N')),
                  DataCell(Text(formatter.format(widget.targetData['cost']['n']/widget.area))),
                  DataCell(Text(formatter.format(widget.targetData['cost']['n']))),
                ]),
                DataRow(cells: [
                  DataCell(Text('P₂O₅')),
                  DataCell(Text(formatter.format(widget.targetData['cost']['p']/widget.area))),
                  DataCell(Text(formatter.format(widget.targetData['cost']['p']))),
                ]),
                DataRow(cells: [
                  DataCell(Text('K₂O')),
                  DataCell(Text(formatter.format(widget.targetData['cost']['k']/widget.area))),
                  DataCell(Text(formatter.format(widget.targetData['cost']['k']))),
                ]),
              ],
            ),
          ]),
        ],
      ),
    );
  }
}
