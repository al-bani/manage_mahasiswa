abstract class MahasiswaEvent {
  const MahasiswaEvent();
}

class GetAllMahasiswaEvent extends MahasiswaEvent {
  final bool isFirstPage;

  GetAllMahasiswaEvent(this.isFirstPage);
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
