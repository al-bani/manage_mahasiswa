import 'package:flutter/material.dart';
import 'package:manage_mahasiswa/core/resources/data_local.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/widgets/components.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/widgets/dropdown.dart';

class ResidenceResult {
  final String? provinceCode;
  final String? regencyCode;
  final String? districtCode;
  final String? villageCode;
  final String label;

  const ResidenceResult({
    required this.provinceCode,
    required this.regencyCode,
    required this.districtCode,
    required this.villageCode,
    required this.label,
  });
}

Future<ResidenceResult?> showResidenceBottomSheet(
  BuildContext context, {
  String? initialProvince,
  String? initialRegency,
  String? initialDistrict,
  String? initialVillage,
}) async {
  return await showModalBottomSheet<ResidenceResult>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return _ResidenceBottomSheet(
        initialProvince: initialProvince,
        initialRegency: initialRegency,
        initialDistrict: initialDistrict,
        initialVillage: initialVillage,
      );
    },
  );
}

class _ResidenceBottomSheet extends StatefulWidget {
  final String? initialProvince;
  final String? initialRegency;
  final String? initialDistrict;
  final String? initialVillage;

  const _ResidenceBottomSheet({
    required this.initialProvince,
    required this.initialRegency,
    required this.initialDistrict,
    required this.initialVillage,
  });

  @override
  State<_ResidenceBottomSheet> createState() => _ResidenceBottomSheetState();
}

class _ResidenceBottomSheetState extends State<_ResidenceBottomSheet> {
  bool isLoading = false;

  String? selectedProvince;
  String? selectedRegency;
  String? selectedDistrict;
  String? selectedVillage;

  List<Map<String, dynamic>> provinceList = [];
  List<Map<String, dynamic>> regencyList = [];
  List<Map<String, dynamic>> districtList = [];
  List<Map<String, dynamic>> villageList = [];

  @override
  void initState() {
    super.initState();
    selectedProvince = widget.initialProvince;
    selectedRegency = widget.initialRegency;
    selectedDistrict = widget.initialDistrict;
    selectedVillage = widget.initialVillage;
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    setState(() => isLoading = true);
    try {
      provinceList = await DBRegional.getProvinsi();

      if (selectedProvince != null) {
        regencyList = await DBRegional.getKabupaten(selectedProvince!);
      }
      if (selectedRegency != null) {
        districtList = await DBRegional.getKecamatan(selectedRegency!);
      }
      if (selectedDistrict != null) {
        villageList = await DBRegional.getDesa(selectedDistrict!);
      }
    } catch (_) {}
    if (mounted) setState(() => isLoading = false);
  }

  String _composeLabel() {
    String provName = provinceList.firstWhere(
        (p) => p['code'] == selectedProvince,
        orElse: () => {'name': ''})['name'];
    String kabName = regencyList.firstWhere((k) => k['code'] == selectedRegency,
        orElse: () => {'name': ''})['name'];
    String kecName = districtList.firstWhere(
        (k) => k['code'] == selectedDistrict,
        orElse: () => {'name': ''})['name'];
    String desaName = villageList.firstWhere(
        (d) => d['code'] == selectedVillage,
        orElse: () => {'name': ''})['name'];

    return [provName, kabName, kecName, desaName]
        .where((x) => x.isNotEmpty)
        .join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Choose Residence",
                style: AppTextStyles.openSansBold(fontSize: 18),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Province
          DropdownMap(
            value: selectedProvince,
            items: provinceList,
            valueKey: 'code',
            displayKey: 'name',
            hint: "Choose Province",
            label: "Province",
            isLoading: isLoading,
            onChanged: (val) async {
              setState(() {
                selectedProvince = val;
                selectedRegency = null;
                selectedDistrict = null;
                selectedVillage = null;
                regencyList = [];
                districtList = [];
                villageList = [];
              });
              if (val != null) {
                regencyList = await DBRegional.getKabupaten(val);
                if (mounted) setState(() {});
              }
            },
            fontSize: 14,
          ),
          const SizedBox(height: 16),

          // Regency
          DropdownMap(
            value: selectedRegency,
            items: regencyList,
            valueKey: 'code',
            displayKey: 'name',
            hint: selectedProvince == null
                ? "Choose Province first"
                : "Choose City",
            label: "City",
            enabled: selectedProvince != null,
            onChanged: selectedProvince == null
                ? null
                : (val) async {
                    setState(() {
                      selectedRegency = val;
                      selectedDistrict = null;
                      selectedVillage = null;
                      districtList = [];
                      villageList = [];
                    });
                    if (val != null) {
                      districtList = await DBRegional.getKecamatan(val);
                      if (mounted) setState(() {});
                    }
                  },
            fontSize: 14,
          ),
          const SizedBox(height: 16),

          // District
          DropdownMap(
            value: selectedDistrict,
            items: districtList,
            valueKey: 'code',
            displayKey: 'name',
            hint: selectedRegency == null
                ? "Choose City first"
                : "Choose District",
            label: "District",
            enabled: selectedRegency != null,
            onChanged: selectedRegency == null
                ? null
                : (val) async {
                    setState(() {
                      selectedDistrict = val;
                      selectedVillage = null;
                      villageList = [];
                    });
                    if (val != null) {
                      villageList = await DBRegional.getDesa(val);
                      if (mounted) setState(() {});
                    }
                  },
            fontSize: 14,
          ),
          const SizedBox(height: 16),

          // Village
          DropdownMap(
            value: selectedVillage,
            items: villageList,
            valueKey: 'code',
            displayKey: 'name',
            hint: selectedDistrict == null
                ? "Choose District first"
                : "Choose Subdistrict",
            label: "Subdistrict",
            enabled: selectedDistrict != null,
            onChanged: selectedDistrict == null
                ? null
                : (val) {
                    setState(() => selectedVillage = val);
                  },
            fontSize: 14,
          ),

          const Spacer(),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedProvince = null;
                      selectedRegency = null;
                      selectedDistrict = null;
                      selectedVillage = null;
                      regencyList = [];
                      districtList = [];
                      villageList = [];
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Clear",
                    style: AppTextStyles.openSansBold(
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final label = _composeLabel();
                    Navigator.pop(
                      context,
                      ResidenceResult(
                        provinceCode: selectedProvince,
                        regencyCode: selectedRegency,
                        districtCode: selectedDistrict,
                        villageCode: selectedVillage,
                        label: label,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Submit",
                    style: AppTextStyles.openSansBold(
                      fontSize: 16,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
