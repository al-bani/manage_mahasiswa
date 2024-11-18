import 'package:bloc/bloc.dart';
import 'package:manage_mahasiswa/core/resources/data_local.dart';
import 'package:manage_mahasiswa/core/resources/data_state.dart';
import 'package:manage_mahasiswa/features/Auth/domain/entities/admin_entity.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/usecases/delete_mahasiswa.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/usecases/get_mahasiswa_all.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/usecases/get_mahasiswa_detail.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_event.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_state.dart';

class MahasiswaBloc extends Bloc<MahasiswaEvent, MahasiswaState> {
  final GetMahasiswaAllUseCase _getMhsAllUsecase;
  final GetMahasiswaDetailUseCase _getMhsDetailUsecase;

  MahasiswaBloc(this._getMhsAllUsecase, this._getMhsDetailUsecase,
      DeleteMahasiswaUseCase deleteMahasiswaUseCase)
      : super(const RemoteMahasiswaInitial()) {
    on<GetAllMahasiswaEvent>(onGetAllMahasiswa);
    on<GetMahasiswaEvent>(onGetMahasiswa);
  }

  int page = 1;
  void onGetAllMahasiswa(
      GetAllMahasiswaEvent event, Emitter<MahasiswaState> emit) async {
    if (state is RemoteMahasiswaGetList) return;
    final currentState = state;

    var dataMhsOld = <MahasiswaEntity>[];
    if (currentState is RemoteMahasiswaDoneList) {
      dataMhsOld = currentState.mahasiswa;
    }

    emit(RemoteMahasiswaGetList(
        dataOldmahasiswa: dataMhsOld, isFirstFetch: page == 1));

    AdminEntity? data = await getAdminData();

    final dataState = await _getMhsAllUsecase.execute(
        data!.token!, data.id!, event.isFirstPage);

    if (dataState is DataFailed) {
      emit(RemoteMahasiswaError(dataState.error!));
    } else if (dataState is DataSuccess) {
      final mahasiswa = (state as RemoteMahasiswaGetList).dataOldmahasiswa;
      mahasiswa.addAll(dataState.data!);
      final hasMoreData = dataState.data!.isNotEmpty;

      emit(RemoteMahasiswaDoneList(mahasiswa: mahasiswa, hasMoreData: hasMoreData));
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
