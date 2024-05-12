import 'dart:ui';

import 'package:absensi/views/absensi/AbsensiScreen.dart';
import 'package:absensi/views/navbar/Navbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jiffy/jiffy.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isHomeScreen = true;

  String? fullName = '';
  String? divisionName = '';
  String tanggal = Jiffy.now().format(pattern: 'd MMMM yyyy');
  String hari = Jiffy.now().format(pattern: 'EEEE');

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

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
      body: Stack(
        children: [
          ClipPath(
            clipper: ClipPathClass(),
            child: Container(
              height: 250,
              color: Color.fromARGB(255, 0, 166, 255),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Container(
                  height: 230,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        height: 230,
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 255, 255, 255),
                              Color.fromARGB(255, 235, 235, 235),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Regular $divisionName",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  hari.toString(),
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "08:00 - 17:00 WIB",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  tanggal.toString(),
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Masuk: 08:00 WIB",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 148, 189)
                                        .withOpacity(0.6),
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "Pulang: 17:00 WIB",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 148, 189),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              color: Color.fromARGB(255, 195, 195, 195),
                              height: 2,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Rekap absen bulan ini",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "HADIR",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.5)),
                                    ),
                                    Text(
                                      "11 Hadir",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.green),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 28,
                                ),
                                Container(
                                  height: 40,
                                  width: 1,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "IZIN",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.5)),
                                    ),
                                    Text(
                                      "1 Hadir",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Color.fromARGB(255, 0, 30, 255),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Container(
                                  height: 40,
                                  width: 1,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "SAKIT",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.5)),
                                    ),
                                    Text(
                                      "1 Hadir",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Color.fromARGB(255, 255, 179, 0),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Menu",
                        style: TextStyle(
                          color:
                              Color.fromARGB(255, 0, 166, 255).withOpacity(0.5),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          wordSpacing: 2,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ItemKategori(
                              title: "IZIN", icon: "images/papers.png"),
                          ItemKategori(
                              title: "LEMBUR", icon: "images/clock_0.png"),
                          ItemKategori(
                              title: "SHIFT", icon: "images/clock.png"),
                          ItemKategori(
                              title: "REIMBURSE", icon: "images/document.png"),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ItemKategori(
                              title: "SLIP GAJI", icon: "images/Coins.png"),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Berita (Cooming soon)",
                        style: TextStyle(
                          color:
                              Color.fromARGB(255, 0, 166, 255).withOpacity(0.5),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          wordSpacing: 2,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar: Navbar(),

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
            Icons.fingerprint_rounded,
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
            selectedItemColor: Color.fromARGB(255, 0, 166, 255),
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

class ClipPathClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class ItemKategori extends StatelessWidget {
  ItemKategori({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  final String title;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {},
          child: Column(
            children: [
              Container(
                width: 75,
                child: Image.asset(
                  icon,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 219, 219, 219),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
