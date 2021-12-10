import 'package:calidad_app/model/appointmentDetails.dart';
import 'package:calidad_app/model/user.dart';
import 'package:calidad_app/provider/userProvider.dart';
import 'package:calidad_app/screens/prescription.dart';

import 'package:calidad_app/utils/firebaseRepository.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class History extends StatefulWidget {
  const History({Key key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool _isLoading = false;
  UserProvider userProvider;
  Users user;
  FirebaseRepository _repo = FirebaseRepository();
  List<AppointmentDetails> history;
  @override
  void initState() {
    super.initState();
    _isLoading = true;
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);

      await userProvider.refreshUser();
      user = userProvider.getUser;
      history = await _repo.getHistory(user.uid).then((value) {
        setState(() {
          _isLoading = false;
        });
        return value;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : history == null
                      ? Center(
                          child: Text("No History Available",
                              style: GoogleFonts.montserrat(fontSize: 24)))
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: history.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.blue[900],
                                  )),
                              child: ListTile(
                                onTap: () async {
                                  if (history[index].rx != null) {
                                    Map calldetails =
                                        await _repo.getPrescription(
                                            history[index].doctorId,
                                            history[index].uid,
                                            history[index].channeId,
                                            history[index].patientDetails.id);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Prescription(
                                                  callDetails: calldetails,
                                                )));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Prescription Not Available")));
                                  }
                                },
                                title: Text(
                                  "Patient - ${history[index].patientDetails.name}",
                                  style: GoogleFonts.montserrat(fontSize: 16),
                                ),
                                subtitle: Text(
                                  "Doctor - ${history[index].doctor}",
                                  style: GoogleFonts.montserrat(fontSize: 14),
                                ),
                              ),
                            );
                          })
            ],
          ),
        ),
      ),
    );
  }
}
