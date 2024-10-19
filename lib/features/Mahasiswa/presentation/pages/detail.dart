import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    builder: (contect, state) {
      if (state is RemoteMahasiswaLoading &&
          state is! RemoteMahasiswaDoneList) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is RemoteMahasiswaError) {
        return Center(child: Text("Error: ${state.error!["msg"]}"));
      } else if (state is RemoteMahasiswaDone) {
        MahasiswaEntity mhs = state.mahasiswa;

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
                    width: 200, // Atur lebar sesuai kebutuhan
                    height: 200, // Atur tinggi sesuai kebutuhan
                    fit: BoxFit.cover, // Atur cara gambar di-fit
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
              Txt(
                  value: "Gender : ${mhs.gender}",
                  size: 12,
                  align: TextAlign.left),
              const SizedBox(height: 5),
              Txt(
                  value: "Phone Number : ${mhs.phoneNumber}",
                  size: 12,
                  align: TextAlign.left),
              const SizedBox(height: 5),
              Txt(value: "Asal : ${mhs.asal}", size: 12, align: TextAlign.left),
              const SizedBox(height: 5),
              Txt(
                  value: "Tanggal Lahir : ${mhs.dateOfBirth}",
                  size: 12,
                  align: TextAlign.left),
              const SizedBox(height: 5),
            ],
          ),
        );
      }

      return const Center(child: Text("No Data"));
    },
  );
}
