import 'package:datapemilih/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:datapemilih/screens/input_screen.dart';
import 'package:datapemilih/widgets/custom_clipper.dart';
import 'package:datapemilih/models/voter_model.dart';
import 'package:datapemilih/screens/login_screen.dart';
import 'package:datapemilih/services/api_service.dart';
import 'package:datapemilih/services/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // create variabel untuk menampung Api Service
  ApiService apiService;

  // create variabel untuk menampung Data Local
  LocalStorage localStorage;

  // upayakan menggunakan global key
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  // Variabel sharedPref
  String namaPref, kodePref, kdesaPref;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    localStorage = LocalStorage();
    localStorage.getNama().then((value) {
      namaPref = value.toString();
      setState(() {});
    });
    localStorage.getKode().then((value) {
      kodePref = value.toString();
      setState(() {});
    });
    localStorage.getKdesa().then((value) {
      kdesaPref = value.toString();
      setState(() {});
    });
  }

  _showSnackBar(message) {
    final snackbar = SnackBar(
      content: Text(message),
    );
    _scaffoldkey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClipPath(
              clipper: MyClipper(),
              child: Container(
                padding: EdgeInsets.only(left: 40, top: 20, right: 20),
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xFF3383CD),
                      Color(0xFF11249F),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 5,
                            left: 0,
                            child: Text(
                              // 'Welcome back $namaPref \n Kord $kdesaPref',
                              'Welcome back $namaPref \n Kord Kel. Lorem Ipsum',
                              style: kHeadingTextStyle.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(), // I dont know why it can't work witout container
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(0xFFE5E5E5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: Color(0xFF3383CD),
                    textColor: Colors.white,
                    child: Text("Tambah"),
                    onPressed: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InputScreen(),
                          ));

                      //print('tangkap data dari halaman sebelumnya $result');
                      if (result != null) {
                        _showSnackBar("Data pemilih berhasil ditambahkan");
                        setState(() {});
                      }
                    },
                  ),
                  RaisedButton(
                    color: Color(0xFF3383CD),
                    textColor: Colors.white,
                    child: Text("Keluar"),
                    onPressed: _logout,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5.0),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(0xFFE5E5E5),
                ),
              ),
              child: FutureBuilder<List<Voter>>(
                future: apiService.getVotersFilter(kodePref),
                builder: (context, snapshot) {
                  // jika connection none atau data = null or false
                  if (snapshot.hasError || snapshot.hasData == false) {
                    return Center(
                      child: Text(
                          "Terjadi kesalahan, kode error: ${snapshot.error.toString()}"),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    // tampung data dari server
                    List<Voter> voters = snapshot.data;
                    // print('tangkap data dari api $pemilih');
                    return _buildListView(voters);
                  } else {
                    return Center(
                      child: Container(),
                    );
                  }
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(List<Voter> voters) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int i) =>
          Divider(color: Colors.grey[400]),
      shrinkWrap: true,
      itemCount: voters.length,
      itemBuilder: (context, index) {
        Voter voter = voters[index];
        return ListTile(
          onTap: () async {
            // Navigator.push returns a Future that completes after calling
            final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetailScreen(id: voter.id, key: ValueKey(voter.id)),
                ));

            //print('tangkap data dari halaman sebelumnya $result');
            if (result != null) {
              setState(() {});
            }
          },
          leading: Image.asset(
            'assets/images/${voter.gender}.png',
            width: 50.0,
            height: 50.0,
          ),
          title: Text(voter.nama),
          subtitle: Text(voter.phone),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(voter.nik.substring(5, 16)),
              Text(voter.dusun)
            ],
          ),
        );
      },
    );
  }

  void _logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setBool("value", false);
      preferences.setString("username", '');
      preferences.setString("fullname", '');
      preferences.setString("kode", '');
      preferences.setString("kdesa", '');
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
