import 'package:equatable/equatable.dart';

class MahasiswaEntity extends Equatable {
  final int? nim;
  final String? name;
  final String? asal;
  final String? email;
  final String? phoneNumber;
  final String? fakultas;
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
      dateOfBirth,
      gender,
      image,
    ];
  }
}
