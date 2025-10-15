import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/widgets/components.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_bloc.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_event.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_state.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/widgets/bottom_bar.dart';
import 'package:manage_mahasiswa/injection_container.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/widgets/filter_bottomsheet.dart';

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
  bool _isClearing = false;
  late TextEditingController _searchController;
  String _currentHintText = "Search by Name and Nim";

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
    _searchController = TextEditingController(text: widget.search);

    // Set initial hint text
    _currentHintText =
        widget.search.isNotEmpty ? widget.search : "Search by Name and Nim";

    // Add listener for search functionality
    _searchController.addListener(() {
      if (_isClearing) return; // Skip listener when clearing programmatically

      final text = _searchController.text.trim();
      if (text.isEmpty && searchMode) {
        setSearchMode(false);
        setState(() {
          _currentHintText = "Search by Name and Nim";
        });
        bloc.add(GetAllMahasiswaEvent(true));
      } else if (text.isNotEmpty && !searchMode) {
        setSearchMode(true);
        bloc.add(SearchMahasiswaEvent(text));
      } else if (text.isNotEmpty && searchMode) {
        bloc.add(SearchMahasiswaEvent(text));
      }
    });

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
    _searchController.dispose();
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      backgroundColor: AppColors.white,
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => _showFilter(context),
                icon: Icon(
                  Icons.filter_list,
                  color: filterMode ? AppColors.secondary : AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: SearchBar(
                    onTap: searchMode
                        ? null
                        : () => GoRouter.of(context).goNamed('search'),
                    controller: _searchController,
                    elevation: WidgetStateProperty.all(0),
                    backgroundColor: WidgetStateProperty.all(AppColors.white),
                    hintText: _currentHintText,
                    hintStyle: WidgetStateProperty.all(
                      AppTextStyles.openSansItalic(fontSize: 14),
                    ),
                    // Mengatur border radius dan border line
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Border radius
                      ),
                    ),

                    side: WidgetStateProperty.all(
                      const BorderSide(
                        color: AppColors.primary, // Warna border
                        width: 1.0, // Ketebalan border
                      ),
                    ),

                    trailing: <Widget>[
                      if (searchMode)
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _isClearing = true;
                            _searchController.clear();
                            setSearchMode(false);
                            setState(() {
                              _currentHintText = "Search by Name and Nim";
                            });
                            bloc.add(GetAllMahasiswaEvent(true));
                            _isClearing = false;
                          },
                        )
                      else
                        IconButton(
                          icon: const Icon(Icons.search),
                          color: AppColors.primary,
                          onPressed: () =>
                              GoRouter.of(context).goNamed('search'),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: () => GoRouter.of(context).goNamed('create'),
                icon: const Icon(Icons.add),
                color: AppColors.primary,
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
