import 'package:flutter/material.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/widgets/components.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_bloc.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/widgets/button.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/data/models/study_data.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/data/datasources/study_service.dart';

void showFilterModal(
  BuildContext context,
  void Function(bool, Map<String, dynamic>, MahasiswaBloc) setFilterMode,
  MahasiswaBloc bloc, {
  required Map<String, bool> initialFacultyOptions,
  required Map<String, bool> initialMajorOptions,
  required Map<String, bool> initialCityOptions,
  required String initialSelectedOrder,
  required bool initialOrderSwitch,
  required void Function(
    Map<String, bool> faculty,
    Map<String, bool> major,
    Map<String, bool> city,
    String selectedOrder,
    bool orderSwitch,
  ) onPersistOptions,
}) async {
  String selectedOrder = initialSelectedOrder;
  bool orderSwitch = initialOrderSwitch;

  // Load study data
  final StudyResponse studyData = await StudyService.loadStudyData();
  final List<String> faculties = StudyService.getFaculties(studyData);

  // Convert faculty options to single selection (radio button style)
  String? selectedFaculty = initialFacultyOptions.entries
      .firstWhere((entry) => entry.value,
          orElse: () => const MapEntry('', false))
      .key;

  if (selectedFaculty.isEmpty && faculties.isNotEmpty) {
    selectedFaculty = null; // No faculty selected initially
  }

  Map<String, bool> majorOptions = Map<String, bool>.from(initialMajorOptions);
  Map<String, bool> cityOptions = Map<String, bool>.from(initialCityOptions);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          final String ascLabel = orderSwitch ? "A-Z (Name)" : "A-Z (NIM)";
          final String descLabel = orderSwitch ? "Z-A (Name)" : "Z-A (NIM)";

          // Set default selection jika tidak ada yang dipilih
          if (selectedOrder.isEmpty) {
            selectedOrder = ascLabel;
          }

          // Get available majors based on selected faculty
          List<String> availableMajors = [];
          if (selectedFaculty != null && selectedFaculty!.isNotEmpty) {
            availableMajors =
                StudyService.getMajorsByFaculty(studyData, selectedFaculty!);
          }

          return Container(
            padding: const EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              children: [
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 30, top: 10),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        _facultyRadioButton(context, "Faculty", setModalState,
                            faculties, selectedFaculty, (value) {
                          setModalState(() {
                            selectedFaculty = value;
                            // Clear major options when faculty changes
                            majorOptions.clear();
                            // Initialize major options for selected faculty
                            if (value != null) {
                              final majors = StudyService.getMajorsByFaculty(
                                  studyData, value);
                              for (String major in majors) {
                                majorOptions[major] = false;
                              }
                            }
                          });
                        }),
                        _majorCheckboxButton(context, "Major", setModalState,
                            majorOptions, availableMajors,
                            isDisabled: selectedFaculty == null),
                        _sortButton(context, "City", setModalState, cityOptions,
                            "City", Icons.home),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _orderRadioButton(
                                  ascLabel, setModalState, selectedOrder,
                                  (value) {
                                setModalState(() {
                                  selectedOrder = value;
                                });
                              }, 0, orderSwitch),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _orderRadioButton(
                                  descLabel, setModalState, selectedOrder,
                                  (value) {
                                setModalState(() {
                                  selectedOrder = value;
                                });
                              }, 3.1416, orderSwitch),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Fixed bottom section
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          Switch(
                            value: orderSwitch,
                            activeThumbColor: AppColors.secondary,
                            activeTrackColor: AppColors.secondary.withAlpha(65),
                            inactiveThumbColor: AppColors.primary,
                            inactiveTrackColor: AppColors.silver.withAlpha(95),
                            onChanged: (bool value) {
                              setModalState(() {
                                final String oldAsc =
                                    orderSwitch ? "A-Z (NIM)" : "A-Z (Name)";
                                final String oldDesc =
                                    orderSwitch ? "Z-A (NIM)" : "Z-A (Name)";
                                final String newAsc =
                                    value ? "A-Z (Name)" : "A-Z (NIM)";
                                final String newDesc =
                                    value ? "Z-A (Name)" : "Z-A (NIM)";

                                orderSwitch = value;

                                // Set default selection berdasarkan switch
                                if (selectedOrder == oldAsc ||
                                    selectedOrder == oldDesc) {
                                  // Jika sebelumnya ASC, tetap pilih ASC dengan label baru
                                  if (selectedOrder == oldAsc) {
                                    selectedOrder = newAsc;
                                  } else {
                                    // Jika sebelumnya DESC, tetap pilih DESC dengan label baru
                                    selectedOrder = newDesc;
                                  }
                                } else {
                                  // Jika tidak ada yang dipilih, default ke ASC
                                  selectedOrder = newAsc;
                                }

                                // Jika orderSwitch menjadi true (By NIM), pastikan ada default selection
                                if (value && selectedOrder.isEmpty) {
                                  selectedOrder = newAsc;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                          child: ButtonForm(
                              onPressed: () {
                                // Convert selected faculty to faculty options format
                                Map<String, bool> facultyOptionsForPersist = {};
                                for (String faculty in faculties) {
                                  facultyOptionsForPersist[faculty] =
                                      faculty == selectedFaculty;
                                }

                                final selectedMajors = majorOptions.entries
                                    .where((e) => e.value)
                                    .map((e) => e.key)
                                    .toList();
                                final selectedCities = cityOptions.entries
                                    .where((e) => e.value)
                                    .map((e) => e.key)
                                    .toList();
                                final Map<String, dynamic> filter = {
                                  "where": {},
                                  "orderBy": {}
                                };

                                if (selectedFaculty != null) {
                                  filter["where"]
                                      ["fakultas"] = [selectedFaculty];
                                }
                                if (selectedMajors.isNotEmpty) {
                                  filter["where"]["jurusan"] = selectedMajors;
                                }
                                if (selectedCities.isNotEmpty) {
                                  filter["where"]["asal"] = selectedCities;
                                }

                                if (selectedOrder == "A-Z (NIM)") {
                                  filter["orderBy"]["nim"] = "asc";
                                } else if (selectedOrder == "Z-A (NIM)") {
                                  filter["orderBy"]["nim"] = "desc";
                                } else if (selectedOrder == "A-Z (Name)") {
                                  filter["orderBy"]["name"] = "asc";
                                } else if (selectedOrder == "Z-A (Name)") {
                                  filter["orderBy"]["name"] = "desc";
                                }

                                // Persist pilihan ke parent sebelum terapkan
                                onPersistOptions(
                                  facultyOptionsForPersist,
                                  Map<String, bool>.from(majorOptions),
                                  Map<String, bool>.from(cityOptions),
                                  selectedOrder,
                                  orderSwitch,
                                );

                                setFilterMode(
                                  true,
                                  filter,
                                  bloc,
                                );
                              },
                              text: "Apply")),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _facultyRadioButton(
    BuildContext context,
    String label,
    StateSetter setModalState,
    List<String> faculties,
    String? selectedFaculty,
    Function(String?) onFacultyChanged) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 4),
    decoration: BoxDecoration(
      color: selectedFaculty != null
          ? AppColors.secondary.withAlpha(65)
          : AppColors.silver.withAlpha(95),
      borderRadius: BorderRadius.circular(16),
    ),
    child: InkWell(
      onTap: () => _showFacultyBottomSheet(
          context, setModalState, faculties, selectedFaculty, onFacultyChanged),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.school,
                  color: selectedFaculty != null
                      ? AppColors.secondary
                      : AppColors.primary,
                  size: 38,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.openSansBold(
                        fontSize: 16,
                        color: selectedFaculty != null
                            ? AppColors.secondary
                            : AppColors.primary,
                      ),
                    ),
                    Text(
                      selectedFaculty ?? "Pilih Fakultas",
                      style: AppTextStyles.openSansItalic(
                        fontSize: 12,
                        color: selectedFaculty != null
                            ? AppColors.secondary
                            : AppColors.primary,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Icon(
              Icons.circle,
              color: selectedFaculty != null
                  ? AppColors.secondary
                  : AppColors.primary.withAlpha(90),
              size: 14,
            )
          ],
        ),
      ),
    ),
  );
}

Widget _majorCheckboxButton(
    BuildContext context,
    String label,
    StateSetter setModalState,
    Map<String, bool> majorOptions,
    List<String> availableMajors,
    {bool isDisabled = false}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 4),
    decoration: BoxDecoration(
      color: majorOptions.values.any((selected) => selected)
          ? AppColors.secondary.withAlpha(65)
          : AppColors.silver.withAlpha(95),
      borderRadius: BorderRadius.circular(16),
    ),
    child: InkWell(
      onTap: isDisabled
          ? null
          : () => _showSortBottomSheet(
              context, setModalState, majorOptions, "Major"),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.collections_sharp,
                  color: majorOptions.values.any((selected) => selected)
                      ? AppColors.secondary
                      : AppColors.primary,
                  size: 38,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.openSansBold(
                        fontSize: 16,
                        color: majorOptions.values.any((selected) => selected)
                            ? AppColors.secondary
                            : AppColors.primary,
                      ),
                    ),
                    Text(
                      "${majorOptions.values.where((selected) => selected).length} Selected",
                      style: AppTextStyles.openSansItalic(
                        fontSize: 12,
                        color: majorOptions.values.any((selected) => selected)
                            ? AppColors.secondary
                            : AppColors.primary,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Icon(
              Icons.circle,
              color: majorOptions.values.any((selected) => selected)
                  ? AppColors.secondary
                  : AppColors.primary.withAlpha(90),
              size: 14,
            )
          ],
        ),
      ),
    ),
  );
}

