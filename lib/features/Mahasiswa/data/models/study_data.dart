class StudyData {
  final String nama;
  final List<String> prodi;

  StudyData({
    required this.nama,
    required this.prodi,
  });

  factory StudyData.fromJson(Map<String, dynamic> json) {
    return StudyData(
      nama: json['nama'],
      prodi: List<String>.from(json['prodi']),
    );
  }
}

class StudyResponse {
  final List<StudyData> fakultas;

  StudyResponse({
    required this.fakultas,
  });

  factory StudyResponse.fromJson(Map<String, dynamic> json) {
    return StudyResponse(
      fakultas: (json['fakultas'] as List)
          .map((item) => StudyData.fromJson(item))
          .toList(),
    );
  }
}
