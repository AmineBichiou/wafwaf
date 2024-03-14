import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final String? id;

  ProfilePage({required this.id});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? petOwnerData;
  String imageUrl = ''; 
  String baseUrl = "http://10.0.2.2:5000";

  @override
  void initState() {
    super.initState();
    fetchData(); // Call fetchData() when the widget initializes
  }
  

  Future<void> fetchData() async {
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/getPetOwnerById/${widget.id}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          petOwnerData = json.decode(response.body);
          petOwnerData!['image'] = imageUrl;
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
  String formater(String url) {
  return baseUrl + url;
}

NetworkImage getImage(String username) {
  String formattedUrl = formater("/uploads/$username");
  return NetworkImage(formattedUrl);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Center(
        child: petOwnerData != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 50,
                    //backgroundImage: getImage("1709815702036-wafpawn.png"),
                  ),
                  SizedBox(height: 20),
                  Text('Name: ${petOwnerData!['name']}'),
                  Text('Email: ${petOwnerData!['email']}'),
                  Text('Phone: ${petOwnerData!['phone']}'),
                  Text('Code Postal: ${petOwnerData!['codepostal']}'),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}

