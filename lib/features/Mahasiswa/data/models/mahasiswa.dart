import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';

class MahasiswaModel extends MahasiswaEntity {
  const MahasiswaModel({
    super.nim,
    super.name,
    super.province,
    super.city,
    super.district,
    super.subdistrict,
    super.email,
    super.phoneNumber,
    super.fakultas,
    super.jurusan,
    super.birth,
    super.gender,
    super.image,
  });

  factory MahasiswaModel.fromJson(Map<String, dynamic> data) {
    return MahasiswaModel(
      nim: data['nim'] as int?,
      name: data['name'] as String?,
      province: data['province'] as String?,
      city: data['city'] as String?,
      district: data['district'] as String?,
      subdistrict: data['Subdistrict'] as String?,
      email: data['email'] as String?,
      phoneNumber: data['phone_number'] as String?,
      fakultas: data['fakultas'] as String?,
      jurusan: data['jurusan'] as String?,
      birth: data['date_of_birth'] as String?,
      gender: data['gender'] as String?,
      image: data['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nim': nim,
      'name': name,
      'province': province,
      'city': city,
      'district': district,
      'subdistrict': subdistrict,
      'email': email,
      'phone_number': phoneNumber,
      'fakultas': fakultas,
      'jurusan': jurusan,
      'birth': birth,
      'gender': gender,
      'image': image
    };
  }

  static List<MahasiswaModel> fromJsonList(List data) {
    if (data.isEmpty) return [];

    return data
        .map((singleDataMahasiswa) => MahasiswaModel.fromJson(
            singleDataMahasiswa as Map<String, dynamic>))
        .toList();
  }
}