Widget _sortButton(
    BuildContext context,
    String label,
    StateSetter setModalState,
    Map<String, bool> options,
    String category,
    IconData iconFilter,
    {bool isDisabled = false}) {
  int colOpacity = 90;

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 4),
    decoration: BoxDecoration(
      color: options.values.any((selected) => selected)
          ? AppColors.secondary.withAlpha(65)
          : AppColors.silver.withAlpha(95),
      borderRadius: BorderRadius.circular(16),
    ),
    child: InkWell(
      onTap: isDisabled
          ? null
          : () =>
              _showSortBottomSheet(context, setModalState, options, category),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (options.values.any((selected) => selected))
                  Icon(
                    iconFilter,
                    color: AppColors.secondary,
                    size: 38,
                  )
                else
                  Icon(
                    iconFilter,
                    color: AppColors.primary,
                    size: 38,
                  ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (options.values.any((selected) => selected))
                      Text(
                        label,
                        style: AppTextStyles.openSansBold(
                          fontSize: 16,
                          color: AppColors.secondary,
                        ),
                      )
                    else
                      Text(
                        label,
                        style: AppTextStyles.openSansBold(
                          fontSize: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    if (options.values.any((selected) => selected))
                      Text(
                        "${options.values.where((selected) => selected).length} Selected",
                        style: AppTextStyles.openSansItalic(
                            fontSize: 12, color: AppColors.secondary),
                      )
                    else
                      Text(
                        "${options.values.where((selected) => selected).length} Selected",
                        style: AppTextStyles.openSansItalic(
                            fontSize: 12, color: AppColors.primary),
                      ),
                  ],
                )
              ],
            ),
            if (options.values.any((selected) => selected))
              const Icon(
                Icons.circle,
                color: AppColors.secondary,
                size: 14,
              )
            else
              Icon(
                Icons.circle,
                color: AppColors.primary.withAlpha(colOpacity),
                size: 14,
              )
          ],
        ),
      ),
    ),
  );
}

