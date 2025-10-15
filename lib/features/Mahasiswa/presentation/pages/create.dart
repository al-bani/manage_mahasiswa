import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:manage_mahasiswa/core/validator/validator.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/widgets/components.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/data/models/study.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_bloc.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_event.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_state.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/pages/create/step_one.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/pages/create/step_three.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/pages/create/step_two.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/widgets/indicator_step.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/widgets/popup.dart';
import 'package:manage_mahasiswa/injection_container.dart';
import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

// FormDataModel untuk centralized state management - kompatibel dengan MahasiswaEntity
class FormDataModel {
  // Step 1 Data
  File? image;
  String firstName = '';
  String lastName = '';
  String username = '';

  // Step 2 Data
  String email = '';
  String phone = '';
  String? selectedCountry;
  DateTime? birth;
  String? gender;

  String province = '';
  String city = '';
  String district = '';
  String subdistrict = '';
  String faculty = '';
  String major = '';

  String get formattedBirth {
    if (birth == null) return '';
    return '${birth!.day.toString().padLeft(2, '0')}/${birth!.month.toString().padLeft(2, '0')}/${birth!.year}';
  }

  // Helper method untuk mendapatkan full name
  String get fullName => '$firstName $lastName';

  // Helper method untuk mendapatkan full address
  String get fullAddress => '$province, $city, $district, $subdistrict';
}

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  int currentStep = 0;
  final PageController _controller = PageController();

  // Centralized form data
  final FormDataModel formData = FormDataModel();

  void nextStep() {
    if (currentStep < 2) {
      setState(() => currentStep++);
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
      _controller.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  // Callbacks untuk update data dari setiap step
  void updateStepOneData({
    File? image,
    String? firstName,
    String? lastName,
    String? username,
  }) {
    setState(() {
      if (image != null) formData.image = image;
      if (firstName != null) formData.firstName = firstName;
      if (lastName != null) formData.lastName = lastName;
      if (username != null) formData.username = username;
    });
  }

  void updateStepTwoData({
    String? email,
    String? phone,
    String? selectedCountry,
    DateTime? birth,
    String? gender,
  }) {
    setState(() {
      if (email != null) formData.email = email;
      if (phone != null) formData.phone = phone;
      if (selectedCountry != null) formData.selectedCountry = selectedCountry;
      if (birth != null) formData.birth = birth;
      if (gender != null) formData.gender = gender;
    });
  }

  void updateStepThreeData({
    String? province,
    String? city,
    String? district,
    String? subdistrict,
    String? faculty,
    String? major,
  }) {
    setState(() {
      if (province != null) formData.province = province;
      if (city != null) formData.city = city;
      if (district != null) formData.district = district;
      if (subdistrict != null) formData.subdistrict = subdistrict;
      if (faculty != null) formData.faculty = faculty;
      if (major != null) formData.major = major;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocProvider(
        create: (context) => containerInjection<MahasiswaBloc>(),
        child: BlocListener<MahasiswaBloc, MahasiswaState>(
          listener: (context, state) {
            if (state is RemoteMahasiswaCreate) {
              PopupWidget.showOkOnly(
                context: context,
                title: "Successfully",
                message: "Data Mahasiswa ${state.mhs?.name} has been created",
                onOkPressed: () => GoRouter.of(context).goNamed('home'),
                okButtonColor: Colors.greenAccent,
              );
            } else if (state is RemoteMahasiswaError) {
              PopupWidget.showOkOnly(
                context: context,
                title: "Failed",
                message: "Data Mahasiswa ${state.mhs?.name} Failed to create",
                onOkPressed: () => GoRouter.of(context).goNamed('home'),
                okButtonColor: Colors.redAccent,
              );
            }
          },
          child: Builder(
            builder: (context) => SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // 🔹 Step indicator di sini
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child:
                        StepIndicator(currentStep: currentStep, totalSteps: 3),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    "Create Mahasiswa",
                    style: AppTextStyles.openSansBold(
                      fontSize: 20,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: PageView(
                      controller: _controller,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        StepOneForm(
                          onNext: nextStep,
                          formData: formData,
                          onDataUpdate: updateStepOneData,
                        ),
                        StepTwoForm(
                          onNext: nextStep,
                          onBack: previousStep,
                          formData: formData,
                          onDataUpdate: updateStepTwoData,
                        ),
                        StepThreeForm(
                          onBack: previousStep,
                          onSubmit: () => _onSubmitPressed(context, formData),
                          formData: formData,
                          onDataUpdate: updateStepThreeData,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<StudyData> loadStudyData() async {
    final jsonString = await rootBundle.loadString('assets/study.json');
    final jsonMap = jsonDecode(jsonString);
    return StudyData.fromJson(jsonMap);
  }

  // Fungsi untuk generate nama file random
  String _generateRandomFileName(String originalPath) {
    final extension = path.extension(originalPath);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(9999).toString().padLeft(4, '0');
    return 'image_${timestamp}_$random$extension';
  }

  void _onSubmitPressed(BuildContext context, FormDataModel formData) {
    if (!emailCheck(formData.email)) {
      PopupWidget.showOkOnly(
          context: context,
          title: "Information",
          message: "Wrong Email Format",
          okButtonColor: Colors.redAccent);
      return;
    }

    // Validasi field yang wajib diisi
    if (formData.firstName.isEmpty ||
        formData.lastName.isEmpty ||
        formData.email.isEmpty ||
        formData.phone.isEmpty ||
        formData.province.isEmpty ||
        formData.city.isEmpty ||
        formData.district.isEmpty ||
        formData.subdistrict.isEmpty ||
        formData.faculty.isEmpty ||
        formData.major.isEmpty ||
        formData.birth == null ||
        formData.gender == null) {
      PopupWidget.showOkOnly(
          context: context,
          title: "Information",
          message: "Please fill in all required fields",
          okButtonColor: Colors.redAccent);
      return;
    }

    String imageFileName = formData.image != null
        ? _generateRandomFileName(formData.image!.path)
        : "default_image.jpg";

    print("Generated filename: $imageFileName");

    final mahasiswaData = MahasiswaEntity(
        nim: 111,
        name: formData.fullName,
        province: formData.province,
        city: formData.city,
        district: formData.district,
        subdistrict: formData.subdistrict,
        email: formData.email,
        phoneNumber: formData.phone,
        fakultas: formData.faculty,
        jurusan: formData.major,
        birth: formData.birth.toString(),
        gender: formData.gender,
        image: imageFileName);

    BlocProvider.of<MahasiswaBloc>(context)
        .add(CreateMahasiswaEvent(mahasiswaData));
  }
}
