import 'package:datapemilih/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:datapemilih/constant.dart';
import 'package:datapemilih/screens/home_screen.dart';
import 'package:datapemilih/services/api_service.dart';
import 'package:datapemilih/widgets/custom_clipper.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // create variabel untuk menampung Api Service
  ApiService apiService;

  // create variabel untuk menampung Data Local
  LocalStorage localStorage;

  // set nilai awal state
  bool _autovalidate = false;
  // jarak antar form
  double _gap = 16.0;
  // focus node
  FocusNode _usernameFocus, _passwordFocus;
  // variabel value null
  String _username, _password;

  // upayakan menggunakan global key
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  _showSnackBar(message) {
    final snackbar = SnackBar(
      content: Text(message),
    );
    _scaffoldkey.currentState.showSnackBar(snackbar);
  }

  @override
  void initState() {
    super.initState();
    _usernameFocus = FocusNode();
    _passwordFocus = FocusNode();
    apiService = ApiService();
    localStorage = LocalStorage();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
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
                padding: EdgeInsets.only(left: 40, top: 50, right: 20),
                height: 280,
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
                            top: 20,
                            left: 0,
                            child: Text(
                              "Aplikasi Database Pemilih\n By Tim Data.",
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
            Center(
              child: Form(
                // key form as csrf
                key: _formKey,
                autovalidate: _autovalidate,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        focusNode: _usernameFocus,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                        ),
                        onSaved: (String value) {
                          // will trigger when saved
                          print('onsaved _username $value');
                          _username = value;
                        },
                        onFieldSubmitted: (term) {
                          // process
                        },
                        validator: (val) {
                          if (val.isEmpty) {
                            return "username wajib diisi";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: _gap,
                      ),
                      TextFormField(
                        focusNode: _passwordFocus,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                        onSaved: (String value) {
                          // will trigger when saved
                          print('onsaved _password $value');
                          _password = value;
                        },
                        onFieldSubmitted: (term) {
                          // process
                        },
                        validator: (val) {
                          if (val.isEmpty) {
                            return "password wajib diisi";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: _gap,
                      ),
                      RaisedButton(
                        color: Color(0xFF11249F),
                        textColor: Colors.white,
                        child: Text("Login"),
                        onPressed: _login,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login() {
    final form = _formKey.currentState;
    if (form.validate()) {
      // Process data.
      form.save(); // required to trigger onSaved props

      // snackbar success dan error
      final onSuccess = (Object jsonObject) {
        if (jsonObject != null) {
          // get data json tree 1
          var obj = jsonObject as Map<String, dynamic>;
          // get data json tree 2
          var data = (jsonObject as Map<String, dynamic>)['data'];

          // definisikan data untuk shared preference
          bool value = obj['error'];
          String username = data['username'];
          String fullname = data['fullname'];
          String kode = data['kode'];
          String kdesa = data['kdesa'];

          // print(
          //     'Get data from json: $value, $username, $fullname, $kode, $level');

          // Simpan data login ke shared preference
          localStorage.setData(value, username, fullname, kode, kdesa);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          _showSnackBar("Username / password salah");
        }
      };

      final onError =
          (Object error) => _showSnackBar("Gagal koneksi ke server");

      apiService
          .login(_username.trim(), _password.trim())
          .then(onSuccess)
          .catchError(onError);
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }
}
