import 'package:flutter/material.dart';
import 'package:datapemilih/models/voter_model.dart';
import 'package:datapemilih/services/api_service.dart';
import 'package:datapemilih/widgets/form_label.dart';
import 'package:datapemilih/widgets/radio_button.dart';

class EditScreen extends StatefulWidget {
  final Voter voter;
  final int id;

  EditScreen({@required this.voter, @required this.id, Key key})
      : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  ApiService apiService;

  static const genders = Voter.genders; // from domain

  // upayakan menggunakan global key
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  bool _autovalidate = false;
  // jarak antar form
  double _gap = 16.0;
  // focus node
  FocusNode _namaFocus, _nikFocus, _phoneFocus, _dusunFocus, _alamatFocus;
  // variabel value null
  String _nama, _nik, _gender, _phone, _dusun, _alamat;

  TextEditingController _namaController,
      _nikController,
      _phoneController,
      _dusunController,
      _alamatController;

  @override
  void initState() {
    super.initState();
    _gender = 'pria';
    _namaFocus = FocusNode();
    _nikFocus = FocusNode();
    _phoneFocus = FocusNode();
    _dusunFocus = FocusNode();
    _alamatFocus = FocusNode();
    _namaController = TextEditingController();
    _nikController = TextEditingController();
    _phoneController = TextEditingController();
    _dusunController = TextEditingController();
    _alamatController = TextEditingController();

    if (widget.voter != null && widget.id != null) {
      _nama = widget.voter.nama;
      _nik = widget.voter.nik;
      _gender = widget.voter.gender;
      _phone = widget.voter.phone;
      _dusun = widget.voter.dusun;
      _alamat = widget.voter.alamat;

      _namaController.value = TextEditingValue(
          text: widget.voter.nama,
          selection: TextSelection.collapsed(offset: widget.voter.nama.length));

      _nikController.value = TextEditingValue(
          text: widget.voter.nik,
          selection: TextSelection.collapsed(offset: widget.voter.nik.length));

      _phoneController.value = TextEditingValue(
          text: widget.voter.phone,
          selection:
              TextSelection.collapsed(offset: widget.voter.phone.length));

      _dusunController.value = TextEditingValue(
          text: widget.voter.dusun,
          selection:
              TextSelection.collapsed(offset: widget.voter.dusun.length));

      _alamatController.value = TextEditingValue(
          text: widget.voter.alamat,
          selection:
              TextSelection.collapsed(offset: widget.voter.alamat.length));
    }

    apiService = ApiService();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _namaFocus.dispose();
    _nikFocus.dispose();
    _phoneFocus.dispose();
    _dusunFocus.dispose();
    _alamatFocus.dispose();
    _namaController.dispose();
    _nikController.dispose();
    _phoneController.dispose();
    _dusunController.dispose();
    _alamatController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
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
            Navigator.pop(context),
          },
        ),
        title: Text("Edit Pemilih"),
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
                    controller: _namaController,
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
                      _namaFocus.unfocus();
                      FocusScope.of(context).requestFocus(_namaFocus);
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
                    controller: _nikController,
                    focusNode: _nikFocus,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'NIK (Nomor Induk Kepegawaian)',
                    ),
                    onSaved: (String value) {
                      // will trigger when saved
                      print('onsaved _nik $value');
                      _nik = value;
                    },
                    onFieldSubmitted: (term) {
                      _nikFocus.unfocus();
                      FocusScope.of(context).requestFocus(_nikFocus);
                    },
                    validator: (val) {
                      if (val.isEmpty) {
                        return "NIK pemilh wajib diisi";
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
                    controller: _phoneController,
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
                      _phoneFocus.unfocus();
                      FocusScope.of(context).requestFocus(_phoneFocus);
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
                    controller: _dusunController,
                    focusNode: _dusunFocus,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nama Dusun',
                    ),
                    onSaved: (String value) {
                      // will trigger when saved
                      print('onsaved _dusun $value');
                      _dusun = value;
                    },
                    onFieldSubmitted: (term) {
                      _dusunFocus.unfocus();
                      FocusScope.of(context).requestFocus(_dusunFocus);
                    },
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Nama dusun wajib diisi";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: _gap,
                  ),
                  TextFormField(
                    controller: _alamatController,
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
                      _alamatFocus.unfocus();
                      FocusScope.of(context).requestFocus(_alamatFocus);
                    },
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Alamat lengkap wajib diisi";
                      }
                      return null;
                    },
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
              } else {
                _voter.nama = _nama;
                _voter.nik = _nik;
                _voter.gender = _gender;
                _voter.phone = _phone;
                _voter.dusun = _dusun;
                _voter.alamat = _alamat;
                print(_voter);

                // snackbar success dan error
                final onSuccess =
                    (Object success) => Navigator.pop(context, true);
                final onError = (Object error) =>
                    _showSnackBar("Gagal koneksi data ke server");

                apiService
                    .updateVoter(id: widget.voter.id, data: _voter)
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
