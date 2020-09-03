import 'dart:convert';

import 'package:datapemilih/models/voter_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2/datapemilih/public/api";
  // Client client = Client();

  Future login(username, password) async {
    final response = await http.post("$baseUrl/kordinator",
        body: {"username": username, "password": password});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      return null;
    }
  }

  Future<List<Voter>> getVoters() async {
    final response = await http.get("$baseUrl/voter");
    if (response.statusCode == 200) {
      return suaraFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<List<Voter>> getVotersFilter(String kode) async {
    final response = await http.get("$baseUrl/voter/filter/$kode");
    if (response.body.isNotEmpty) {
      return suaraFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<Voter> getVoterBy(int id) async {
    final response = await http.get("$baseUrl/voter/by/$id");
    if (response.statusCode == 200) {
      final data = Voter.fromJson(json.decode(response.body));
      return data;
    } else {
      return null;
    }
  }

  // Future<bool> createVoter(Voter data) async {
  //   final response = await http.post("$baseUrl/voter/create", body: {
  //     "nama": data.nama,
  //     "gender": data.gender,
  //     "phone": data.phone,
  //     "dusun": data.dusun,
  //     "alamat": data.alamat,
  //     "kode": data.kode
  //   });
  //   if (response.statusCode == 200) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  Future<bool> createVoter(Voter data) async {
    var stream = new http.ByteStream(data.img.openRead());
    var length = await data.img.length();

    var uri = Uri.parse("$baseUrl/voter/create");

    var request = new http.MultipartRequest("POST", uri)
      ..fields["nama"] = data.nama
      ..fields["nik"] = data.nik
      ..fields["gender"] = data.gender
      ..fields["phone"] = data.phone
      ..fields["dusun"] = data.dusun
      ..fields["alamat"] = data.alamat
      ..fields["kode"] = data.kode
      ..files.add(http.MultipartFile("image", stream.cast(), length,
          filename: basename(data.img.path)));
    //contentType: new MediaType('image', 'png'));

    final response = await request.send();
    print('respon simpan data $response');
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateVoter({int id, Voter data}) async {
    final response = await http.post("$baseUrl/voter/update/$id", body: {
      "nama": data.nama,
      "nik": data.nik,
      "gender": data.gender,
      "phone": data.phone,
      "dusun": data.dusun,
      "alamat": data.alamat
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future deleteVoter({int id}) async {
    // ganti dengan method get juga gpph
    final response = await http.delete("$baseUrl/voter/delete/$id");
    if (response.statusCode == 200) {
      return 1;
    } else {
      return 0;
    }
  }
}
