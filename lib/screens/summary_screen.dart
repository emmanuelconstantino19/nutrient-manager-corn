import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryScreen extends StatefulWidget {
  final double fertilizerCost, grossProfit;

  SummaryScreen({Key key,
    @required this.fertilizerCost,
    @required this.grossProfit
  });

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final formatter = new NumberFormat("#,###.##");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summary'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: DataTable(
            columnSpacing: 15,
            columns: [
              DataColumn(label: Text('Item')),
              DataColumn(label: Text('Unit\nCost\n(PHP)')),
              DataColumn(label: Text('# of\nitems')),
              DataColumn(label: Text('Cost\n(PHP/ha)')),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text("Seeds")),
                DataCell(Text('3,200.00')),
                DataCell(Text('2')),
                DataCell(Text('6,400.00')),
              ]),
              DataRow(cells: [
                DataCell(Text("Fertilizer")),
                DataCell(Text('-')),
                DataCell(Text('-')),
                DataCell(Text('${formatter.format(widget.fertilizerCost)}')),
              ]),
              DataRow(cells: [
                DataCell(Text("Hired Labor (PHP/manday)")),
                DataCell(Text('400.00')),
                DataCell(Text('-')),
                DataCell(Text('-')),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text("Planting"),)),
                DataCell(Text('-')),
                DataCell(Text('15')),
                DataCell(Text('6,000.00')),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text("Weeding"),)),
                DataCell(Text('-')),
                DataCell(Text('0')),
                DataCell(Text('0.00')),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text("Harvesting"),)),
                DataCell(Text('-')),
                DataCell(Text('10')),
                DataCell(Text('4000.00')),
              ]),
              DataRow(cells: [
                DataCell(Text("Insecticide")),
                DataCell(Text('500.00')),
                DataCell(Text('3')),
                DataCell(Text('1,500.00')),
              ]),
              DataRow(cells: [
                DataCell(Text("Herbicide")),
                DataCell(Text('500.00')),
                DataCell(Text('3')),
                DataCell(Text('1,500.00')),
              ]),
              DataRow(cells: [
                DataCell(Text("Others")),
                DataCell(Text('-')),
                DataCell(Text('-')),
                DataCell(Text('10,000.00')),
              ]),
              DataRow(cells: [
                DataCell(Text("Total Cost(PHP/ha)", style: TextStyle(fontWeight: FontWeight.bold),)),
                DataCell(Text('')),
                DataCell(Text('')),
                DataCell(Text('${formatter.format(6400+6000+4000+1500+1500+10000+widget.fertilizerCost)}')),
              ]),
              DataRow(cells: [
                DataCell(Text("Gross Profit(PHP/ha)", style: TextStyle(fontWeight: FontWeight.bold),)),
                DataCell(Text('')),
                DataCell(Text('')),
                DataCell(Text('${formatter.format(widget.grossProfit)}')),
              ]),
              DataRow(cells: [
                DataCell(Text("Total Revenue (PHP/ha)", style: TextStyle(fontWeight: FontWeight.bold),)),
                DataCell(Text('')),
                DataCell(Text('')),
                DataCell(Text('${formatter.format(widget.grossProfit-(6400+6000+4000+1500+1500+10000+widget.fertilizerCost))}')),
              ]),
              DataRow(cells: [
                DataCell(Text("Net Return", style: TextStyle(fontWeight: FontWeight.bold),)),
                DataCell(Text('')),
                DataCell(Text('')),
                DataCell(Text('${formatter.format(widget.grossProfit/(6400+6000+4000+1500+1500+10000+widget.fertilizerCost))}')),
              ]),
            ],
          ),
        ),
      )
    );
  }
}
