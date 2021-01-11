import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

const prices={
  "complete": 1211.84,
  "urea": 1230.57,
  "ammosulphate": 886.58,
  "ammophosphate": 1009.09,
  "muriateOfPotash": 1262.50,
  "solophos": 980.00,
};

const fTypeRate = {
  "complete": [.14,.14,.14],
  "muriateOfPotash": [0,0,.6],
  "solophos": [0, .18, 0],
  "ammophosphate": [.16,.2,0],
  "urea": [.46, 0, 0],
  "ammosulphate": [.21,0,0]
};

class CalculateScreen extends StatefulWidget {
  final String province, municipality, brgy, growingSeason, variety;
  final double area, targetYield;
  final List<String> fertilizerCombination;

  CalculateScreen({Key key,
    @required this.province,
    @required this.municipality,
    @required this.brgy,
    @required this.growingSeason,
    @required this.area,
    @required this.variety,
    @required this.targetYield,
    @required this.fertilizerCombination,
  }) : super(key: key);

  @override
  _CalculateScreenState createState() => _CalculateScreenState();
}

class _CalculateScreenState extends State<CalculateScreen> {

  final _formKey = GlobalKey<FormState>();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<double> cost1, cost2, cost3, cost4, cost5, cost6;

  TextEditingController _cost1Controller = new TextEditingController();
  TextEditingController _cost2Controller = new TextEditingController();
  TextEditingController _cost3Controller = new TextEditingController();
  TextEditingController _cost4Controller = new TextEditingController();
  TextEditingController _cost5Controller = new TextEditingController();
  TextEditingController _cost6Controller = new TextEditingController();

  final formatter = new NumberFormat("#,###.##");

  String chosenN, chosenP, chosenK;

  @override
  void initState() {
    super.initState();
    cost1 = _prefs.then((SharedPreferences prefs) {
      return (prefs.getDouble('complete') ?? prices['complete']);
    });

    cost2 = _prefs.then((SharedPreferences prefs) {
      return (prefs.getDouble('urea') ?? prices['urea']);
    });

    cost3 = _prefs.then((SharedPreferences prefs) {
      return (prefs.getDouble('ammosulphate') ?? prices['ammosulphate']);
    });

    cost4 = _prefs.then((SharedPreferences prefs) {
      return (prefs.getDouble('ammophosphate') ?? prices['ammophosphate']);
    });

    cost5 = _prefs.then((SharedPreferences prefs) {
      return (prefs.getDouble('muriateOfPotash') ?? prices['muriateOfPotash']);
    });

    cost6 = _prefs.then((SharedPreferences prefs) {
      return (prefs.getDouble('solophos') ?? prices['solophos']);
    });
  }

  //Changes value of fertilizer cost
  //Parameter 1: array of costs
  Future<void> _changeCost(cost) async {

    final SharedPreferences prefs = await _prefs;

    setState(() {
      cost1 = prefs.setDouble("complete", cost[0]).then((bool success) {
        return cost[0];
      });

      cost2 = prefs.setDouble("urea", cost[1]).then((bool success) {
        return cost[1];
      });

      cost3 = prefs.setDouble("ammosulphate", cost[2]).then((bool success) {
        return cost[2];
      });

      cost4 = prefs.setDouble("ammophosphate", cost[3]).then((bool success) {
        return cost[3];
      });

      cost5 = prefs.setDouble("muriateOfPotash", cost[4]).then((bool success) {
        return cost[4];
      });

      cost6 = prefs.setDouble("solophos", cost[5]).then((bool success) {
        return cost[5];
      });
    });
  }

