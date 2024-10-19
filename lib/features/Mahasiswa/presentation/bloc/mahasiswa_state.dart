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

class RemoteMahasiswaDone extends MahasiswaState {
  final List<MahasiswaEntity> mahasiswa;
  final bool hasMoreData;

  const RemoteMahasiswaDone({
    required this.mahasiswa,
    required this.hasMoreData,
  });

  @override
  List<Object?> get props => [mahasiswa, hasMoreData];
}

class RemoteMahasiswaError extends MahasiswaState {
  const RemoteMahasiswaError(Map<String, dynamic> error) : super(error: error);

  @override
  List<Object?> get props => [error];
}
