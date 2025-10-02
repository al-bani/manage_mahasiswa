import 'package:flutter/material.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_bloc.dart';

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
}) {
  String selectedOrder = initialSelectedOrder;
  bool orderSwitch = initialOrderSwitch;

  Map<String, bool> facultyOptions =
      Map<String, bool>.from(initialFacultyOptions);

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
          return Container(
            padding: const EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.7,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Filter Pencarian",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _sortButton(context, "Faculty", Colors.blue, setModalState,
                      facultyOptions, "Faculty"),
                  _sortButton(context, "Major", Colors.green, setModalState,
                      majorOptions, "Major",
                      isDisabled:
                          !facultyOptions.values.any((selected) => selected)),
                  _sortButton(context, "City", Colors.orange, setModalState,
                      cityOptions, "City"),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _orderRadioButton(
                            ascLabel, setModalState, selectedOrder, (value) {
                          setModalState(() {
                            selectedOrder = value;
                          });
                        }),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _orderRadioButton(
                            descLabel, setModalState, selectedOrder, (value) {
                          setModalState(() {
                            selectedOrder = value;
                          });
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          Switch(
                            value: orderSwitch,
                            onChanged: (bool value) {
                              setModalState(() {
                                final String oldAsc = orderSwitch
                                    ? "Ascending by Name"
                                    : "Ascending by NIM";
                                final String oldDesc = orderSwitch
                                    ? "Descending by Name"
                                    : "Descending by NIM";
                                final String newAsc = value
                                    ? "Ascending by Name"
                                    : "Ascending by NIM";
                                final String newDesc = value
                                    ? "Descending by Name"
                                    : "Descending by NIM";

                                orderSwitch = value;
                                if (selectedOrder == oldAsc) {
                                  selectedOrder = newAsc;
                                } else if (selectedOrder == oldDesc) {
                                  selectedOrder = newDesc;
                                }
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final selectedFaculties = facultyOptions.entries
                                .where((e) => e.value)
                                .map((e) => e.key)
                                .toList();
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

                            if (selectedFaculties.isNotEmpty) {
                              filter["where"]["fakultas"] = selectedFaculties;
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
                              Map<String, bool>.from(facultyOptions),
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
                          child: const Text("Terapkan"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _sortButton(BuildContext context, String label, Color color,
    StateSetter setModalState, Map<String, bool> options, String category,
    {bool isDisabled = false}) {
  Color buttonColor;
  if (isDisabled) {
    buttonColor = Colors.grey[300]!;
  } else {
    buttonColor =
        options.values.any((selected) => selected) ? Colors.green : Colors.grey;
  }

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 4),
    decoration: BoxDecoration(
      color: buttonColor,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDisabled ? Colors.grey[600] : Colors.white,
                    fontSize: 16,
                  ),
                ),
                if (options.values.any((selected) => selected) && !isDisabled)
                  Text(
                    "${options.values.where((selected) => selected).length} dipilih",
                    style: TextStyle(
                      color: isDisabled ? Colors.grey[500] : Colors.white70,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            Icon(
              Icons.arrow_drop_down,
              color: isDisabled ? Colors.grey[600] : Colors.white,
            ),
          ],
        ),
      ),
    ),
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

                // Checkbox List
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
                      child: ElevatedButton(
                        onPressed: () {
                          setSheetState(() {
                            tempOptions.updateAll((k, v) => false);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                        ),
                        child: const Text("Clear"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Back"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setModalState(() {
                            // Update original options with selected values
                            sortOptions.clear();
                            sortOptions.addAll(tempOptions);
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Apply"),
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

Widget _orderRadioButton(String value, StateSetter setModalState,
    String selectedValue, Function(String) onChanged) {
  return InkWell(
    onTap: () => onChanged(value),
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: selectedValue == value ? Colors.green : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        value,
        style: TextStyle(
          color: selectedValue == value ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
