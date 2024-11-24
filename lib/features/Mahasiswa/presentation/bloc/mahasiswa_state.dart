import 'package:equatable/equatable.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';

abstract class MahasiswaState extends Equatable {
  final Map<String, dynamic>? error;

  const MahasiswaState({this.error});

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
