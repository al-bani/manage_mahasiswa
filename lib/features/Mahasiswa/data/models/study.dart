class StudyModel {
  final String nama;
  final List<String> prodi;

  StudyModel({required this.nama, required this.prodi});

  factory StudyModel.fromJson(Map<String, dynamic> json) {
    return StudyModel(
      nama: json['nama'],
      prodi: List<String>.from(json['prodi']),
    );
  }
}

class StudyData {
  final List<StudyModel> fakultas;

  StudyData({required this.fakultas});

  factory StudyData.fromJson(Map<String, dynamic> json) {
    var list = json['fakultas'] as List;
    List<StudyModel> fakultasList =
        list.map((i) => StudyModel.fromJson(i)).toList();
    return StudyData(fakultas: fakultasList);
  }
}
