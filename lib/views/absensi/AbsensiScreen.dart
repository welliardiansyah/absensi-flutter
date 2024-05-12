import 'dart:ui';
import 'package:absensi/views/home/HomeScreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera/camera.dart';

class AbsensiScreen extends StatefulWidget {
  @override
  _AbsensiScreenState createState() => _AbsensiScreenState();
}

class _AbsensiScreenState extends State<AbsensiScreen> {
  bool isHomeScreen = true;
  String? fullName = '';
  String? divisionName = '';

  Future<void> _fetchProfileData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token != null) {
        Dio dio = Dio();
        dio.options.headers['Authorization'] = 'Bearer $token';

        Response response =
            await dio.get('http://68.183.234.187:8080/api/v1/auth/profile');
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data['data'];
          String fullnames = responseData['fullname'];
          String divisions = responseData['division'][0]['name'];
          setState(() {
            fullName = fullnames;
            divisionName = divisions;
          });
        } else {
          print('Failed to load profile data: ${response.statusCode}');
        }
      } else {
        print('Token not available');
      }
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: "Hai, ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text: fullName,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "PT. INDONESIA MAJU TERUS, ",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(right: 10),
              height: 30,
              width: 30,
              child: Icon(
                Icons.qr_code,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
        backgroundColor: Color.fromARGB(255, 0, 166, 255),
        elevation: 0,
      ),

      //** NAVBAR */
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: FloatingActionButton(
          backgroundColor:
              isHomeScreen ? Color.fromARGB(255, 0, 166, 255) : Colors.grey,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AbsensiScreen()),
            );
          },
          child: const Icon(
            Icons.camera_alt_rounded,
            size: 40,
            color: Colors.white,
          ),
          shape: CircleBorder(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
        height: MediaQuery.of(context).size.height / 11.3,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        color: Color.fromARGB(255, 247, 247, 247),
        elevation: 0,
        clipBehavior: Clip.hardEdge,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5,
            sigmaY: 5,
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.grey,
            unselectedItemColor: Colors.grey,
            currentIndex: isHomeScreen ? 0 : 1,
            elevation: 0,
            onTap: (index) {
              setState(() {
                isHomeScreen = index == 0;
              });
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              } else if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AbsensiScreen()),
                );
              }
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'BRANDA'),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_outline_rounded),
                label: 'DATA ABSENSI',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
