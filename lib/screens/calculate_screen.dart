import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:nutrient_manager_corn_new/screens/ssnm_rates_screen.dart';


//Start of constant values
const prices={
  "complete": 1211.83544303797,
  "urea": 1230.57471264368,
  "ammosulphate": 886.578947368421,
  "ammophosphate": 1009.09090909091,
  "muriateOfPotash": 1262.5,
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


  //Gets yield of indigenous supply from google sheets
  //In future changes, try to add municipality and brgy if needed
  Future<double> getYieldOfIndigenousSupply() async {
    double yieldSupply;

    final ProgressDialog pr = ProgressDialog(context, isDismissible: false);

    pr.style(
        message: 'Processing values'
    );

    await pr.show(); //displays 'processing values' pop-up

    var place_index = {
      'albay' : 9,
      'bukidnon' : 16,
      'cebu' : 23,
      'iloilo' : 30,
      'isabela' : 37,
      'nueva ecija' : 44,
    };

    var growingSeasonIndex = (widget.growingSeason == "dry") ? 0 : 2;

    var response =
      await http.get('https://spreadsheets.google.com/feeds/cells/17gN4VZB7jIh5MX9uXISDS9IIl_vvRZr2WfB6r9iulEM/od6/public/basic?alt=json');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var gsheets = json.decode(response.body);
      //get yield of indigenous supply in this line of code
      yieldSupply = double.parse(gsheets['feed']['entry'][place_index[widget.province] + growingSeasonIndex]['content']['\$t']);

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load indigenous supply');
    }

    await pr.hide(); //hides 'processing values' pop-up

    return yieldSupply;
  }

  //computes the FRR (with declared farmer's area)
  computeFRRWithArea(yieldSupply) {
    // Computes FRR with area already
    // (((targetYield-yieldSupply)*nutrientRemoval)/fertilizer)*area
    var frr = {
      'n' : (((widget.targetYield-yieldSupply)* nutrientRemoval[widget.province][widget.variety]['n'])/fertilizerRecovery[widget.province][widget.variety]['n'])*widget.area,
      'p' : (((widget.targetYield-yieldSupply)* nutrientRemoval[widget.province][widget.variety]['p'])/fertilizerRecovery[widget.province][widget.variety]['p'])*widget.area,
      'k' : (((widget.targetYield-yieldSupply)* nutrientRemoval[widget.province][widget.variety]['k'])/fertilizerRecovery[widget.province][widget.variety]['k'])*widget.area
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

  computeYieldCurveEquation(yieldSupply,frrNutrient,chosen,nutrientIndex,price) async {

    //compute for a, b, c;
      double a = (widget.targetYield-yieldSupply)/pow(frrNutrient,2);
      double b = (widget.targetYield+(pow(frrNutrient,2)*a)-yieldSupply)/frrNutrient;
      double c = yieldSupply;

      var y,z,economicalData,econ_diff,largest_diff,econ_cost,econ_frr;
      for(var x = 1; x<=397; x++){
        y = -(a)*pow(x,2)+b*x+c;
        z = x*(price/(fTypeRate[chosen][nutrientIndex]*50));
        economicalData = ((widget.targetYield-yieldSupply)/(frrNutrient-0)) * x + yieldSupply;
        econ_diff = y-economicalData;

        if(x==1){
          largest_diff = econ_diff;
          econ_cost = z;
          econ_frr = x;
        }
        if(largest_diff < econ_diff){
          largest_diff = econ_diff;
          econ_cost = z;
          econ_frr = x;
        }
      }

      return [econ_cost,econ_frr];
  }

  getEconomicCost(yieldSupply,frr,chosenN,chosenP,chosenK,prices) async {
    var econN = await computeYieldCurveEquation(yieldSupply, frr['n'], chosenN,0, prices['n']);
    var econP = await computeYieldCurveEquation(yieldSupply, frr['p'], chosenP,1, prices['p']);
    var econK = await computeYieldCurveEquation(yieldSupply, frr['k'], chosenK,2, prices['k']);

    var econ_cost = {
      'n' : econN[0],
      'p' : econP[0],
      'k' : econK[0],
    };

    var econ_frr = {
      'n' : econN[1],
      'p' : econP[1],
      'k' : econK[1],
    };

    return [econ_frr,econ_cost];
  }

  getTargetCost(frr,chosenN,chosenP,chosenK, prices) async {

    var costN = frr['n'].round()*(prices['n']/(fTypeRate[chosenN][0]*50));
    var costP = frr['p'].round()*(prices['p']/(fTypeRate[chosenP][1]*50));
    var costK = frr['k'].round()*(prices['k']/(fTypeRate[chosenK][2]*50));

    return {'n': costN, 'p': costP, 'k': costK};
  }

  getCost(chosen) async{
    var price; //depends on the chosen variable
    if(chosen == "complete"){
      price = await cost1;
    }else if(chosen == "urea"){
      price = await cost2;
    }else if(chosen == "ammosulphate"){
      price = await cost3;
    }else if(chosen == "ammophosphate"){
      price = await cost4;
    }else if(chosen == "muriateOfPotash"){
      price = await cost5;
    }else if(chosen == "solophos"){
      price = await cost6;
    }
    return price;
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
                                      items: getChoices(0) //get choices for N
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
                                      items: getChoices(1) //get choices for P
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
                                      items: getChoices(2) //get choices for K
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
                    ),
                    onPressed: () async {
                      if(_formKey.currentState.validate()){

                        //Get yield of indigenous supply
                        //no parameters because province is already accessible inside the function.
                        var yieldSupply = await getYieldOfIndigenousSupply();

                        //Calculate the FRR w/ declared farmer's area
                        //sample format frr = {'n':999, 'p':999, 'k':999}
                        var targetFRR = computeFRRWithArea(yieldSupply);

                        //Calculate Amount of Fertilizer(AMF) per KG (wala pa yung per bag dito) for farmer's area
                        //sample format amf = {'complete':999, 'solophos':999, 'urea':999}
                        var targetAMF = computeAMF(targetFRR);

                        var prices = {
                          'n': await getCost(chosenN),
                          'p': await getCost(chosenP),
                          'k': await getCost(chosenK)
                        };

                        //Get target nutrient cost analysis
                        //sample format cost = {'n':123, 'p':123, 'k':123}
                        var targetCost = await getTargetCost(targetFRR,chosenN,chosenP,chosenK,prices);

                        //compiled data for easier transfer in parameters
                        var targetData = {
                          'frr':targetFRR,
                          'amf': targetAMF,
                          'cost': targetCost
                        };

                        //Get economic yield FRR and nutrient cost analysis
                        var econFRRandCost = await getEconomicCost(yieldSupply,targetFRR,chosenN,chosenP,chosenK,prices);
                        var econFRR = econFRRandCost[0];
                        var econCost = econFRRandCost[1];
                        //Get AMF for economic yield
                        var econAMF = computeAMF(econFRR);

                        var econData = {
                          'frr':econFRR,
                          'amf': econAMF,
                          'cost': econCost
                        };
                        print(econData);
                        print(targetData);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SSNMRatesScreen(targetData:targetData,econData:econData,area:widget.area,fertilizerCombination:widget.fertilizerCombination,prices:prices)),
                      );
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
