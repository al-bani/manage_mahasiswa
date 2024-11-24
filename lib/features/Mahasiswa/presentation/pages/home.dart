import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_bloc.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_event.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_state.dart';
import 'package:manage_mahasiswa/injection_container.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final scrollController = ScrollController();

  void setupScrollController(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          context.read<MahasiswaBloc>().add(GetAllMahasiswaEvent(false));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => containerInjection<MahasiswaBloc>()
          ..add(GetAllMahasiswaEvent(true)),
        child: BlocBuilder<MahasiswaBloc, MahasiswaState>(
          builder: (context, state) {
            setupScrollController(context);
            return _bodyApp(scrollController, state, context);
          },
        ),
      ),
    );
  }
}

Widget _bodyApp(
    ScrollController scrollController, MahasiswaState state, context) {
  TextEditingController searchController = TextEditingController();

  return Container(
    margin: const EdgeInsets.all(20),
    child: Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.filter_list_outlined),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 40,
                child: SearchBar(
                  onTap: () => GoRouter.of(context).goNamed('search'),
                  controller: searchController,
                  elevation: WidgetStateProperty.all(0), // Hilangkan bayangan
                  trailing: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(child: _listMhs(scrollController, state)),
      ],
    ),
  );
}

Widget _listMhs(ScrollController scrollController, MahasiswaState state) {
  List<MahasiswaEntity> mahasiswa = [];
  bool isLoading = false;
  bool hasMoreData = true;

  if (state is RemoteMahasiswaGetList) {
    mahasiswa = state.dataOldmahasiswa;
    isLoading = true;
  } else if (state is RemoteMahasiswaDoneList) {
    mahasiswa = state.mahasiswa;
    hasMoreData = state.hasMoreData;
  } else if (state is RemoteMahasiswaError) {
    return const Text("Something went Error");
  } else if (hasMoreData) {
    return const Center(child: CircularProgressIndicator());
  }

  return ListView.separated(
    controller: scrollController,
    itemBuilder: (context, index) {
      if (index < mahasiswa.length) {
        return _dataMahasiswa(mahasiswa[index], context);
      } else {
        Timer(const Duration(milliseconds: 30), () {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        });
        return const SizedBox();
      }
    },
    separatorBuilder: (context, index) {
      return const SizedBox();
    },
    itemCount: mahasiswa.length + (isLoading && hasMoreData ? 1 : 0),
  );
}

Widget _dataMahasiswa(mahasiswa, BuildContext context) {
  return InkWell(
    onTap: () => GoRouter.of(context).goNamed('detail', extra: mahasiswa.nim),
    child: ListTile(
      title: Text(mahasiswa.name ?? 'No Name'),
      subtitle: Text(mahasiswa.nim.toString()),
    ),
  );
}
