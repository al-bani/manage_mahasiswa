import 'package:bloc/bloc.dart';
import 'package:manage_mahasiswa/core/resources/data_local.dart';
import 'package:manage_mahasiswa/core/resources/data_state.dart';
import 'package:manage_mahasiswa/features/Auth/domain/entities/admin_entity.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/usecases/get_mahasiswa_all.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_event.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_state.dart';

class MahasiswaBloc extends Bloc<MahasiswaEvent, MahasiswaState> {
  int perPage = 25;
  final GetMahasiswaAllUseCase _getMhsAllUsecase;

  MahasiswaBloc(this._getMhsAllUsecase)
      : super(const RemoteMahasiswaInitial()) {
    on<GetAllMahasiswaEvent>(onGetAllMahasiswa);
  }

  void onGetAllMahasiswa(
      GetAllMahasiswaEvent event, Emitter<MahasiswaState> emit) async {
    List<MahasiswaEntity> existingData = [];

    // Simpan data mahasiswa sebelumnya jika state sudah memuat data
    if (state is RemoteMahasiswaDone) {
      existingData = (state as RemoteMahasiswaDone).mahasiswa;
    }

    // Jangan emit data dengan hasMoreData: true sebelum cek data baru
    emit(RemoteMahasiswaLoading());

    AdminEntity? data = await getAdminData();

    // Mendapatkan data baru dari server
    final dataState = await _getMhsAllUsecase.execute(
        data!.token!, data.id!, event.isFirstPage);

    if (dataState is DataFailed) {
      emit(RemoteMahasiswaError(dataState.error!));
    } else if (dataState is DataSuccess) {
      List<MahasiswaEntity> updatedData = existingData + dataState.data!;

      // Emit data baru, pastikan hanya menambah ketika ada data baru
      emit(RemoteMahasiswaDone(
        mahasiswa: updatedData,
        hasMoreData: dataState.data!.length == perPage,
      ));
    }
  }
}
