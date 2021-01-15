import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrient_manager_corn_new/screens/summary_screen.dart';

//Start of constant values

const fTypeRate = {
  "complete": [.14,.14,.14],
  "muriateOfPotash": [0,0,.6],
  "solophos": [0, .18, 0],
  "ammophosphate": [.16,.2,0],
  "urea": [.46, 0, 0],
  "ammosulphate": [.21,0,0]
};

const nutrientRemoval = {
  "albay" : { // nutrient removal values for ALBAY
    "opv" : {
      "n" : 16,
      "p" : 2.8,
      "k" : 4.0
    },
    "hybrid" : {
      "n" : 15.6,
      "p" : 2.9,
      "k" : 3.8
    }
  },

  "bukidnon" : {  // nutrient removal values for BUKIDNON
    "opv" : {
      "n" : 16,
      "p" : 2.8,
      "k" : 4.0
    },
    "hybrid" : {
      "n" : 15.6,
      "p" : 2.9,
      "k" : 3.8
    }
  },

  "cebu" : {  // nutrient removal values for CEBU
    "opv" : {
      "n" : 16,
      "p" : 2.8,
      "k" : 4.0
    },
    "hybrid" : {
      "n" : 15.6,
      "p" : 2.9,
      "k" : 3.8
    }
  },

  "iloilo" : { // nutrient removal values for ILOILO
    "opv" : {
      "n" : 16,
      "p" : 2.8,
      "k" : 4.0
    },
    "hybrid" : {
      "n" : 15.6,
      "p" : 2.9,
      "k" : 3.8
    }
  },

  "isabela" : { // nutrient removal values for ISABELA
    "opv" : {
      "n" : 16,
      "p" : 2.8,
      "k" : 4.0
    },
    "hybrid" : {
      "n" : 15.6,
      "p" : 2.9,
      "k" : 3.8
    }
  },

  "nueva ecija" : { // nutrient removal values for NUEVA ECIJA
    "opv" : {
      "n" : 16,
      "p" : 2.8,
      "k" : 4.0
    },
    "hybrid" : {
      "n" : 15.6,
      "p" : 2.9,
      "k" : 3.8
    }
  },

};


const fertilizerRecovery = {
  "albay" : { // fertilizer recovery values for ALBAY
    "opv" : {
      "n" : 0.5,
      "p" : 0.3,
      "k" : 0.5
    },
    "hybrid" : {
      "n" : 0.5,
      "p" : 0.3,
      "k" : 0.5
    }
  },

  "bukidnon" : {  // fertilizer recovery values for BUKIDNON
    "opv" : {
      "n" : 0.5,
      "p" : 0.3,
      "k" : 0.5
    },
    "hybrid" : {
      "n" : 0.5,
      "p" : 0.3,
      "k" : 0.5
    }
  },

  "cebu" : {  // fertilizer recovery values for CEBU
    "opv" : {
      "n" : 0.5,
      "p" : 0.3,
      "k" : 0.5
    },
    "hybrid" : {
      "n" : 0.5,
      "p" : 0.3,
      "k" : 0.5
    }
  },

  "iloilo" : { // fertilizer recovery values for ILOILO
    "opv" : {
      "n" : 0.5,
      "p" : 0.3,
      "k" : 0.5
    },
    "hybrid" : {
      "n" : 0.5,
      "p" : 0.3,
      "k" : 0.5
    }
  },

  "isabela" : { // fertilizer recovery values for ISABELA
    "opv" : {
      "n" : 0.5,
      "p" : 0.3,
      "k" : 0.5
    },
    "hybrid" : {
      "n" : 0.5,
      "p" : 0.3,
      "k" : 0.5
    }
  },

  "nueva ecija" : { // fertilizer recovery values for NUEVA ECIJA
    "opv" : {
      "n" : 0.5,
      "p" : 0.3,
      "k" : 0.5
    },
    "hybrid" : {
      "n" : 0.5,
      "p" : 0.3,
      "k" : 0.5
    }
  },
};

//End of constant values

class CostProfitScreen extends StatefulWidget {
  final double targetYield, yieldSupply, area;
  final Map<dynamic,dynamic> targetData, prices;
  final String province, variety;
  final List<String> fertilizerCombination;

