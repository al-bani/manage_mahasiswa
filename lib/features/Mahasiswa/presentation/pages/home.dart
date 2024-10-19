import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_bloc.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_event.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_state.dart';
import 'package:manage_mahasiswa/injection_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => containerInjection<MahasiswaBloc>()
          ..add(GetAllMahasiswaEvent(true, [])),
        child: _bodyApp(),
      ),
    );
  }
}

Widget _bodyApp() {
  TextEditingController searchController = TextEditingController();

  return Container(
    margin: const EdgeInsets.all(20),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  labelText: "Search",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(child: _listMhs()),
      ],
    ),
  );
}

Widget _listMhs() {
  return BlocBuilder<MahasiswaBloc, MahasiswaState>(
    builder: (context, state) {
      if (state is RemoteMahasiswaLoading && state is! RemoteMahasiswaDone) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is RemoteMahasiswaError) {
        return Center(child: Text("Error: ${state.error!["msg"]}"));
      } else if (state is RemoteMahasiswaDone) {
        List<MahasiswaEntity>? allMahasiswa = state.mahasiswa;
        if (allMahasiswa.isEmpty) {
          return const Center(child: Text("No data available"));
        }

        ScrollController _scrollController = ScrollController();

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent &&
                state.hasMoreData) {
              context
                  .read<MahasiswaBloc>()
                  .add(GetAllMahasiswaEvent(false, allMahasiswa));
              return true;
            }
            return false;
          },
          child: ListView.builder(
            controller: _scrollController,
            itemCount: allMahasiswa.length + (state.hasMoreData ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == allMahasiswa.length && state.hasMoreData) {
                return const Center(child: CircularProgressIndicator());
              }
              final mahasiswa = allMahasiswa[index];
              return ListTile(
                title: Text(mahasiswa.name ?? 'No Name'),
                subtitle: Text(mahasiswa.nim.toString()),
              );
            },
          ),
        );
      }
      return const Center(child: Text("No Data"));
    },
  );
}