void _showFacultyBottomSheet(
    BuildContext context,
    StateSetter setModalState,
    List<String> faculties,
    String? selectedFaculty,
    Function(String?) onFacultyChanged) {
  String? tempSelectedFaculty = selectedFaculty;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setSheetState) {
          return Container(
            padding: const EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pilih Fakultas",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Radio Button List
                Expanded(
                  child: ListView.builder(
                    itemCount: faculties.length,
                    itemBuilder: (context, index) {
                      String faculty = faculties[index];
                      return RadioListTile<String>(
                        title: Text(faculty),
                        value: faculty,
                        groupValue: tempSelectedFaculty,
                        onChanged: (String? value) {
                          setSheetState(() {
                            tempSelectedFaculty = value;
                          });
                        },
                      );
                    },
                  ),
                ),

                // Buttons
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ButtonForm(
                        onPressed: () {
                          setSheetState(() {
                            tempSelectedFaculty = null;
                          });
                        },
                        text: "Clear",
                        backgroundColor: AppColors.secondary,
                        textColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ButtonForm(
                        onPressed: () {
                          onFacultyChanged(tempSelectedFaculty);
                          Navigator.pop(context);
                        },
                        text: "Apply",
                        backgroundColor: AppColors.primary,
                        textColor: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

void _showSortBottomSheet(BuildContext context, StateSetter setModalState,
    Map<String, bool> sortOptions, String category) {
  Map<String, bool> tempOptions = Map.from(sortOptions);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setSheetState) {
          return Container(
            padding: const EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pilih $category",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    itemCount: tempOptions.length,
                    itemBuilder: (context, index) {
                      String key = tempOptions.keys.elementAt(index);
                      return CheckboxListTile(
                        title: Text(key),
                        value: tempOptions[key],
                        onChanged: (bool? value) {
                          setSheetState(() {
                            tempOptions[key] = value ?? false;
                          });
                        },
                      );
                    },
                  ),
                ),

                // Buttons
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ButtonForm(
                        onPressed: () {
                          setSheetState(() {
                            tempOptions.updateAll((k, v) => false);
                          });
                        },
                        text: "Clear",
                        backgroundColor: AppColors.secondary,
                        textColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ButtonForm(
                        onPressed: () {
                          setModalState(() {
                            // Update original options with selected values
                            sortOptions.clear();
                            sortOptions.addAll(tempOptions);
                          });
                          Navigator.pop(context);
                        },
                        text: "Apply",
                        backgroundColor: AppColors.primary,
                        textColor: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _orderRadioButton(
    String value,
    StateSetter setModalState,
    String selectedValue,
    Function(String) onChanged,
    double angleValue,
    bool orderSwitch) {
  String ascDescLabel = angleValue == 0 ? "ASC" : "DESC";
  String byLabel = orderSwitch ? "By NIM" : "By Name";

  return InkWell(
    onTap: () => onChanged(value),
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selectedValue == value
            ? AppColors.secondary.withAlpha(65)
            : AppColors.silver.withAlpha(95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.rotate(
            angle: angleValue, // 3.1416 rad = 180 derajat
            child: Icon(
              Icons.sort,
              size: 70,
              color: selectedValue == value
                  ? AppColors.secondary
                  : AppColors.primary,
            ),
          ),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ascDescLabel,
                style: AppTextStyles.openSansBold(
                  fontSize: 24,
                ),
              ),
              Text(
                byLabel,
                style: AppTextStyles.openSansItalic(
                  fontSize: 11,
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
