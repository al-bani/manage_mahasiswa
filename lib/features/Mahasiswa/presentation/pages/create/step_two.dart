import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:manage_mahasiswa/features/Auth/presentation/widgets/components.dart';
import 'package:intl/intl.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/widgets/button.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/widgets/text_field.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

class StepTwoForm extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const StepTwoForm({super.key, required this.onNext, required this.onBack});

  @override
  State<StepTwoForm> createState() => _StepTwoFormState();
}

class _StepTwoFormState extends State<StepTwoForm> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController countrySearchController = TextEditingController();
  DateTime? selectedDate;
  String? selectedGender;
  Map<String, dynamic>? selectedCountry; // holds name, image, dialCodes, etc
  List<dynamic> allCountries = [];
  List<dynamic> filteredCountries = [];
  bool isLoadingCountries = false;

  @override
  void initState() {
    super.initState();
    _loadTelephoneCodes();
  }

  Future<void> _loadTelephoneCodes() async {
    setState(() {
      isLoadingCountries = true;
    });
    try {
      final String jsonString =
          await rootBundle.loadString('assets/telephone_code.json');
      final List<dynamic> data = json.decode(jsonString) as List<dynamic>;
      setState(() {
        allCountries = data;
        filteredCountries = data;
        // Preselect Indonesia if available, else first with dialCodes
        selectedCountry = data.firstWhere(
          (c) => (c['code'] == 'ID' || c['slug'] == 'indonesia'),
          orElse: () => data.first,
        ) as Map<String, dynamic>;
      });
    } catch (_) {
      // Fallback to an empty state
    } finally {
      if (mounted) {
        setState(() {
          isLoadingCountries = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Content area that can scroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email",
                      style: AppTextStyles.openSansBold(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    FormTextField(
                        controller: emailController,
                        hintText: "Enter your email"),
                    const SizedBox(height: 10),
                    Text(
                      "Phone Number",
                      style: AppTextStyles.openSansBold(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
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
                          horizontal: 10,
                          vertical: 8,
                        ),
                        hintText: "Enter your phone number",
                        hintStyle: AppTextStyles.openSansItalic(fontSize: 12),
                        prefixIcon: InkWell(
                          onTap: isLoadingCountries ? null : _openCountryPicker,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: _buildCountryPrefix(),
                          ),
                        ),
                      ),
                      style: AppTextStyles.openSansBold(fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Date of Birth",
                      style: AppTextStyles.openSansBold(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: dateController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
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
                        hintText: "Choose your Birthday Date",
                        hintStyle: AppTextStyles.openSansItalic(fontSize: 12),
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      style: AppTextStyles.openSansBold(fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    Text("Gender",
                        style: AppTextStyles.openSansBold(fontSize: 12)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<String>(
                              value: "Male",
                              groupValue: selectedGender,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedGender = value;
                                });
                              },
                              activeColor: AppColors.primary,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              "Male",
                              style: AppTextStyles.openSansBold(fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<String>(
                              value: "Female",
                              groupValue: selectedGender,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedGender = value;
                                });
                              },
                              activeColor: AppColors.primary,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              "Female",
                              style: AppTextStyles.openSansBold(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Extra padding at bottom to ensure content doesn't get hidden behind buttons
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            // Fixed bottom buttons
            Container(
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
                        onPressed: () {
                          widget.onBack();
                        },
                        text: "Back",
                        backgroundColor: AppColors.secondary,
                        textColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12), // Spacing antar button
                    Expanded(
                      flex:
                          4, // Button Next mendapat 4/5 dari lebar (lebih lebar)
                      child: ButtonForm(
                        onPressed: () {
                          widget.onNext();
                        },
                        text: "Next",
                        backgroundColor: AppColors.primary,
                        textColor: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime tenYearsAgo =
        DateTime.now().subtract(const Duration(days: 365 * 10));
    DateTime tempDate = selectedDate ?? tenYearsAgo;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Title
                  Text(
                    'Choose Date',
                    style: AppTextStyles.openSansBold(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  // Calendar
                  Expanded(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: AppColors.primary,
                          onPrimary: AppColors.secondary,
                          surface: AppColors.white,
                          onSurface: AppColors.primary,
                        ),
                      ),
                      child: CalendarDatePicker(
                        initialDate: tempDate,
                        firstDate: DateTime(1900),
                        lastDate: tenYearsAgo,
                        onDateChanged: (DateTime date) {
                          setModalState(() {
                            tempDate = date;
                          });
                        },
                      ),
                    ),
                  ),
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ButtonForm(
                          onPressed: () => Navigator.of(context).pop(),
                          text: "Cancel",
                          backgroundColor: AppColors.secondary,
                          textColor: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ButtonForm(
                          onPressed: () {
                            setState(() {
                              selectedDate = tempDate;
                              dateController.text =
                                  DateFormat('dd/MM/yyyy').format(tempDate);
                            });
                            Navigator.of(context).pop();
                          },
                          text: "Choose",
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

  Widget _buildCountryPrefix() {
    final Map<String, dynamic>? country = selectedCountry;
    final String dial = (country != null &&
            country['dialCodes'] != null &&
            (country['dialCodes'] as List).isNotEmpty)
        ? (country['dialCodes'] as List).first.toString()
        : '+';
    final String? countryCode =
        country != null ? (country['code'] as String?) : null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (countryCode != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: SvgPicture.asset(
              'assets/flags/${countryCode.toLowerCase()}.svg',
              width: 20,
              height: 14,
              placeholderBuilder: (context) => Container(
                width: 20,
                height: 14,
                color: Colors.grey.shade300,
              ),
            ),
          )
        else
          const Icon(Icons.flag, size: 16),
        const SizedBox(width: 4),
        Text(
          dial,
          style: AppTextStyles.openSansBold(fontSize: 12),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.keyboard_arrow_down, size: 18),
      ],
    );
  }

  void _openCountryPicker() {
    countrySearchController.clear();
    filteredCountries = allCountries;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void filter(String query) {
              final String lower = query.toLowerCase();
              setModalState(() {
                filteredCountries = allCountries.where((c) {
                  final Map<String, dynamic> m = c as Map<String, dynamic>;
                  final String name =
                      (m['name'] ?? '').toString().toLowerCase();
                  final String code =
                      (m['code'] ?? '').toString().toLowerCase();
                  final List dials = (m['dialCodes'] ?? []) as List;
                  final bool matchDial = dials
                      .map((e) => e.toString().toLowerCase())
                      .any((d) => d.contains(lower));
                  return name.contains(lower) ||
                      code.contains(lower) ||
                      matchDial;
                }).toList();
              });
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: countrySearchController,
                    onChanged: filter,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search country or code',
                      hintStyle: AppTextStyles.openSansItalic(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    style: AppTextStyles.openSansBold(fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: filteredCountries.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> item =
                            filteredCountries[index] as Map<String, dynamic>;
                        final String name = (item['name'] ?? '').toString();
                        final String? code = item['code'] as String?;
                        final List dials = (item['dialCodes'] ?? []) as List;
                        final String dial =
                            dials.isNotEmpty ? dials.first.toString() : '+';
                        return ListTile(
                          leading: (code != null)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(2),
                                  child: SvgPicture.asset(
                                    'assets/flags/${code.toLowerCase()}.svg',
                                    width: 28,
                                    height: 20,
                                    placeholderBuilder: (context) => Container(
                                      width: 28,
                                      height: 20,
                                      color: AppColors.white,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.flag),
                          title: Text(
                            name,
                            style: AppTextStyles.openSansBold(fontSize: 14),
                          ),
                          subtitle: Text(
                            dial,
                            style: AppTextStyles.openSansItalic(fontSize: 12),
                          ),
                          onTap: () {
                            setState(() {
                              selectedCountry = item;
                            });
                            Navigator.of(context).pop();
                          },
                        );
                      },
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

  @override
  void dispose() {
    dateController.dispose();
    emailController.dispose();
    phoneController.dispose();
    countrySearchController.dispose();
    super.dispose();
  }
}
