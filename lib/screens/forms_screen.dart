import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nutrient_manager_corn_new/screens/calculate_screen.dart';

class FormsScreen extends StatefulWidget {
  @override
  _FormsScreenState createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  final _formKey = GlobalKey<FormState>();
  String province, variety, municipality, brgy, growingSeason, fertilizerCombination = 'complete,solophos,urea';
  List<String> municipalities = [], brgys = [];

  TextEditingController _areaController = new TextEditingController();
  TextEditingController _tyController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset('assets/corn.png', fit: BoxFit.contain, height: 32),
              Expanded(child: Container(),),
              Image.asset(
                'assets/sarai.png',
                fit: BoxFit.contain,
                height: 32,
              ),
              Expanded(child: Container(),),
              Image.asset(
                'assets/dost-pcaarrd-uplb.png',
                fit: BoxFit.contain,
                height: 32,
              ),

            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
//          decoration: BoxDecoration(
//              gradient: LinearGradient(
//                  colors: [Colors.green, Colors.blue],
//                  begin: Alignment.topLeft,
//                  end: Alignment.bottomLeft)
//          ),
          color:Colors.grey[100],
          child: Column(
            children: [
              Expanded(
                child: Card(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('STEP 1 - Select your location', style: TextStyle(fontWeight: FontWeight.bold))
                                ),
                                DropdownButtonFormField<String>(
                                  validator: (value) => value == null ? 'field required' : null,
                                  isExpanded: true,
                                  value: province,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(color: Colors.black, fontSize:15),
                                  hint: Text('Province'),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      if(province != newValue){
                                        province = newValue;

                                        //remove value from selected municipality
                                        municipality = null;

                                        //clear barangays and remove value from selected barangay
                                        brgy = null;
                                        brgys.clear();

                                        if(province == "Albay"){
                                          municipalities = ['Ligao City'];
                                        }else if(province == "Bukidnon"){
                                          municipalities = ['Maramag'];
                                        }else if(province == "Cebu"){
                                          municipalities = ['Barili'];
                                        }else if(province == "Iloilo"){
                                          municipalities = ['Lambunao'];
                                        }else if(province == "Isabela"){
                                          municipalities = ['Echague'];
                                        }else if(province == "Nueva Ecija"){
                                          municipalities = ['Lupao'];
                                        }
                                      }
                                    });
                                  },
                                  items: <String>[
                                    'Albay',
                                    'Bukidnon',
                                    'Cebu',
                                    'Iloilo',
                                    'Isabela',
                                    'Nueva Ecija'
                                  ]
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
                                  value: municipality,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(color: Colors.black, fontSize:15),
                                  hint: Text('Municipality'),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      if(municipality != newValue){
                                        municipality = newValue;
                                        brgy = null;
                                        if(municipality == "Ligao City"){
                                          brgys = ['Tuburan'];
                                        }else if(municipality == "Maramag"){
                                          brgys = ['Dologon'];
                                        }else if(municipality == "Barili"){
                                          brgys = ['Bagakay'];
                                        }else if(municipality == "Lambunao"){
                                          brgys = ['Agsirab'];
                                        }else if(municipality == "Echague"){
                                          brgys = ['Pag-asa'];
                                        }else if(municipality == "Lupao"){
                                          brgys = ['Parista'];
                                        }
                                      }
                                    });
                                  },
                                  items: municipalities
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
                                  value: brgy,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(color: Colors.black, fontSize:15),
                                  hint: Text('Barangay'),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      brgy = newValue;
                                    });
                                  },
                                  items: brgys
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height:40),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('STEP 2 - Select growing season', style: TextStyle(fontWeight: FontWeight.bold))
                                ),
                                DropdownButtonFormField<String>(
                                  validator: (value) => value == null ? 'field required' : null,
                                  isExpanded: true,
                                  value: growingSeason,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(color: Colors.black, fontSize:15),
                                  hint: Text('Growing Season'),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      growingSeason = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'Dry',
                                    'Wet',
                                  ]
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: 40),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('STEP 3 - Input area and corn type', style: TextStyle(fontWeight: FontWeight.bold))
                                ),
                                TextFormField(
                                  validator: (val) => val.isEmpty ? 'field required' : null,
                                  keyboardType: TextInputType.number,
                                  //autofocus: true,
                                  decoration: new InputDecoration(
                                      labelText: 'Area (ha)'),
                                  controller: _areaController,
                                ),
                                DropdownButtonFormField<String>(
                                  validator: (value) => value == null ? 'field required' : null,
                                  isExpanded: true,
                                  value: variety,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(color: Colors.black, fontSize:15),
                                  hint: Text('Corn Variety Type'),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      variety = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'OPV',
                                    'Hybrid'
                                  ]
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: 40),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('STEP 4 - Input target yield', style: TextStyle(fontWeight: FontWeight.bold))
                                ),
                                TextFormField(
                                  validator: (val) {
                                    if(val.isEmpty) {
                                      return 'field requried';
                                    }
                                    if(double.parse(val) < 1 || double.parse(val) > 20) {
                                      return 'Please only enter values from 1-20';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  //autofocus: true,
                                  decoration: new InputDecoration(
                                      labelText: 'Target Yield (t/ha)'),
                                  controller: _tyController,
                                ),
                                SizedBox(height:40),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('STEP 5 - Select fertilizer combination', style: TextStyle(fontWeight: FontWeight.bold))
                                ),
                                SizedBox(height:10),
                                ListTile(
                                  title: const Text('Complete (14-14-14)\nSolophos (0-18-0)\nUrea (46-0-0)'),
                                  leading: Radio(
                                    value: 'complete,solophos,urea',
                                    groupValue: fertilizerCombination,
                                    onChanged: (String value) {
                                      setState(() {
                                        fertilizerCombination = value;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(height:10),
                                ListTile(
                                  title: const Text('Complete (14-14-14)\nAmmophosphate (16-20-0)\nUrea (46-0-0)'),
                                  leading: Radio(
                                    value: 'complete,ammophosphate,urea',
                                    groupValue: fertilizerCombination,
                                    onChanged: (String value) {
                                      setState(() {
                                        fertilizerCombination = value;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(height:10),
                                ListTile(
                                  title: const Text('Muriate of potash (0-0-60)\nSolophos (0-18-0)\nAmmosulphate (21-0-0)'),
                                  leading: Radio(
                                    value: 'muriateOfPotash,solophos,ammosulphate',
                                    groupValue: fertilizerCombination,
                                    onChanged: (String value) {
                                      setState(() {
                                        fertilizerCombination = value;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(height:10),
                                ListTile(
                                  title: const Text('Complete (14-14-14)\nSolophos (0-18-0)\nAmmosulphate (21-0-0)'),
                                  leading: Radio(
                                    value: 'complete,solophos,ammosulphate',
                                    groupValue: fertilizerCombination,
                                    onChanged: (String value) {
                                      setState(() {
                                        fertilizerCombination = value;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(height:10),
                                ListTile(
                                  title: const Text('Complete (14-14-14)\nAmmophosphate (16-20-0)\nAmmosulphate (21-0-0)'),
                                  leading: Radio(
                                    value: 'complete,ammophosphate,ammosulphate',
                                    groupValue: fertilizerCombination,
                                    onChanged: (String value) {
                                      setState(() {
                                        fertilizerCombination = value;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(height:10),
                                ListTile(
                                  title: const Text('Muriate of Potash (0-0-60)\nSolophos (0-18-0)\nUrea (46-0-0)'),
                                  leading: Radio(
                                    value: 'muriateOfPotash,solophos,urea',
                                    groupValue: fertilizerCombination,
                                    onChanged: (String value) {
                                      setState(() {
                                        fertilizerCombination = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
                      print(province);
                      print(municipality);
                      print(brgy);

                      print(growingSeason);

                      print(_areaController.text);
                      print(variety);

                      print(_tyController.text);

                      print(fertilizerCombination.split(','));
                      //process(double.parse(_areaController.text),(site + '-' + variety).toLowerCase(),_choice.split(','),double.parse(_tyController.text), growingSeason);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CalculateScreen(
                          province:province.toLowerCase(),
                          municipality:municipality.toLowerCase(),
                          brgy:brgy.toLowerCase(),
                          growingSeason:growingSeason.toLowerCase(),
                          area:double.parse(_areaController.text),
                          variety: variety.toLowerCase(),
                          targetYield: double.parse(_tyController.text),
                          fertilizerCombination: fertilizerCombination.split(',')
                        )),
                      );

//                    FocusScopeNode currentFocus = FocusScope.of(context);
//                    if (!currentFocus.hasPrimaryFocus) {
//                      currentFocus.unfocus();
//                    }
                    }else{
                      Fluttertoast.showToast(
                          msg: 'Complete the steps first.',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  padding: const EdgeInsets.symmetric(vertical:15.0),
                  child: Text('PROCEED',style:TextStyle(fontSize:15)),
                ),
              ),
              SizedBox(height:10),
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
