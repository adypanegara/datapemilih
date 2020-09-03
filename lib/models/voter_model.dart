import 'dart:convert';
import 'dart:io';

class Voter {
  static const genders = ['pria', 'wanita'];

  int id;
  String nama, nik, gender, phone, dusun, alamat, kode, image;
  File img;

  Voter(
      {this.id,
      this.nama,
      this.nik,
      this.gender,
      this.phone,
      this.dusun,
      this.alamat,
      this.kode,
      this.image});

  factory Voter.fromJson(Map<String, dynamic> map) {
    return Voter(
        id: map["id"],
        nama: map["nama"],
        nik: map["nik"],
        gender: map["gender"],
        phone: map["phone"],
        dusun: map["dusun"],
        alamat: map["alamat"],
        kode: map["kode"],
        image: map["image"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nama": nama,
      "nik": nik,
      "gender": gender,
      "phone": phone,
      "dusun": dusun,
      "alamat": alamat,
      "kode": kode,
      "image": img
    };
  }

  @override
  String toString() {
    return 'Voter{id: $id, nama: $nama, nik: $nik, gender: $gender, phone: $phone, dusun: $dusun, alamat: $alamat, kode: $kode, image: $img }';
  }
}

List<Voter> suaraFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Voter>.from(data.map((item) => Voter.fromJson(item)));
}

String suaraToJson(Voter data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
