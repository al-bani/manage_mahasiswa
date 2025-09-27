import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';

abstract class MahasiswaEvent {
  const MahasiswaEvent();
}

class GetAllMahasiswaEvent extends MahasiswaEvent {
  final bool isFirstPage;

  GetAllMahasiswaEvent(this.isFirstPage);
}

class SearchMahasiswaEvent extends MahasiswaEvent {
  final String search;

  SearchMahasiswaEvent(this.search);

  List<Object?> get props => [];
}

class GetMahasiswaEvent extends MahasiswaEvent {
  final int nim;

  GetMahasiswaEvent(this.nim);

  List<Object?> get props => [];
}

class DeleteMahasiswaEvent extends MahasiswaEvent {
  final int nim;

  DeleteMahasiswaEvent(this.nim);
}

class CreateMahasiswaEvent extends MahasiswaEvent {
  final MahasiswaEntity mhs;

  CreateMahasiswaEvent(this.mhs);
}

class UpdateMahasiswaEvent extends MahasiswaEvent {
  final MahasiswaEntity mhs;
  final int nim;

  UpdateMahasiswaEvent(this.mhs, this.nim);
}
