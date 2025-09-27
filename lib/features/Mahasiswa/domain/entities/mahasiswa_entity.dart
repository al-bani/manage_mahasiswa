import 'package:equatable/equatable.dart';

class MahasiswaEntity extends Equatable {
  final int? nim;
  final String? name;
  final String? asal;
  final String? email;
  final String? phoneNumber;
  final String? fakultas;
  final String? jurusan;
  final String? dateOfBirth;
  final String? gender;
  final String? image;

  const MahasiswaEntity({
    this.nim,
    this.name,
    this.asal,
    this.email,
    this.phoneNumber,
    this.fakultas,
    this.jurusan,
    this.dateOfBirth,
    this.gender,
    this.image,
  });

  @override
  List<Object?> get props {
    return [
      nim,
      name,
      asal,
      email,
      phoneNumber,
      fakultas,
      jurusan,
      dateOfBirth,
      gender,
      image,
    ];
  }
}
