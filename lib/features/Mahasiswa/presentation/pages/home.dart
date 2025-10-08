import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_bloc.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_event.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_state.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/widgets/bottom_bar.dart';
import 'package:manage_mahasiswa/injection_container.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/pages/home_filter.dart';

class HomeScreen extends StatefulWidget {
  final String search;
  const HomeScreen(this.search, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();
  bool searchMode = false;
  bool filterMode = false;
  Map<String, dynamic> filter = {};
  late final MahasiswaBloc bloc;
  // State pilihan filter yang dipersist
  Map<String, bool> facultyOptions = const {
    "Ekonomi": false,
    "Teknik": false,
    "Kedokteran": false,
    "Hukum": false,
    "Ilmu Komunikasi": false,
    "Sastra": false,
    "teknik": false,
    "Ilmu Sosial": false,
  };
  Map<String, bool> majorOptions = const {
    "Antropologi": false,
    "Mesin": false,
    "Industri": false,
    "Farmasi": false,
    "informatika": false,
    "Public Relations": false,
    "Kedokteran Umum": false,
    "Bahasa Prancis": false,
    "Informatika": false,
    "Sosiologi": false,
    "Akuntansi": false,
    "Elektro": false,
    "Bisnis": false,
    "Sipil": false,
    "Jurnalistik": false,
    "Ilmu Hukum": false,
    "Kedokteran Gigi": false,
    "Manajemen": false,
    "Bahasa Inggris": false,
    "Kimia": false,
  };
  Map<String, bool> cityOptions = const {
    "Jakarta": false,
    "Bandung": false,
    "Surabaya": false,
    "Yogyakarta": false,
    "Medan": false,
    "Semarang": false,
    "Makassar": false,
  };
  String selectedOrder = "A-Z (NIM)";
  bool orderSwitch = false;

  void setupScrollController() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          if (!searchMode && !filterMode) {
            bloc.add(GetAllMahasiswaEvent(false));
          }
        }
      }
    });
  }

  void setSearchMode(bool value) {
    setState(() {
      searchMode = value;
    });
  }

  void setFilterMode(
      bool value, Map<String, dynamic> newFilter, MahasiswaBloc bloc) {
    setState(() {
      filterMode = value;
      filter = newFilter;
      Navigator.pop(context);
    });

    bloc.add(FilterMahasiswaEvent(newFilter));
  }

  @override
  void initState() {
    super.initState();
    bloc = containerInjection<MahasiswaBloc>();
    if (widget.search.isNotEmpty) {
      searchMode = true;
      bloc.add(SearchMahasiswaEvent(widget.search));
    } else {
      bloc.add(GetAllMahasiswaEvent(true));
    }
    setupScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: BlocProvider.value(
        value: bloc,
        child: BlocBuilder<MahasiswaBloc, MahasiswaState>(
          builder: (context, state) {
            return _bodyApp(scrollController, state, context, searchMode, bloc,
                setSearchMode);
          },
        ),
      ),
    );
  }

  Widget _bodyApp(ScrollController scrollController, MahasiswaState state,
      context, bool searchMode, bloc, Function(bool) setSearchMode) {
    TextEditingController searchController = TextEditingController();

    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => _showFilter(context),
                icon: Icon(
                  Icons.filter_list_outlined,
                  color: filterMode ? Colors.blue : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: SearchBar(
                    onTap: () => GoRouter.of(context).goNamed('search'),
                    controller: searchController,
                    elevation: WidgetStateProperty.all(0),
                    trailing: <Widget>[
                      if (searchMode)
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            bloc.add(GetAllMahasiswaEvent(true));
                            setSearchMode(false);
                          },
                        )
                      else
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () =>
                              GoRouter.of(context).goNamed('search'),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () => GoRouter.of(context).goNamed('create'),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(child: _listMhs(scrollController, state, searchMode)),
        ],
      ),
    );
  }

  Widget _listMhs(
      ScrollController scrollController, MahasiswaState state, searchMode) {
    List<MahasiswaEntity> mahasiswa = [];
    bool isLoading = false;
    bool hasMoreData = true;

    if (state is RemoteMahasiswaGetList) {
      mahasiswa = state.dataOldmahasiswa;
      isLoading = true;
    } else if (state is RemoteSearchMahasiswaGetList) {
      mahasiswa = state.mahasiswa;
    } else if (state is RemoteMahasiswaFilterGetList) {
      mahasiswa = state.mahasiswa;
    } else if (state is RemoteMahasiswaDoneList) {
      mahasiswa = state.mahasiswa;
      hasMoreData = state.hasMoreData;
    } else if (state is RemoteMahasiswaError) {
      return Text(state.error?["msg"] ?? "Terjadi kesalahan");
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
      onTap: () =>
          GoRouter.of(context).pushNamed('detail', extra: mahasiswa.nim),
      child: ListTile(
        title: Text(mahasiswa.name ?? 'No Name'),
        subtitle: Text(mahasiswa.nim.toString()),
      ),
    );
  }

  void _showFilter(BuildContext context) {
    final bloc = context.read<MahasiswaBloc>();
    showFilterModal(
      context,
      setFilterMode,
      bloc,
      initialFacultyOptions: facultyOptions,
      initialMajorOptions: majorOptions,
      initialCityOptions: cityOptions,
      initialSelectedOrder: selectedOrder,
      initialOrderSwitch: orderSwitch,
      onPersistOptions: (
        Map<String, bool> newFaculty,
        Map<String, bool> newMajor,
        Map<String, bool> newCity,
        String newSelectedOrder,
        bool newOrderSwitch,
      ) {
        setState(() {
          facultyOptions = newFaculty;
          majorOptions = newMajor;
          cityOptions = newCity;
          selectedOrder = newSelectedOrder;
          orderSwitch = newOrderSwitch;
        });
      },
    );
  }
}
