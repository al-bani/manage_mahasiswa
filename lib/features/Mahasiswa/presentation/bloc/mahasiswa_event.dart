import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';

abstract class MahasiswaEvent {
  const MahasiswaEvent();
}

class GetAllMahasiswaEvent extends MahasiswaEvent {
  final bool isFirstPage;
  final List<MahasiswaEntity> mhsPagination;

  GetAllMahasiswaEvent(this.isFirstPage, this.mhsPagination);

  List<Object?> get props => [];
}

class GetMahasiswaEvent extends MahasiswaEvent {
  final int nim;

  GetMahasiswaEvent(this.nim);

  List<Object?> get props => [];
}
