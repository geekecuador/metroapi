import 'dart:convert';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.teal,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
        ),
      ),
      child: _isLoading ? Center(child:CircularProgressIndicator()) : ListView(
        children: <Widget>[
          headerSection(),
          textSection(),
          buttonSection(),
        ],
    ),
    );
  }

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      margin: EdgeInsets.only(top: 30.0),
      child: Column(
        children: <Widget>[
          txtEmail("Email", Icons.email),
          SizedBox(),
          txtPassword("Password", Icons.lock),
        ],
      ),
    );
  }

  signIn(String email, String password) async {
    Map data = {
      'email': email,
      'password': password,
    };
    //{
    //    "nombre": "pruebas",
    //    "clave": "620a7de82763527406a413ca7ee267816d332811",
    //    "nemonicoAplicacion": "PRUEBA"
    //}
    var jsonData = null;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response = await http.post("192.168.108.2:8080/mt-sw-autorizacion/webresources/login/obtenerPorCredenciales"
        "", body: data);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      setState(() {
        _isLoading = false;
        sharedPreferences.setString("token", jsonData['token']);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (BuildContext context) => MainPage()), (
            Route<dynamic> route) => false);
      });
    }
    else{
      print(response.body);
    }
  }

  Container buttonSection() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      margin: EdgeInsets.only(top: 30.0),
      child: RaisedButton(
        onPressed: () {
          setState(() {
            _isLoading = true;
          });
          signIn(emailController.text, passwordController.text);
        },
        color: Colors.purple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),

    );
  }

  TextFormField txtEmail(String title, IconData icon) {
    return TextFormField(
      controller: emailController,
      style: TextStyle(color: Colors.white70),
      decoration: InputDecoration(
          hintText: title,
          hintStyle: TextStyle(color: Colors.white70),
          icon: Icon(icon)
      ),
    );
  }

  TextFormField txtPassword(String title, IconData icon) {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      style: TextStyle(color: Colors.white70),
      decoration: InputDecoration(
        hintText: title,
        hintStyle: TextStyle(color: Colors.white70),
        icon: Icon(icon),
      ),
    );
  }

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  Container headerSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text("Metro", style: TextStyle(color: Colors.white)),
    );
  }
}
