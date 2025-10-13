import 'package:flutter/material.dart';
import 'package:manage_mahasiswa/core/resources/data_local.dart';

class AlamatPicker extends StatefulWidget {
  final TextEditingController
      controller; // hasil akhir alamat (prov, kab, kec, desa)
  const AlamatPicker({super.key, required this.controller});

  @override
  State<AlamatPicker> createState() => _AlamatPickerState();
}

class _AlamatPickerState extends State<AlamatPicker> {
  // selected values
  String? selectedProv;
  String? selectedKab;
  String? selectedKec;
  String? selectedDesa;

  // data lists
  List<Map<String, dynamic>> provinsiList = [];
  List<Map<String, dynamic>> kabupatenList = [];
  List<Map<String, dynamic>> kecamatanList = [];
  List<Map<String, dynamic>> desaList = [];

  bool isLoadingProv = true;

  @override
  void initState() {
    super.initState();
    _loadProvinsi();
  }

  Future<void> _loadProvinsi() async {
    provinsiList = await DBRegional.getProvinsi();
    setState(() => isLoadingProv = false);
  }

  Future<void> _loadKabupaten(String provCode) async {
    kabupatenList = await DBRegional.getKabupaten(provCode);
    kecamatanList = [];
    desaList = [];
    selectedKab = selectedKec = selectedDesa = null;
    setState(() {});
  }

  Future<void> _loadKecamatan(String kabCode) async {
    kecamatanList = await DBRegional.getKecamatan(kabCode);
    desaList = [];
    selectedKec = selectedDesa = null;
    setState(() {});
  }

  Future<void> _loadDesa(String kecCode) async {
    desaList = await DBRegional.getDesa(kecCode);
    print("DEBUG: Desa ditemukan ${desaList.length} untuk kecamatan $kecCode");
    selectedDesa = null;
    setState(() {});
  }

  void _updateAlamatController() {
    String provName = provinsiList.firstWhere((p) => p['code'] == selectedProv,
        orElse: () => {'name': ''})['name'];
    String kabName = kabupatenList.firstWhere((k) => k['code'] == selectedKab,
        orElse: () => {'name': ''})['name'];
    String kecName = kecamatanList.firstWhere((k) => k['code'] == selectedKec,
        orElse: () => {'name': ''})['name'];
    String desaName = desaList.firstWhere((d) => d['code'] == selectedDesa,
        orElse: () => {'name': ''})['name'];

    widget.controller.text = [provName, kabName, kecName, desaName]
        .where((x) => x.isNotEmpty)
        .join(', ');
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingProv) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Alamat (Wilayah Indonesia)",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),

        // ===================== PROVINSI =====================
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Provinsi',
            border: OutlineInputBorder(),
          ),
          hint: const Text('Pilih Provinsi'),
          value: selectedProv,
          items: provinsiList.map((prov) {
            return DropdownMenuItem<String>(
              value: prov['code'],
              child: Text(prov['name']),
            );
          }).toList(),
          onChanged: (value) async {
            selectedProv = value;
            await _loadKabupaten(value!);
          },
        ),
        const SizedBox(height: 16),

        // ===================== KABUPATEN =====================
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Kabupaten / Kota',
            border: OutlineInputBorder(),
          ),
          hint: const Text('Pilih Kabupaten / Kota'),
          value: selectedKab,
          items: kabupatenList.map((kab) {
            return DropdownMenuItem<String>(
              value: kab['code'],
              child: Text(kab['name']),
            );
          }).toList(),
          onChanged: (value) async {
            selectedKab = value;
            await _loadKecamatan(value!);
          },
        ),
        const SizedBox(height: 16),

        // ===================== KECAMATAN =====================
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Kecamatan',
            border: OutlineInputBorder(),
          ),
          hint: const Text('Pilih Kecamatan'),
          value: selectedKec,
          items: kecamatanList.map((kec) {
            return DropdownMenuItem<String>(
              value: kec['code'],
              child: Text(kec['name']),
            );
          }).toList(),
          onChanged: (value) async {
            selectedKec = value;
            await _loadDesa(value!);
          },
        ),
        const SizedBox(height: 16),

        // ===================== DESA / KELURAHAN =====================
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Desa / Kelurahan',
            border: OutlineInputBorder(),
          ),
          hint: const Text('Pilih Desa / Kelurahan'),
          value: selectedDesa,
          items: desaList.map((d) {
            return DropdownMenuItem<String>(
              value: d['code'],
              child: Text(d['name']),
            );
          }).toList(),
          onChanged: (value) {
            selectedDesa = value;
            _updateAlamatController();
            setState(() {});
          },
        ),
      ],
    );
  }
}
