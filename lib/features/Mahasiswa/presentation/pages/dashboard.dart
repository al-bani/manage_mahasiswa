import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/widgets/components.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_bloc.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_event.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_state.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/widgets/bar_chart.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/widgets/card.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/widgets/bottom_bar.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/widgets/pie_chart.dart';
import 'package:manage_mahasiswa/injection_container.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      body: BlocProvider(
          create: (_) => containerInjection<MahasiswaBloc>()
            ..add(DashboardMahasiswaEvent()),
          child: _bodyApp()),
    );
  }

  Widget _bodyApp() {
    return BlocBuilder<MahasiswaBloc, MahasiswaState>(
      builder: (context, state) {
        if (state is RemoteMahasiswaLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RemoteDashboardMahasiswa) {
          DateTime now = DateTime.now();
          String formattedDate = DateFormat('d MMM', 'id_ID').format(now);

          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    color: AppColors.primary,
                  ),
                  Expanded(
                    child: Container(color: AppColors.secondary),
                  ),
                ],
              ),

              // ===== Header & Card Dashboard =====
              Positioned(
                top: MediaQuery.of(context).size.height * 0.05,
                left: 16,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, User",
                      style: AppTextStyles.openSansBold(
                        fontSize: 30,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Welcome Back, your login in $formattedDate",
                      style: AppTextStyles.openSansItalic(
                        fontSize: 14,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            cardSummary(
                                "Total Mahasiswa",
                                state.data["card"]["totalMhs"].toString(),
                                "Increase 17%"),
                            const SizedBox(width: 16),
                            cardSummary(
                                "Total Fakultas",
                                state.data["card"]["totalFakultas"].toString(),
                                "Increase 17%"),
                            const SizedBox(width: 16),
                            cardSummary(
                                "Total Jurusan",
                                state.data["card"]["totalJurusan"].toString(),
                                "Increase 17%"),
                            const SizedBox(width: 16),
                            cardSummary(
                                "Total City",
                                state.data["card"]["totalCity"].toString(),
                                "Increase 17%"),
                            const SizedBox(width: 16),
                            cardSummary(
                                "Average of Age",
                                state.data["card"]["averageAge"].toString(),
                                "Increase 17%"),
                            const SizedBox(width: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              DraggableScrollableSheet(
                initialChildSize: 0.55,
                minChildSize: 0.55,
                maxChildSize: 1.0,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              "Top 5 City",
                              style: AppTextStyles.openSansBoldItalic(
                                fontSize: 14,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Builder(builder: (context) {
                              final List<dynamic> topCities =
                                  (state.data["top5city"] as List?) ?? [];
                              final int itemCount =
                                  topCities.length.clamp(0, 5);
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                child: Row(
                                  children: List.generate(itemCount, (i) {
                                    final city =
                                        topCities[i]["city"]?.toString() ?? "-";
                                    final count = topCities[i]["count"] ?? 0;
                                    return Row(children: [
                                      CardLandscape(city: city, count: count),
                                      const SizedBox(width: 16),
                                    ]);
                                  }),
                                ),
                              );
                            }),
                            // const SizedBox(height: 20),
                            // Text(
                            //   "Fakultas",
                            //   style: AppTextStyles.openSansBoldItalic(
                            //     fontSize: 14,
                            //     color: AppColors.primary,
                            //   ),
                            // ),
                            const SizedBox(height: 20),
                            Builder(builder: (context) {
                              final List<dynamic> fak =
                                  (state.data["countFakultasMhs"] as List?) ??
                                      [];
                              final int barCount = fak.length.clamp(0, 6);
                              final colors = [
                                Colors.red,
                                Colors.green,
                                Colors.yellow,
                                Colors.blueAccent,
                                Colors.purple,
                                Colors.orange,
                              ];
                              return Column(
                                children: List.generate(barCount, (i) {
                                  final name = fak[i]["fakultas"] ?? "-";
                                  final jumlah = fak[i]["jumlah"] ?? 0;
                                  return Padding(
                                    padding:
                                        EdgeInsets.only(top: i == 0 ? 0 : 10),
                                    child: barChart(
                                      context,
                                      colors[i % colors.length],
                                      name,
                                      jumlah,
                                      state.data["card"]["totalMhs"],
                                    ),
                                  );
                                }),
                              );
                            }),
                            const SizedBox(height: 40),
                            Builder(builder: (context) {
                              final List<dynamic> genderSummary =
                                  (state.data["summaryGender"] as List?) ?? [];
                              final p = genderSummary.isNotEmpty
                                  ? (genderSummary[0]["jumlah"] ?? 0)
                                  : 0;
                              final l = genderSummary.length > 1
                                  ? (genderSummary[1]["jumlah"] ?? 0)
                                  : 0;
                              return GenderPieChart(
                                gender: {
                                  "P": {
                                    "value": p,
                                    "label": "P",
                                    "colors": Colors.pink
                                  },
                                  "L": {
                                    "value": l,
                                    "label": "L",
                                    "colors": Colors.blue
                                  },
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        } else if (state is RemoteMahasiswaError) {
          return Center(child: Text("Error: ${state.error!["msg"]}"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
