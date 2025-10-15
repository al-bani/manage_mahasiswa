import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/widgets/components.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_bloc.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_event.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_state.dart';
import 'package:manage_mahasiswa/injection_container.dart';

class DetailScreen extends StatelessWidget {
  final int nim;
  const DetailScreen(this.nim, {super.key});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id_ID', null);

    return Scaffold(
      body: BlocProvider(
        create: (_) =>
            containerInjection<MahasiswaBloc>()..add(GetMahasiswaEvent(nim)),
        child: _bodyApp(),
      ),
    );
  }
}

Widget _bodyApp() {
  return BlocBuilder<MahasiswaBloc, MahasiswaState>(
    builder: (context, state) {
      if (state is RemoteMahasiswaLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is RemoteMahasiswaError) {
        return Center(child: Text("Error: ${state.error!["msg"]}"));
      } else if (state is RemoteMahasiswaDone) {
        MahasiswaEntity mhs = state.mahasiswa;

        String gender = mhs.gender == 'L' ? "Pria" : "Perempuan";

        DateTime dateTime = DateTime.parse(mhs.birth!);
        String birthDate = DateFormat('d MMMM y', 'id_ID').format(dateTime);

        return BlocListener<MahasiswaBloc, MahasiswaState>(
          listener: (context, state) {
            if (state is RemoteMahasiswaDelete) {
              if (state.status == true) {
                _deleteSuccess(context, mhs.name!);
              } else if (state.status == false) {
                _deleteFailed(context, mhs.name!, mhs.nim!);
              }
            }
          },
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      'https://m.media-amazon.com/images/I/51CsP9BEYQL._UXNaN_FMjpg_QL85_.jpg',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Txt(
                    value: "Name : ${mhs.name}",
                    size: 12,
                    align: TextAlign.left),
                const SizedBox(height: 5),
                Txt(value: "NIM : ${mhs.nim}", size: 12, align: TextAlign.left),
                const SizedBox(height: 5),
                Txt(
                    value: "Email : ${mhs.email}",
                    size: 12,
                    align: TextAlign.left),
                const SizedBox(height: 5),
                Txt(value: "Gender : $gender", size: 12, align: TextAlign.left),
                const SizedBox(height: 5),
                Txt(
                    value: "Phone Number : ${mhs.phoneNumber}",
                    size: 12,
                    align: TextAlign.left),
                const SizedBox(height: 5),
                Txt(
                    value: "Asal : ${mhs.city}",
                    size: 12,
                    align: TextAlign.left),
                const SizedBox(height: 5),
                Txt(
                    value: "Tanggal Lahir : $birthDate",
                    size: 12,
                    align: TextAlign.left),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => GoRouter.of(context).pop(),
                      style: BtnStyle,
                      child: const Text("Back"),
                    ),
                    const SizedBox(width: 15),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              _validation(context, mhs.name!, mhs.nim!),
                          style: BtnStyle,
                          child: const Text("Delete"),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await GoRouter.of(context)
                                .pushNamed('update', extra: mhs.nim!);
                            if (result == true) {
                              // abaikan jika bloc sudah loading.
                              context
                                  .read<MahasiswaBloc>()
                                  .add(GetMahasiswaEvent(mhs.nim!));
                            }
                          },
                          style: BtnStyle,
                          child: const Text("Update"),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }
      return const Center(child: Text("No Data"));
    },
  );
}

_validation(BuildContext mainContext, String name, int nim) {
  return showDialog(
    context: mainContext,
    builder: (BuildContext dialogContext) {
      // Membungkus dialog dengan BlocProvider.value agar tetap memiliki akses ke MahasiswaBloc
      return AlertDialog(
        title: const Txt(
          value: "Information",
          size: 18,
          align: TextAlign.left,
        ),
        content: Txt(
          value: "Are you sure want to delete $name?",
          size: 14,
          align: TextAlign.left,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, 'Cancel'),
            child: const Txt(
              value: "Cancel",
              size: 16,
              align: TextAlign.center,
            ),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<MahasiswaBloc>(mainContext).add(
                DeleteMahasiswaEvent(nim),
              );
              Navigator.pop(dialogContext, 'Agree');
            },
            child: const Txt(
              value: "Agree",
              size: 16,
              align: TextAlign.center,
            ),
          ),
        ],
      );
    },
  );
}

_deleteSuccess(BuildContext context, String name) {
  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) => AlertDialog(
      title: const Txt(
        value: "Information",
        size: 18,
        align: TextAlign.left,
      ),
      content: Txt(
        value: "$name has been deleted",
        size: 14,
        align: TextAlign.left,
      ),
      actions: [
        TextButton(
          onPressed: () {
            GoRouter.of(dialogContext).goNamed('home');
            Navigator.pop(dialogContext, 'OK');
          },
          child: const Txt(
            value: "OK",
            size: 16,
            align: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

_deleteFailed(BuildContext context, String name, int nim) {
  // Ambil instance MahasiswaBloc dari context utama
  final mahasiswaBloc = BlocProvider.of<MahasiswaBloc>(context);

  return showDialog(
    context: context,
    builder: (BuildContext deleteContext) => BlocProvider.value(
      value: mahasiswaBloc, // Pastikan MahasiswaBloc tersedia dalam dialog
      child: AlertDialog(
        title: const Txt(
          value: "Information",
          size: 18,
          align: TextAlign.left,
        ),
        content: Txt(
          value: "Error while deleting $name",
          size: 14,
          align: TextAlign.left,
        ),
        actions: [
          TextButton(
            onPressed: () {
              mahasiswaBloc.add(GetMahasiswaEvent(nim));
              Navigator.pop(deleteContext, 'OK'); // Tutup dialog
            },
            child: const Txt(
              value: "OK",
              size: 16,
              align: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
  );
}
