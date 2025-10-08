import 'package:get_it/get_it.dart';
import 'package:manage_mahasiswa/features/Auth/data/datasources/admin_api_service.dart';
import 'package:manage_mahasiswa/features/Auth/data/repositories/admin_repository_impl.dart';
import 'package:manage_mahasiswa/features/Auth/domain/repositories/admin_repository.dart';
import 'package:manage_mahasiswa/features/Auth/domain/usecases/login_usecase.dart';
import 'package:manage_mahasiswa/features/Auth/domain/usecases/register_usecase.dart';
import 'package:manage_mahasiswa/features/Auth/domain/usecases/otp_usecase.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/bloc/auth_bloc.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/data/datasources/mahasiswa_api_service.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/data/repositories/mahasiswa_repository_impl.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/repositories/mahasiswa_repository.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/usecases/create_mahasiswa.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/usecases/dashboard_mahasiswa.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/usecases/delete_mahasiswa.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/usecases/filter_mahasiswa.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/usecases/get_mahasiswa_all.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/usecases/get_mahasiswa_detail.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/usecases/search_mahasiswa.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/usecases/update_mahasiswa.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_bloc.dart';

var containerInjection = GetIt.instance;

Future<void> init() async {
  containerInjection.registerLazySingleton<MahasiswaApiService>(
      () => MahasiswaApiServiceImpl());
  containerInjection.registerLazySingleton<MahasiswaRepository>(
      () => MahasiswaRepositoryImpl(containerInjection()));
  containerInjection.registerLazySingleton(
      () => GetMahasiswaAllUseCase(containerInjection()));
  containerInjection.registerLazySingleton(
      () => GetMahasiswaDetailUseCase(containerInjection()));
  containerInjection.registerLazySingleton(
      () => DeleteMahasiswaUseCase(containerInjection()));
  containerInjection.registerLazySingleton(
      () => CreateMahasiswaUseCase(containerInjection()));
  containerInjection.registerLazySingleton(
      () => UpdateMahasiswaUseCase(containerInjection()));
  containerInjection.registerLazySingleton(
      () => SearchMahasiswaUseCase(containerInjection()));
  containerInjection.registerLazySingleton(
      () => FilterMahasiswaUseCase(containerInjection()));
  containerInjection.registerLazySingleton(
      () => DashboardMahasiswaUseCase(containerInjection()));
  containerInjection.registerFactory(() => MahasiswaBloc(
        containerInjection<GetMahasiswaAllUseCase>(),
        containerInjection<GetMahasiswaDetailUseCase>(),
        containerInjection<DeleteMahasiswaUseCase>(),
        containerInjection<CreateMahasiswaUseCase>(),
        containerInjection<UpdateMahasiswaUseCase>(),
        containerInjection<SearchMahasiswaUseCase>(),
        containerInjection<FilterMahasiswaUseCase>(),
        containerInjection<DashboardMahasiswaUseCase>(),
      ));

  //admin
  containerInjection
      .registerLazySingleton<AdminApiService>(() => AdminApiServiceImpl());
  containerInjection.registerLazySingleton<AdminRepository>(
      () => AdminRepositoryImpl(containerInjection()));
  containerInjection
      .registerLazySingleton(() => LoginUseCase(containerInjection()));
  containerInjection
      .registerLazySingleton(() => RegisterUsecase(containerInjection()));
  containerInjection
      .registerLazySingleton(() => OtpUsecase(containerInjection()));
  containerInjection.registerFactory(() => AuthBloc(
        containerInjection<LoginUseCase>(),
        containerInjection<RegisterUsecase>(),
        containerInjection<OtpUsecase>(),
      ));
}
