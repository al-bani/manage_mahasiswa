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
        child: _bodyApp(context),
      ),
    );
  }
}

Widget _bodyApp(BuildContext context) {
  return BlocBuilder<MahasiswaBloc, MahasiswaState>(
    builder: (contect, state) {
      if (state is RemoteMahasiswaLoading &&
          state is! RemoteMahasiswaDoneList) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is RemoteMahasiswaError) {
        return Center(child: Text("Error: ${state.error!["msg"]}"));
      } else if (state is RemoteMahasiswaDone) {
        MahasiswaEntity mhs = state.mahasiswa;

        String gender = "Perempuan";

        if (mhs.gender == 'L') {
          gender = "Pria";
        }

        DateTime dateTime = DateTime.parse(mhs.dateOfBirth!);
        String birthDate = DateFormat('d MMMM y', 'id_ID').format(dateTime);

        return Container(
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
              Txt(value: "Name : ${mhs.name}", size: 12, align: TextAlign.left),
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
              Txt(value: "Asal : ${mhs.asal}", size: 12, align: TextAlign.left),
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
                    onPressed: () => GoRouter.of(context).goNamed('home'),
                    style: BtnStyle,
                    child: const Text("Back"),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {},
                    style: BtnStyle,
                    child: const Text("update"),
                  ),
                ],
              )
            ],
          ),
        );
      }

      return const Center(child: Text("No Data"));
    },
  );
}