  CostProfitScreen({Key key,
    @required this.targetYield,
    @required this.targetData,
    @required this.yieldSupply,
    @required this.province,
    @required this.variety,
    @required this.area,
    @required this.fertilizerCombination,
    @required this.prices
  });

  @override
  _CostProfitScreenState createState() => _CostProfitScreenState();
}

class _CostProfitScreenState extends State<CostProfitScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isResultVisible = false;
  final formatter = new NumberFormat("#,###.##");

  TextEditingController _mcController = new TextEditingController();
  TextEditingController _option2Controller = new TextEditingController();
  TextEditingController _option3Controller = new TextEditingController();

  //temporary values for datatable
  Map<String,double> option1 = {
    'targetYield': 0,
    'amf1': 0,
    'amf2': 0,
    'amf3': 0,
    'fertilizerCost': 0,
    'grossProfit':0
  };
  Map<String,double> option2 = {
    'targetYield': 0,
    'amf1': 0,
    'amf2': 0,
    'amf3': 0,
    'fertilizerCost': 0,
    'grossProfit':0
  };
  Map<String,double> option3 = {
    'targetYield': 0,
    'amf1': 0,
    'amf2': 0,
    'amf3': 0,
    'fertilizerCost': 0,
    'grossProfit':0
  };

  String capitalize(word) {
    return "${word[0].toUpperCase()}${word.substring(1)}";
  }

  computeFRRWithArea(newTargetYield) {
    // Computes FRR with area already
    // (((targetYield-yieldSupply)*nutrientRemoval)/fertilizer)*area
    var frr = {
      'n' : (((newTargetYield-widget.yieldSupply)* nutrientRemoval[widget.province][widget.variety]['n'])/fertilizerRecovery[widget.province][widget.variety]['n'])*widget.area,
      'p' : (((newTargetYield-widget.yieldSupply)* nutrientRemoval[widget.province][widget.variety]['p'])/fertilizerRecovery[widget.province][widget.variety]['p'])*widget.area,
      'k' : (((newTargetYield-widget.yieldSupply)* nutrientRemoval[widget.province][widget.variety]['k'])/fertilizerRecovery[widget.province][widget.variety]['k'])*widget.area
    };

    return frr;
  }

  computeAMF(frr){
    var amf = {};


    // computes for AMF for 1st fertilizer type (Either Complete or Muriate of Potash)
    // divides value of FRR for K nutrient to last value of fertilizer type
    // this is because both complete and muriate of potash have last values
    // 14-14-14 and 0-0-60
    amf[widget.fertilizerCombination[0]] = frr['k']/fTypeRate[widget.fertilizerCombination[0]][2];

    //computes for AMF for 2nd fertilizer type (Either Solophos or Ammophosphate)
    //p1 is the checker if the 1st fertilizer type has P
    int p1 = (fTypeRate[widget.fertilizerCombination[0]][1] == 0) ? 0 : 1;
    amf[widget.fertilizerCombination[1]] = (frr['p'] - (frr['k'] * p1)) / fTypeRate[widget.fertilizerCombination[1]][1];

    //computes for AMF for 3rd fertilizer type (Either Urea or Ammosulphate)
    //n1 is the checker if the 1st fertilizer type has N
    int n1 = (fTypeRate[widget.fertilizerCombination[0]][0] == 0) ? 0 : 1;
    amf[widget.fertilizerCombination[2]] = ((frr['n']-(frr['k']*n1)) - (amf[widget.fertilizerCombination[1]]*fTypeRate[widget.fertilizerCombination[1]][0]))/fTypeRate[widget.fertilizerCombination[2]][0] ;

    return amf;
  }

  computeFertilizerCost(amf){
    var cost1 = (amf[widget.fertilizerCombination[0]]/50)*widget.prices['n'];
    var cost2 = (amf[widget.fertilizerCombination[1]]/50)*widget.prices['p'];
    var cost3 = (amf[widget.fertilizerCombination[2]]/50)*widget.prices['k'];

    return cost1+cost2+cost3;
  }

  void showResults() {
    setState(() {
      _isResultVisible = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cost Profit Analysis'),
        centerTitle: true,
      ),
      body:
      ListView(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Card(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child:Form(
                    key: _formKey,
                    child: Column(
                      children: [
//                  Align(
//                      alignment: Alignment.centerLeft,
//                      child: Text('STEP 7 - Cost Profit Analysis', style: TextStyle(fontWeight: FontWeight.bold))
//                  ),
//                  SizedBox(height:20),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text('How much is your farmgate price of corn', style: TextStyle(fontSize: 15))
                        ),
                        SizedBox(height:10),
                        Row(
                          children: [
                            Container(
                              child: Text('per kilogram at ', style: TextStyle(fontSize: 15)),
                            ),
                            Container(
                              width:40,
                              height:60,
                              child: TextFormField(
                                validator: (val) => val.isEmpty ? '' : null,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  helperText: ' ',
                                  contentPadding: EdgeInsets.symmetric(horizontal:10,vertical:0),
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(' % MC? ', style: TextStyle(fontSize:15)),
                            ),
                            Container(
                              width:40,
                              height:60,
                              child: TextFormField(
                                validator: (val) => val.isEmpty ? '' : null,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  helperText: ' ',
                                  contentPadding: EdgeInsets.symmetric(horizontal:10),
                                  border: const OutlineInputBorder(),
                                ),
                                controller: _mcController,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height:10),
                        Divider(),
                        SizedBox(height:10),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Enter values of target yield to compare to', style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15))
                        ),
                        SizedBox(height:10),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text('1. Target Yield: ${widget.targetYield}', style: TextStyle(fontSize: 15))
                        ),
                        SizedBox(height:10),
                        Row(
                          children: [
                            Container(
                              child: Text('2. Target Yield: ', style: TextStyle(fontSize: 15)),
                            ),
                            Container(
                              width:40,
                              height:60,
                              child: TextFormField(
                                validator: (val) => val.isEmpty ? '' : null,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  helperText: ' ',
                                  contentPadding: EdgeInsets.symmetric(horizontal:10),
                                  border: const OutlineInputBorder(),
                                ),
                                controller: _option2Controller,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height:10),
                        Row(
                          children: [
                            Container(
                              child: Text('3. Target Yield: ', style: TextStyle(fontSize: 15)),
                            ),
                            Container(
                              width:40,
                              height:60,
                              child: TextFormField(
                                validator: (val) => val.isEmpty ? '' : null,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  helperText: ' ',
                                  contentPadding: EdgeInsets.symmetric(horizontal:10),
                                  border: const OutlineInputBorder(),
                                ),
                                controller: _option3Controller,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height:10),
                        SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              //side: BorderSide(color: Colors.lightGreen[700])
                            ),
                            onPressed: () {
                              if(_formKey.currentState.validate()){
                                //computation of FRR for option 2 and 3
                                var frr2 = computeFRRWithArea(double.parse(_option2Controller.text));
                                var frr3 = computeFRRWithArea(double.parse(_option3Controller.text));

                                //computation of AMF
                                var amf1 = widget.targetData['amf'];
                                var amf2 = computeAMF(frr2);
                                var amf3 = computeAMF(frr3);

                                //get fertilizer cost and gross proft
                                var total1 = computeFertilizerCost(amf1);
                                var total2 = computeFertilizerCost(amf2);
                                var total3 = computeFertilizerCost(amf3);
                                var grossprofit1 = widget.targetYield*1000*double.parse(_mcController.text);
                                var grossprofit2 = double.parse(_option2Controller.text)*1000*double.parse(_mcController.text);
                                var grossprofit3 = double.parse(_option3Controller.text)*1000*double.parse(_mcController.text);


                                option1['targetYield'] = widget.targetYield;
                                option1['amf1'] = amf1[widget.fertilizerCombination[0]];
                                option1['amf2'] = amf1[widget.fertilizerCombination[1]];
                                option1['amf3'] = amf1[widget.fertilizerCombination[2]];
                                option1['fertilizerCost'] = total1;
                                option1['grossProfit'] = grossprofit1;

                                option2['targetYield'] = double.parse(_option2Controller.text);
                                option2['amf1'] = amf2[widget.fertilizerCombination[0]];
                                option2['amf2'] = amf2[widget.fertilizerCombination[1]];
                                option2['amf3'] = amf2[widget.fertilizerCombination[2]];
                                option2['fertilizerCost'] = total2;
                                option2['grossProfit'] = grossprofit2;

                                option3['targetYield'] = double.parse(_option3Controller.text);
                                option3['amf1'] = amf3[widget.fertilizerCombination[0]];
                                option3['amf2'] = amf3[widget.fertilizerCombination[1]];
                                option3['amf3'] = amf3[widget.fertilizerCombination[2]];
                                option3['fertilizerCost'] = total3;
                                option3['grossProfit'] = grossprofit3;
                                showResults();
                              }
                            },
                            padding: const EdgeInsets.symmetric(vertical:15.0),
                            child: Text('COMPARE',style:TextStyle(fontSize:15)),
                          ),
                        ),
                      ],
                    ),
                  ),

                ),
              ),
            ),
          ),
          Visibility(
            visible: _isResultVisible,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal:50,vertical:10),
                child: Text('Instructions: Compare the values below and select a target yield to use for the summary table', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color:Colors.grey[600]))
            ),
          ),
          Visibility(
            visible: _isResultVisible,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal:10),
                child: Card(
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top:20,left:20,right:20),
                          child: Text('Amount of Fertilizer', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                      ),
                      DataTable(
                        columnSpacing: 25,
                        columns: [
                          DataColumn(label: Text('Target\nyield')),
                          DataColumn(label: Text('${capitalize(widget.fertilizerCombination[0])}')),
                          DataColumn(label: Text('${capitalize(widget.fertilizerCombination[1])}')),
                          DataColumn(label: Text('${capitalize(widget.fertilizerCombination[2])}')),
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(Text("${option1['targetYield']}")),
                            DataCell(Text('${formatter.format(option1['amf1'])}')),
                            DataCell(Text('${formatter.format(option1['amf2'])}')),
                            DataCell(Text('${formatter.format(option1['amf3'])}')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text("${option2['targetYield']}")),
                            DataCell(Text('${formatter.format(option2['amf1'])}')),
                            DataCell(Text('${formatter.format(option2['amf2'])}')),
                            DataCell(Text('${formatter.format(option2['amf3'])}')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text("${option3['targetYield']}")),
                            DataCell(Text('${formatter.format(option3['amf1'])}')),
                            DataCell(Text('${formatter.format(option3['amf2'])}')),
                            DataCell(Text('${formatter.format(option3['amf3'])}')),
                          ])
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(top:20,left:20,right:20),
                          child: Text('Costs (PHP/ha)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                      ),
                      DataTable(
                        columns: [
                          DataColumn(label: Text('Target\nyield')),
                          DataColumn(label: Text('Fertilizer\nCost')),
                          DataColumn(label: Text('Gross\nProfit')),
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(Text("${option1['targetYield']}")),
                            DataCell(Text('${formatter.format(option1['fertilizerCost'])}')),
                            DataCell(Text('${formatter.format(option1['grossProfit'])}')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text("${option2['targetYield']}")),
                            DataCell(Text('${formatter.format(option2['fertilizerCost'])}')),
                            DataCell(Text('${formatter.format(option2['grossProfit'])}')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text("${option3['targetYield']}")),
                            DataCell(Text('${formatter.format(option3['fertilizerCost'])}')),
                            DataCell(Text('${formatter.format(option3['grossProfit'])}')),
                          ]),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(top:20,left:20,right:20),
                          child: Text('Choose target yield to use', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  //side: BorderSide(color: Colors.lightGreen[700])
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        SummaryScreen(fertilizerCost: option1['fertilizerCost'], grossProfit: option1['grossProfit'],)
                                    ),
                                  );
                                },
                                padding: const EdgeInsets.symmetric(vertical:10.0),
                                child: Text('${option1['targetYield']}',style:TextStyle(fontSize:15)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  //side: BorderSide(color: Colors.lightGreen[700])
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        SummaryScreen(fertilizerCost: option2['fertilizerCost'], grossProfit: option2['grossProfit'],)
                                    ),
                                  );
                                },
                                padding: const EdgeInsets.symmetric(vertical:10.0),
                                child: Text('${option2['targetYield']}',style:TextStyle(fontSize:15)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  //side: BorderSide(color: Colors.lightGreen[700])
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        SummaryScreen(fertilizerCost: option3['fertilizerCost'], grossProfit: option3['grossProfit'],)
                                    ),
                                  );
                                },
                                padding: const EdgeInsets.symmetric(vertical:10.0),
                                child: Text('${option3['targetYield']}',style:TextStyle(fontSize:15)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
            ),
          )
        ],
      )
    );
  }
}
