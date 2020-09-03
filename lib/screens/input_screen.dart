import 'dart:io';

import 'package:flutter/material.dart';
import 'package:datapemilih/models/voter_model.dart';
import 'package:datapemilih/services/api_service.dart';
import 'package:datapemilih/widgets/form_label.dart';
import 'package:datapemilih/widgets/radio_button.dart';
import 'package:datapemilih/services/local_storage.dart';
import 'package:image_picker/image_picker.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  // create variabel untuk menampung Api Service
  ApiService apiService;

  // create variabel untuk menampung Data Local
  LocalStorage localStorage;

  static const genders = Voter.genders; // from domain

  // upayakan menggunakan global key
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final picker = ImagePicker();

  bool _autovalidate = false;
  // jarak antar form
  double _gap = 16.0;
  // focus node
  FocusNode _namaFocus, _nikFocus, _phoneFocus, _dusunFocus, _alamatFocus;
  // variabel data yang akan dikirim
  String _nama, _nik, _gender, _phone, _dusun, _alamat, kodePref;
  // variabel for image picker
  File _image;

  @override
  void initState() {
    super.initState();
    _gender = 'pria';
    _namaFocus = FocusNode();
    _nikFocus = FocusNode();
    _phoneFocus = FocusNode();
    _dusunFocus = FocusNode();
    _alamatFocus = FocusNode();
    apiService = ApiService();
    localStorage = LocalStorage();
    localStorage.getKode().then((value) {
      kodePref = value.toString();
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _namaFocus.dispose();
    _nikFocus.dispose();
    _phoneFocus.dispose();
    _dusunFocus.dispose();
    _alamatFocus.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  Future _getImageCamera() async {
    final imageFile = await picker.getImage(source: ImageSource.camera);

    if (imageFile != null) {
      setState(() {
        _image = File(imageFile.path);
        print('Log image capture $_image');
      });
    }
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => {
            Navigator.pop(context, true),
          },
        ),
        title: Text("Input Data Pemilih"),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Form(
            // key form as csrf
            key: _formKey,
            autovalidate: _autovalidate,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    focusNode: _namaFocus,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nama Lengkap',
                    ),
                    onSaved: (String value) {
                      // will trigger when saved
                      print('onsaved _nama $value');
                      _nama = value;
                    },
                    onFieldSubmitted: (term) {
                      // process
                    },
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Nama lengkap wajib diisi";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: _gap,
                  ),
                  TextFormField(
                    focusNode: _nikFocus,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'NIK (Nomor Induk Kependudukan)',
                    ),
                    onSaved: (String value) {
                      // will trigger when saved
                      print('onsaved _nik $value');
                      _nik = value;
                    },
                    onFieldSubmitted: (term) {
                      // process
                    },
                    validator: (val) {
                      if (val.isEmpty) {
                        return "NIK pemilih wajib diisi";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: _gap,
                  ),
                  FormLabel('Jenis Kelamin'),
                  Row(
                    children: genders
                        .map((String val) => RadioButton<String>(
                            value: val,
                            groupValue: _gender,
                            label: Text(val),
                            onChanged: (String value) {
                              setState(() => _gender = value);
                            }))
                        .toList(),
                  ),
                  SizedBox(
                    height: _gap,
                  ),
                  TextFormField(
                    focusNode: _phoneFocus,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'No. Hp',
                    ),
                    onSaved: (String value) {
                      // will trigger when saved
                      print('onsaved _phone $value');
                      _phone = value;
                    },
                    onFieldSubmitted: (term) {
                      // process
                    },
                    validator: (val) {
                      if (val.isEmpty) {
                        return "No hp wajib diisi";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: _gap,
                  ),
                  TextFormField(
                    focusNode: _dusunFocus,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nama Lingkungan / Dusun',
                    ),
                    onSaved: (String value) {
                      // will trigger when saved
                      print('onsaved _dusun $value');
                      _dusun = value;
                    },
                    onFieldSubmitted: (term) {
                      // process
                    },
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Nama lingkungan / dusun wajib diisi";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: _gap,
                  ),
                  TextFormField(
                    focusNode: _alamatFocus,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Alamat Lengkap',
                    ),
                    onSaved: (String value) {
                      // will trigger when saved
                      print('onsaved _alamat $value');
                      _alamat = value;
                    },
                    onFieldSubmitted: (term) {
                      // process
                    },
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Alamat lengkap wajib diisi";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: _gap,
                  ),
                  GestureDetector(
                    onTap: _getImageCamera,
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Color(0xFF6E6E6E),
                          ),
                        ),
                        child: Center(
                          child: _image == null
                              ? Text("Ketuk disini untuk ambil foto!")
                              : Image.file(_image),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.save,
            color: Colors.white,
          ),
          onPressed: () {
            final form = _formKey.currentState;
            if (form.validate()) {
              // Process data.
              form.save(); // required to trigger onSaved props
              Voter _voter = Voter();

              if (_gender == null) {
                _showSnackBar("Gender tidak boleh kosong");
              } else if (_image == null) {
                _showSnackBar("Foto pemilih tidak boleh kosong");
              } else {
                _voter.nama = _nama;
                _voter.nik = _nik;
                _voter.gender = _gender;
                _voter.phone = _phone;
                _voter.dusun = _dusun;
                _voter.alamat = _alamat;
                _voter.kode = kodePref;
                _voter.img = _image;
                print(_voter);

                // snackbar success dan error
                final onSuccess =
                    (Object success) => Navigator.pop(context, true);

                final onError =
                    (Object error) => _showSnackBar("Tidak bisa simpan data");

                apiService
                    .createVoter(_voter)
                    .then(onSuccess)
                    .catchError(onError);
              }
            } else {
              setState(() {
                _autovalidate = true;
              });
            }
          }),
    );
  }
}
