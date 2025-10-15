import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/study_data.dart';

class StudyService {
  static Future<StudyResponse> loadStudyData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/study.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      return StudyResponse.fromJson(jsonData);
    } catch (e) {
      throw Exception('Failed to load study data: $e');
    }
  }

  static List<String> getFaculties(StudyResponse studyResponse) {
    return studyResponse.fakultas.map((f) => f.nama).toList();
  }

  static List<String> getMajorsByFaculty(
      StudyResponse studyResponse, String facultyName) {
    final faculty = studyResponse.fakultas.firstWhere(
      (f) => f.nama == facultyName,
      orElse: () => StudyData(nama: '', prodi: []),
    );
    return faculty.prodi;
  }

  static List<String> getAllMajors(StudyResponse studyResponse) {
    List<String> allMajors = [];
    for (var faculty in studyResponse.fakultas) {
      allMajors.addAll(faculty.prodi);
    }
    return allMajors;
  }
}
