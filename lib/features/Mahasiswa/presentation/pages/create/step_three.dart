import 'package:flutter/material.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/widgets/components.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/widgets/bottomsheet_residence.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/widgets/dropdown.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/widgets/button.dart';
import '../create.dart'; // Import FormDataModel

class StepThreeForm extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSubmit;
  final FormDataModel formData;
  final Function({
    String? province,
    String? city,
    String? district,
    String? subdistrict,
    String? faculty,
    String? major,
  }) onDataUpdate;

  const StepThreeForm({
    super.key,
    required this.onBack,
    required this.onSubmit,
    required this.formData,
    required this.onDataUpdate,
  });

  @override
  State<StepThreeForm> createState() => _StepThreeFormState();
}

class _StepThreeFormState extends State<StepThreeForm> {
  final TextEditingController facultyController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  final TextEditingController residenceController = TextEditingController();

  // Dropdown state
  String? selectedFaculty;
  String? selectedMajor;
  List<Map<String, dynamic>> facultyList = [];
  List<String> majorList = [];
  bool isLoading = true;

  // Address state
  String? selectedProvince;
  String? selectedRegency;
  String? selectedDistrict;
  String? selectedVillage;
  List<Map<String, dynamic>> provinceList = [];
  List<Map<String, dynamic>> regencyList = [];
  List<Map<String, dynamic>> districtList = [];
  List<Map<String, dynamic>> villageList = [];
  bool isLoadingAddress = false;

  @override
  void initState() {
    super.initState();
    // Load existing data
    selectedFaculty =
        widget.formData.faculty.isEmpty ? null : widget.formData.faculty;
    selectedMajor =
        widget.formData.major.isEmpty ? null : widget.formData.major;

    // Set residence controller text
    if (widget.formData.province.isNotEmpty) {
      residenceController.text = widget.formData.fullAddress;
    }

    _loadStudyData();
    // Don't load address data in initState, load it when bottomsheet opens
  }

  void _onBack() {
    // Update data before going back
    widget.onDataUpdate(
      province: widget.formData.province,
      city: widget.formData.city,
      district: widget.formData.district,
      subdistrict: widget.formData.subdistrict,
      faculty: selectedFaculty,
      major: selectedMajor,
    );
    widget.onBack();
  }

  void _onSubmit() {
    // Update data before submit
    widget.onDataUpdate(
      province: widget.formData.province,
      city: widget.formData.city,
      district: widget.formData.district,
      subdistrict: widget.formData.subdistrict,
      faculty: selectedFaculty,
      major: selectedMajor,
    );
    widget.onSubmit();
  }

  Future<void> _loadStudyData() async {
    try {
      final String response = await rootBundle.loadString('assets/study.json');
      final data = json.decode(response);

      if (mounted) {
        setState(() {
          facultyList = List<Map<String, dynamic>>.from(data['fakultas']);
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading study data: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _onFacultyChanged(String? value) {
    setState(() {
      selectedFaculty = value;
      selectedMajor = null;
      majorList = [];

      if (value != null) {
        final faculty = facultyList.firstWhere(
          (f) => f['nama'] == value,
          orElse: () => {'prodi': []},
        );
        majorList = List<String>.from(faculty['prodi'] ?? []);
      }
    });

    // Update formData
    widget.onDataUpdate(
      province: widget.formData.province,
      city: widget.formData.city,
      district: widget.formData.district,
      subdistrict: widget.formData.subdistrict,
      faculty: value,
      major: null, // Reset major when faculty changes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Residence",
              style: AppTextStyles.openSansBold(fontSize: 12),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: residenceController,
              readOnly: true,
              onTap: () async {
                final res = await showResidenceBottomSheet(
                  context,
                  initialProvince: selectedProvince,
                  initialRegency: selectedRegency,
                  initialDistrict: selectedDistrict,
                  initialVillage: selectedVillage,
                );
                if (res != null) {
                  setState(() {
                    selectedProvince = res.provinceCode;
                    selectedRegency = res.regencyCode;
                    selectedDistrict = res.districtCode;
                    selectedVillage = res.villageCode;
                    residenceController.text = res.label;
                  });

                  // Update formData dengan address breakdown
                  // Parse the label to extract individual components
                  final addressParts = res.label.split(', ');
                  widget.onDataUpdate(
                    province: addressParts.length > 0 ? addressParts[0] : '',
                    city: addressParts.length > 1 ? addressParts[1] : '',
                    district: addressParts.length > 2 ? addressParts[2] : '',
                    subdistrict: addressParts.length > 3 ? addressParts[3] : '',
                    faculty: selectedFaculty,
                    major: selectedMajor,
                  );
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2.0,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                hintText: "Choose your Residence",
                hintStyle: AppTextStyles.openSansItalic(fontSize: 12),
                suffixIcon: const Icon(Icons.location_on),
              ),
              style: AppTextStyles.openSansBold(fontSize: 12),
            ),
            const SizedBox(height: 10),

            // Faculty Dropdown
            DropdownMap(
              value: selectedFaculty,
              items: facultyList,
              valueKey: 'nama',
              displayKey: 'nama',
              hint: "Choose your Faculty",
              label: "Faculty",
              onChanged: _onFacultyChanged,
              fontSize: 12,
            ),
            const SizedBox(height: 10),

            // Major Dropdown
            DropdownForm<String>(
              value: selectedMajor,
              items: majorList,
              itemBuilder: (major) => major,
              hint: selectedFaculty == null
                  ? "Select Faculty first"
                  : "Choose your Major",
              label: "Major",
              onChanged: selectedFaculty == null
                  ? null
                  : (value) {
                      setState(() {
                        selectedMajor = value;
                      });

                      // Update formData
                      widget.onDataUpdate(
                        province: widget.formData.province,
                        city: widget.formData.city,
                        district: widget.formData.district,
                        subdistrict: widget.formData.subdistrict,
                        faculty: selectedFaculty,
                        major: value,
                      );
                    },
              enabled: selectedFaculty != null,
              fontSize: 12,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 2, // Button Back mendapat 2/5 dari lebar
                child: ButtonForm(
                  onPressed: _onBack, // Use the new method
                  text: "Back",
                  backgroundColor: AppColors.secondary,
                  textColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12), // Spacing antar button
              Expanded(
                flex: 4, // Button Next mendapat 4/5 dari lebar (lebih lebar)
                child: ButtonForm(
                  onPressed: _onSubmit, // Use the new method
                  text: "Submit",
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
