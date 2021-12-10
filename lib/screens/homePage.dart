import 'package:calidad_app/model/doctor.dart';
import 'package:calidad_app/model/user.dart';
import 'package:calidad_app/provider/userProvider.dart';
import 'package:calidad_app/screens/history.dart';
import 'package:calidad_app/screens/loginScreen.dart';

import 'package:calidad_app/screens/patients.dart';
import 'package:calidad_app/screens/search_page.dart';
import 'package:calidad_app/utils/firebaseRepository.dart';
import 'package:calidad_app/widgets/categoryBox.dart';
import 'package:calidad_app/widgets/doctorCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  final Users user;

  const HomePage({Key key, @required this.user}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseRepository _firebaseRepository = FirebaseRepository();
  TextEditingController _search = TextEditingController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      authenticateUser(widget.user);
    });
  }

  authenticateUser(Users user) async {
    try {
      bool res = await _firebaseRepository.authenticateUser(user);

      if (!res) {
        res = await _firebaseRepository.addDataToDb(user);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: Container(
        width: width * 0.7,
        //Nav Drawer
        child: Drawer(
            child: Container(
                child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding:
                  EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
              height: 180,
              width: width,
              decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(30))),
              child: Column(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: widget.user.profilePhoto == null
                        ? Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.blue[900],
                          )
                        : Image.network(widget.user.profilePhoto),
                  ),
                  SizedBox(height: 25),
                  Text(
                    widget.user.username,
                    style: GoogleFonts.montserrat(
                        fontSize: 24, color: Colors.white),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Patients(
                              doctor: null,
                              call: false,
                            )));
              },
              child: ListTile(
                title: Text("Patients",
                    style: GoogleFonts.montserrat(fontSize: 18)),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => History()));
              },
              child: ListTile(
                title: Text("History",
                    style: GoogleFonts.montserrat(fontSize: 18)),
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirm"),
                        content: Text("Confirm Logout?"),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                _firebaseRepository.signOut();
                                UserProvider().updateUser(null);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              },
                              child: Text("Logout",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 16, color: Colors.red))),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancel",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 16, color: Colors.blue))),
                        ],
                      );
                    });
                ////
              },
              child: ListTile(
                title:
                    Text("Logout", style: GoogleFonts.montserrat(fontSize: 18)),
              ),
            ),
          ],
        ))),
      ),

      ///
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Column(
            children: [
              //SEARCH Area
              Container(
                padding: EdgeInsets.only(top: 50, left: 15, right: 15),
                alignment: Alignment.topCenter,
                height: 280,
                decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    // colors: [Colors.indigo[900], Colors.blue[400]]),
                    color: Color(0xFF063970),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Builder(
                            builder: (context) => GestureDetector(
                              onTap: () {
                                Scaffold.of(context).openDrawer();
                              },
                              child: Icon(
                                Icons.menu,
                                size: 20,
                                color: Colors.blue[900],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Image.asset(
                            'assets/logo_full_white.png',
                            height: 40,
                            width: 100,
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 40),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "Let's find you a doctor",
                            style: GoogleFonts.montserrat(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 10),
                          Image.asset(
                            'assets/doctor.png',
                            height: 25,
                            width: 25,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 50,
                      child: TextField(
                        onEditingComplete: () async {
                          List<Doctor> doctors =
                              await _firebaseRepository.getDoctors();

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchPage(
                                        parameter: _search.text,
                                        searchList: doctors,
                                      )));
                        },
                        controller: _search,
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 12),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: new BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: new BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Search for a doctor ',
                          hintStyle: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                              fontSize: 14),
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              onPressed: () {}),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //Categories
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Categories ",
                        style: GoogleFonts.montserrat(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          CategoryBox(title: 'General'),
                          CategoryBox(title: 'Cardiologist'),
                          CategoryBox(title: 'Dentist'),
                          CategoryBox(title: 'Dermatologist'),
                          CategoryBox(title: 'Pshychologist'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    //Doctors
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Most Popular ",
                        style: GoogleFonts.montserrat(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    FutureBuilder(
                      future: _firebaseRepository.getDoctors(),
                      builder: (context, docList) {
                        if (docList.hasData) {
                          return Container(
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: docList.data.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      child: DoctorCard(
                                          doctor: docList.data[index]));
                                }),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
