import 'package:equatable/equatable.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';

abstract class MahasiswaState extends Equatable {
  final Map<String, dynamic>? error;
  final MahasiswaEntity? mhs;

  const MahasiswaState({this.error, this.mhs});

  @override
  List<Object?> get props => [];
}

class RemoteMahasiswaInitial extends MahasiswaState {
  const RemoteMahasiswaInitial();
}

class RemoteMahasiswaLoading extends MahasiswaState {
  const RemoteMahasiswaLoading();
}

class RemoteMahasiswaGetList extends MahasiswaState {
  final List<MahasiswaEntity> dataOldmahasiswa;
  final bool isFirstFetch;

  const RemoteMahasiswaGetList({
    required this.dataOldmahasiswa,
    this.isFirstFetch = false,
  });
}

class RemoteSearchMahasiswaGetList extends MahasiswaState {
  final List<MahasiswaEntity> mahasiswa;

  const RemoteSearchMahasiswaGetList({required this.mahasiswa});
}

class RemoteMahasiswaDoneList extends MahasiswaState {
  final List<MahasiswaEntity> mahasiswa;
  final bool hasMoreData;

  const RemoteMahasiswaDoneList(
      {required this.mahasiswa, required this.hasMoreData});
}

class RemoteMahasiswaDone extends MahasiswaState {
  final MahasiswaEntity mahasiswa;

  const RemoteMahasiswaDone({
    required this.mahasiswa,
  });

  @override
  List<Object?> get props => [mahasiswa];
}

class RemoteMahasiswaError extends MahasiswaState {
  const RemoteMahasiswaError(Map<String, dynamic> error) : super(error: error);

  @override
  List<Object?> get props => [error];
}

class RemoteMahasiswaDelete extends MahasiswaState {
  final bool status;

  const RemoteMahasiswaDelete({
    required this.status,
  });

  @override
  List<Object?> get props => [status];
}

class RemoteMahasiswaCreate extends MahasiswaState {
  const RemoteMahasiswaCreate(MahasiswaEntity mhs) : super(mhs: mhs);

  @override
  List<Object?> get props => [mhs];
}

class RemoteMahasiswaUpdate extends MahasiswaState {
  const RemoteMahasiswaUpdate(MahasiswaEntity mhs) : super(mhs: mhs);

  @override
  List<Object?> get props => [mhs];
}
