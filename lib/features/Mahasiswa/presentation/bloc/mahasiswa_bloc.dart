import 'package:bloc/bloc.dart';
import 'package:manage_mahasiswa/core/resources/data_local.dart';
import 'package:manage_mahasiswa/core/resources/data_state.dart';
import 'package:manage_mahasiswa/features/Auth/domain/entities/admin_entity.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/usecases/create_mahasiswa.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/usecases/dashboard_mahasiswa.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/usecases/delete_mahasiswa.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/usecases/filter_mahasiswa.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/usecases/get_mahasiswa_all.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/usecases/get_mahasiswa_detail.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/usecases/search_mahasiswa.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/usecases/update_mahasiswa.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_event.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_state.dart';

class MahasiswaBloc extends Bloc<MahasiswaEvent, MahasiswaState> {
  final GetMahasiswaAllUseCase _getMhsAllUsecase;
  final GetMahasiswaDetailUseCase _getMhsDetailUsecase;
  final DeleteMahasiswaUseCase _deleteMahasiswaUseCase;
  final CreateMahasiswaUseCase _createMahasiswaUseCase;
  final UpdateMahasiswaUseCase _updateMahasiswaUseCase;
  final SearchMahasiswaUseCase _searchMahasiswaUseCase;
  final FilterMahasiswaUseCase _filterMahasiswaUseCase;
  final DashboardMahasiswaUseCase _dashboardMahasiswaUseCase;

  MahasiswaBloc(
    this._getMhsAllUsecase,
    this._getMhsDetailUsecase,
    this._deleteMahasiswaUseCase,
    this._createMahasiswaUseCase,
    this._updateMahasiswaUseCase,
    this._searchMahasiswaUseCase,
    this._filterMahasiswaUseCase,
    this._dashboardMahasiswaUseCase,
  ) : super(const RemoteMahasiswaInitial()) {
    on<GetAllMahasiswaEvent>(onGetAllMahasiswa);
    on<GetMahasiswaEvent>(onGetMahasiswa);
    on<DeleteMahasiswaEvent>(onDeleteMahasiswa);
    on<CreateMahasiswaEvent>(onCreateMahasiswa);
    on<UpdateMahasiswaEvent>(onUpdateMahasiswa);
    on<SearchMahasiswaEvent>(onSearchMahasiswa);
    on<FilterMahasiswaEvent>(onFilterMahasiswa);
    on<DashboardMahasiswaEvent>(onDashboardMahasiswa);
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

      emit(RemoteMahasiswaDoneList(
          mahasiswa: mahasiswa, hasMoreData: hasMoreData));
    }
  }

  void onFilterMahasiswa(
      FilterMahasiswaEvent event, Emitter<MahasiswaState> emit) async {
    AdminEntity? data = await getAdminData();
    final dataState = await _filterMahasiswaUseCase.execute(
        data!.token!, data.id!, event.filter);

    if (dataState is DataFailed) {
      emit(RemoteMahasiswaError(dataState.error!));
    } else if (dataState is DataSuccess) {
      emit(RemoteMahasiswaFilterGetList(mahasiswa: dataState.data!));
    }
  }

  void onSearchMahasiswa(
      SearchMahasiswaEvent event, Emitter<MahasiswaState> emit) async {
    AdminEntity? data = await getAdminData();
    final dataState = await _searchMahasiswaUseCase.execute(
        data!.token!, data.id!, event.search);

    if (dataState is DataFailed) {
      emit(RemoteMahasiswaError(dataState.error!));
    } else {
      emit(RemoteSearchMahasiswaGetList(mahasiswa: dataState.data!));
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

  void onDeleteMahasiswa(
      DeleteMahasiswaEvent event, Emitter<MahasiswaState> emit) async {
    AdminEntity? data = await getAdminData();
    final dataState = await _deleteMahasiswaUseCase.execute(
        data!.token!, data.id!, event.nim);

    if (dataState is DataSuccess) {
      emit(const RemoteMahasiswaDelete(status: true));
    } else if (dataState is DataFailed) {
      emit(const RemoteMahasiswaDelete(status: false));
    }
  }

  void onCreateMahasiswa(
      CreateMahasiswaEvent event, Emitter<MahasiswaState> emit) async {
    emit(const RemoteMahasiswaLoading());
    AdminEntity? data = await getAdminData();

    final dataState = await _createMahasiswaUseCase.execute(
        event.mhs, data!.token!, data.id!);

    print(dataState);

    if (dataState is DataSuccess) {
      emit(RemoteMahasiswaCreate(event.mhs));
    } else if (dataState is DataFailed) {
      emit(RemoteMahasiswaError(dataState.error!));
    }
  }

  void onUpdateMahasiswa(
      UpdateMahasiswaEvent event, Emitter<MahasiswaState> emit) async {
    emit(const RemoteMahasiswaLoading());
    AdminEntity? data = await getAdminData();

    final dataState = await _updateMahasiswaUseCase.execute(
        event.mhs, data!.token!, data.id!, event.nim);

    if (dataState is DataSuccess) {
      emit(RemoteMahasiswaUpdate(event.mhs));
      emit(RemoteMahasiswaDone(mahasiswa: event.mhs));
    } else if (dataState is DataFailed) {
      emit(RemoteMahasiswaError(dataState.error!));
    }
  }

  void onDashboardMahasiswa(
      DashboardMahasiswaEvent event, Emitter<MahasiswaState> emit) async {
    emit(const RemoteMahasiswaLoading());
    final dataState = await _dashboardMahasiswaUseCase.execute();

    if (dataState is DataFailed) {
      emit(RemoteMahasiswaError(dataState.error!));
    } else if (dataState is DataSuccess) {
      emit(RemoteDashboardMahasiswa(data: dataState.data!));
    }
  }
}