  List<String> getChoices(nutrient){
    List<String> choices=[];
    for(var i=0 ; i<=2; i++){
      if(fTypeRate[widget.fertilizerCombination[i]][nutrient] != 0)
        choices.add(widget.fertilizerCombination[i]);
    }
    return choices;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Fertilizer Cost'),
          centerTitle: true,
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    buildEditCostsDialog(context);
                  },
                  child: Icon(
                    Icons.edit,
                    size: 26.0,
                  ),
                )
            ),
          ],
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DataTable(
                          columnSpacing: 25,
                          columns: [
                            DataColumn(label: Text('Fertilizer Material')),
                            DataColumn(label: Expanded(child:Text('Cost per bag(PHP)'))),
                          ],
                          rows: [
                            DataRow(cells: [
                              DataCell(Text('Complete (14-14-14)')),
                              DataCell(
                                  FutureBuilder(
                                      future: cost1,
                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        _cost1Controller.text = snapshot.data.toString();
                                        return Text(formatter.format(snapshot.data));
                                      }
                                  )
                              ),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('Urea (46-0-0)')),
                              DataCell(FutureBuilder(
                                  future: cost2,
                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    _cost2Controller.text = snapshot.data.toString();
                                    return Text(formatter.format(snapshot.data));
                                  }
                              )),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('Ammosulphate (21-0-0)')),
                              DataCell(FutureBuilder(
                                  future: cost3,
                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    _cost3Controller.text = snapshot.data.toString();
                                    return Text(formatter.format(snapshot.data));
                                  }
                              )),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('Ammophosphate (16-20-0)')),
                              DataCell(FutureBuilder(
                                  future: cost4,
                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    _cost4Controller.text = snapshot.data.toString();
                                    return Text(formatter.format(snapshot.data));
                                  }
                              )),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('Muriate of potash (0-0-60)')),
                              DataCell(FutureBuilder(
                                  future: cost5,
                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    _cost5Controller.text = snapshot.data.toString();
                                    return Text(formatter.format(snapshot.data));
                                  }
                              )),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('Solophos (0-18-0)')),
                              DataCell(FutureBuilder(
                                  future: cost6,
                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    _cost6Controller.text = snapshot.data.toString();
                                    return Text(formatter.format(snapshot.data));
                                  }
                              )),
                            ]),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Card(
                            child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('STEP 6 - Choose fertilizer type for N, P, K', style: TextStyle(fontWeight: FontWeight.bold))
                                    ),
                                    DropdownButtonFormField<String>(
                                      validator: (value) => value == null ? 'field required' : null,
                                      isExpanded: true,
                                      value: chosenN,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(color: Colors.black, fontSize:15),
                                      hint: Text('For N'),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          chosenN = newValue;
                                        });
                                      },
                                      items: getChoices(0)
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                    DropdownButtonFormField<String>(
                                      validator: (value) => value == null ? 'field required' : null,
                                      isExpanded: true,
                                      value: chosenP,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(color: Colors.black, fontSize:15),
                                      hint: Text('For P'),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          chosenP = newValue;
                                        });
                                      },
                                      items: getChoices(1)
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                    DropdownButtonFormField<String>(
                                      validator: (value) => value == null ? 'field required' : null,
                                      isExpanded: true,
                                      value: chosenK,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(color: Colors.black, fontSize:15),
                                      hint: Text('For K'),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          chosenK = newValue;
                                        });
                                      },
                                      items: getChoices(2)
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      //side: BorderSide(color: Colors.lightGreen[700])
                    ),
                    onPressed: () async {
                      if(_formKey.currentState.validate()){
                        //temporarily commented out
//                      var nCost = await computeElement(chosenN,'n',0);
//                      var pCost = await computeElement(chosenP,'p',1);
//                      var kCost = await computeElement(chosenK,'k',2);

//                      var AMF_econ = computeAMFEcon(nCost[2],pCost[2],kCost[2]);

//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(builder: (context) => resultsPage(nCost:nCost, pCost:pCost, kCost:kCost, AMF: widget.AMF, AMF_econ: AMF_econ, caseCH: widget.caseCH, frr_target: widget.frr_target, frr_econ: [nCost[2],pCost[2],kCost[2]], area:widget.area)),
//                      );

                        //This code is commented out
//                    FocusScopeNode currentFocus = FocusScope.of(context);
//                    if (!currentFocus.hasPrimaryFocus) {
//                      currentFocus.unfocus();
//                    }
                      }
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical:15.0),
                    child: Text('Calculate',style:TextStyle(fontSize:15)),
                  ),
                ),
              ),

            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  buildEditCostsDialog(BuildContext context){
    return showDialog<String>(
      context: context,
      barrierDismissible: true, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return AlertDialog(
                title: Text('Fertilizer Cost'),
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(8.0)),
                content: Container(
                    child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              validator: (val) => val.isEmpty ? 'field required' : null,
                              keyboardType: TextInputType.number,
                              //autofocus: true,
                              decoration: new InputDecoration(
                                  labelText: 'Complete'),
                              controller: _cost1Controller,
                            ),
                            TextFormField(
                              validator: (val) => val.isEmpty ? 'field required' : null,
                              keyboardType: TextInputType.number,
                              //autofocus: true,
                              decoration: new InputDecoration(
                                  labelText: 'Urea'),
                              controller: _cost2Controller,
                            ),
                            TextFormField(
                              validator: (val) => val.isEmpty ? 'field required' : null,
                              keyboardType: TextInputType.number,
                              //autofocus: true,
                              decoration: new InputDecoration(
                                  labelText: 'Ammosulphate'),
                              controller: _cost3Controller,
                            ),
                            TextFormField(
                              validator: (val) => val.isEmpty ? 'field required' : null,
                              keyboardType: TextInputType.number,
                              //autofocus: true,
                              decoration: new InputDecoration(
                                  labelText: 'Ammophosphate'),
                              controller: _cost4Controller,
                            ),
                            TextFormField(
                              validator: (val) => val.isEmpty ? 'field required' : null,
                              keyboardType: TextInputType.number,
                              //autofocus: true,
                              decoration: new InputDecoration(
                                  labelText: 'Muriate of potash'),
                              controller: _cost5Controller,
                            ),
                            TextFormField(
                              validator: (val) => val.isEmpty ? 'field required' : null,
                              keyboardType: TextInputType.number,
                              //autofocus: true,
                              decoration: new InputDecoration(
                                  labelText: 'Solophos'),
                              controller: _cost6Controller,
                            ),
                          ],
                        )
                    )
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Reset Default',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () {
                      _changeCost([
                        prices['complete'],
                        prices['urea'],
                        prices['ammosulphate'],
                        prices['ammophosphate'],
                        prices['muriateOfPotash'],
                        prices['solophos']
                      ]);
                      Navigator.of(context).pop();
                    },
                  ),
                  RaisedButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.lightGreen[700]),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text('Cancel',
                        style: TextStyle(color:Colors.green)
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text('Save',
                    ),
                    onPressed: () {
                      _changeCost([double.parse(_cost1Controller.text),
                        double.parse(_cost2Controller.text),
                        double.parse(_cost3Controller.text),
                        double.parse(_cost4Controller.text),
                        double.parse(_cost5Controller.text),
                        double.parse(_cost6Controller.text)]
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }
        );
      },
    );
  }
}
