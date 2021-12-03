import 'package:calidad_app/widgets/doctorCard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  final String parameter;
  final List searchList;

  const SearchPage({
    Key key,
    this.parameter,
    this.searchList,
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List list = [];
  List filteredList = [];
  TextEditingController param = TextEditingController();
  @override
  void initState() {
    param.text = widget.parameter;

    list = widget.searchList;
    filteredList = list
        .where((element) =>
            element.name.toLowerCase().contains(widget.parameter.toLowerCase()))
        .toList();

    super.initState();
  }

  filterList(List list, String param) {
    list = list
        .where((element) =>
            element.name.toLowerCase().contains(param.toLowerCase()))
        .toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              //Search Bar
              Container(
                height: 50,
                child: TextField(
                  onEditingComplete: () {
                    setState(() {
                      filteredList = filterList(list, param.text);
                    });
                  },
                  controller: param,
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 12),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: new BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: new BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Search',
                    hintStyle: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontSize: 14),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              Container(
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return Container(
                          child: DoctorCard(doctor: filteredList[index]));
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
