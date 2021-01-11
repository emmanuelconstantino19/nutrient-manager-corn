import 'package:flutter/material.dart';
import 'package:nutrient_manager_corn_new/screens/forms_screen.dart';

class FrontScreen extends StatefulWidget {
  @override
  _FrontScreenState createState() => _FrontScreenState();
}

class _FrontScreenState extends State<FrontScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Colors.green, Colors.lightGreen])
        ),
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Nutrient Manager for Corn", style: TextStyle(color:Colors.white,fontSize:36), textAlign: TextAlign.center),
                  ),
                  Image.asset(
                    'assets/corn.png',
                    //fit: BoxFit.,
                    height: 200,
                  ),
                ],
              ),
              Column(
                children: [
                  Text("Brought to you by:", style: TextStyle(color:Colors.white,fontSize:20), textAlign: TextAlign.center),
                  SizedBox(height:20),
                  Image.asset(
                    'assets/dost-pcaarrd-uplb.png',
                    //fit: BoxFit.,
                    height: 50,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal:20),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      //side: BorderSide(color: Colors.lightGreen[700])
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => FormsScreen()),
                      );
                    },
                    color: Colors.white,
                    textColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical:15.0),
                    child: Text('START CALCULATING',style:TextStyle(fontSize:15)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
