import 'package:datapemilih/screens/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:datapemilih/models/voter_model.dart';
// import 'package:datapemilih/screens/edit_screen.dart';
import 'package:datapemilih/services/api_service.dart';

class DetailScreen extends StatefulWidget {
  // create variabel id untuk menghandle param yang diberikan (wajib ada @required)
  final int id;
  // constructor
  DetailScreen({@required this.id, Key key}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // create variabel untuk menampung User Api Service
  ApiService apiService;
  // create variabel _user untuk menampung model User
  Voter _voter;

  // scaffold key
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    apiService = ApiService();
    super.initState();
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
      // header
      appBar: AppBar(
        title: Text("Detail Pemilih"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => {
            Navigator.pop(context, true),
          },
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                // Navigator.push returns a Future that completes after calling
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditScreen(voter: _voter, id: widget.id)),
                );

                if (result != null) {
                  _showSnackBar("Data pemilih berhasil di update");
                  setState(() {});
                }
              }),
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                final onSuccess = (Object obj) async {
                  _showSnackBar(
                      "Data pemilih berhasil dihapus, silahkan tunggu akan diarahkan ke halaman home");
                  await Future.delayed(Duration(seconds: 2))
                      .then((Object obj) => Navigator.pop(context, true));
                };

                final onError =
                    (Object obj) => _showSnackBar("Data pemilih gagal dihapus");

                apiService
                    .deleteVoter(id: widget.id)
                    .then(onSuccess)
                    .catchError(onError);
              }),
        ],
      ),
      // body
      body: Center(
        child: FutureBuilder<Voter>(
            // panggil function getVoterBy(int id)
            future: apiService.getVoterBy(widget.id),
            builder: (context, snapshot) {
              // jika connection none atau data = null
              if (snapshot.connectionState == ConnectionState.none &&
                  snapshot.hasData == null) {
                return LinearProgressIndicator();

                // jika connection berhasil
              } else if (snapshot.connectionState == ConnectionState.done) {
                // tampung data dari server
                _voter = snapshot.data;

                // jika data ada / tidak null
                if (_voter.id != 0) {
                  return ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        // child: Image.asset(
                        //   'assets/images/${_voter.gender}.png',
                        //   width: 150.0,
                        //   height: 150.0,
                        // ),
                        child: Image.network(
                          'http://10.0.2.2/datapemilih/public/uploads/${_voter.image}',
                          width: 150.0,
                          height: 150.0,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.account_box),
                        title: Text(_voter.nama),
                        subtitle: const Text('Nama'),
                      ),
                      ListTile(
                        leading: Icon(Icons.confirmation_number),
                        title: Text(_voter.nik),
                        subtitle: const Text('NIK'),
                      ),
                      ListTile(
                        leading: Icon(Icons.label),
                        title: Text(_voter.gender),
                        subtitle: const Text('Jenis Kelamin'),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text(_voter.phone),
                        subtitle: const Text('No.Hp'),
                      ),
                      ListTile(
                        leading: Icon(Icons.map),
                        title: Text(_voter.dusun),
                        subtitle: const Text('Dusun'),
                      ),
                      ListTile(
                        leading: Icon(Icons.home),
                        title: Text(_voter.alamat),
                        subtitle: const Text('Alamat'),
                      ),
                    ],
                  );
                  // jika data null / tidak ada
                } else {
                  return Text("Data pemilih tidak ditemukan");
                }
                // tampilkan container kosong jika terjadi hal lainnya
              } else {
                return Center(
                  child: Container(),
                );
              }
            }),
      ),
    );
  }
}
