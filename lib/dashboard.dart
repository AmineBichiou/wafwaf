import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:startpfe/login_signup/LoginOwner.dart';
import 'dart:developer' as developer;

import 'package:startpfe/profile.dart';

class Dashboard extends StatefulWidget {
  final token;
  Dashboard({@required this.token, Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String email;
  late String id = '';

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
    email = decodedToken['email'];
    getId();
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginOwner()),
    );
  }

  Future<void> getId() async {
    try {
      var response = await http.get(
        Uri.parse('http://10.0.2.2:5000/getIdByEmail/$email'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var message = jsonDecode(response.body);
        developer.log('ID obtained: $message');
        setState(() {
          id = message;
        });
        print('ID obtained: $id');
      } else {
        throw Exception('Failed to get ID');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 100,
        width: 90,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            //border: Border.all(color: Colors.black, width: 2),
          ),
          child: FloatingActionButton(
            onPressed: () {
              // Add your onPressed logic here
            },
            child: Image.asset('assets/waflogo.png'),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 2,
        shape:CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        color: Color(0xffAD0E48),
        height: 60%MediaQuery.of(context).size.height,
        child: Row(
          
          children: [
            
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.home),
              iconSize: 40,
              color: Colors.white,
            ),
            SizedBox(width: 20),
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.history),
              iconSize: 40,
              color: Colors.white,
            ),
            SizedBox(width: 110),
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.shopping_cart_outlined),
              iconSize: 40,
              color: Colors.white,
            ),
            SizedBox(width: 30),
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.message_sharp),
              iconSize: 40,
              color: Colors.white,
            ),
          ],
        ),

      ),
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(id: id)),
                );
              },
              child: Row(
                children: [
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.account_circle,
                    size: 26.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ID obtained:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              id,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: logout,
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
