import 'package:bloc/bloc.dart';
import 'package:manage_mahasiswa/core/resources/data_local.dart';
import 'package:manage_mahasiswa/core/resources/data_state.dart';
import 'package:manage_mahasiswa/features/Auth/domain/entities/admin_entity.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/usecases/get_mahasiswa_all.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/usecases/get_mahasiswa_detail.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_event.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_state.dart';

class MahasiswaBloc extends Bloc<MahasiswaEvent, MahasiswaState> {
  int perPage = 25;
  final GetMahasiswaAllUseCase _getMhsAllUsecase;
  final GetMahasiswaDetailUseCase _getMhsDetailUsecase;

  MahasiswaBloc(this._getMhsAllUsecase, this._getMhsDetailUsecase)
      : super(const RemoteMahasiswaInitial()) {
    on<GetAllMahasiswaEvent>(onGetAllMahasiswa);
    on<GetMahasiswaEvent>(onGetMahasiswa);
  }

  void onGetAllMahasiswa(
      GetAllMahasiswaEvent event, Emitter<MahasiswaState> emit) async {
    List<MahasiswaEntity> existingData = [];

    // Simpan data mahasiswa sebelumnya jika state sudah memuat data
    if (state is RemoteMahasiswaDoneList) {
      existingData = (state as RemoteMahasiswaDoneList).mahasiswa;
    }

    // Jangan emit data dengan hasMoreData: true sebelum cek data baru
    emit(const RemoteMahasiswaLoading());

    AdminEntity? data = await getAdminData();

    // Mendapatkan data baru dari server
    final dataState = await _getMhsAllUsecase.execute(
        data!.token!, data.id!, event.isFirstPage);

    if (dataState is DataFailed) {
      emit(RemoteMahasiswaError(dataState.error!));
    } else if (dataState is DataSuccess) {
      List<MahasiswaEntity> updatedData = existingData + dataState.data!;

      // Emit data baru, pastikan hanya menambah ketika ada data baru
      emit(RemoteMahasiswaDoneList(
        mahasiswa: updatedData,
        hasMoreData: dataState.data!.length == perPage,
      ));
    }
  }

  void onGetMahasiswa(
      GetMahasiswaEvent event, Emitter<MahasiswaState> emit) async {
    emit(const RemoteMahasiswaLoading());
    AdminEntity? data = await getAdminData();

    final dataState =
        await _getMhsDetailUsecase.execute(data!.token!, data.id!, event.nim);

    if (dataState is DataFailed) {
      emit(RemoteMahasiswaError(dataState.error!));
    } else {
      emit(RemoteMahasiswaDone(mahasiswa: dataState.data!));
    }
  }
}
