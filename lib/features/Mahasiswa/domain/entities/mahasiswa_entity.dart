import 'package:equatable/equatable.dart';

class MahasiswaEntity extends Equatable {
  final int? nim;
  final String? name;
  final String? province;
  final String? city;
  final String? district;
  final String? subdistrict;
  final String? email;
  final String? phoneNumber;
  final String? fakultas;
  final String? jurusan;
  final String? birth;
  final String? gender;
  final String? image;

  const MahasiswaEntity({
    this.nim,
    this.name,
    this.province,
    this.city,
    this.district,
    this.subdistrict,
    this.email,
    this.phoneNumber,
    this.fakultas,
    this.jurusan,
    this.birth,
    this.gender,
    this.image,
  });

  @override
  List<Object?> get props {
    return [
      nim,
      name,
      province,
      city,
      district,
      subdistrict,
      email,
      phoneNumber,
      fakultas,
      jurusan,
      birth,
      gender,
      image,
    ];
  }
}
