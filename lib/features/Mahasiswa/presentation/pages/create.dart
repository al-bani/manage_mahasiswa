import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:manage_mahasiswa/core/validator/validator.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/widgets/components.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/data/models/study.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_bloc.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_event.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_state.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/pages/create/step_one.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/pages/create/step_three.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/pages/create/step_two.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/widgets/components.dart' hide Txt;
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/widgets/indicator_step.dart';
import 'package:manage_mahasiswa/injection_container.dart';
import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  int currentStep = 0;
  final PageController _controller = PageController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => containerInjection<MahasiswaBloc>(),
        child: BlocListener<MahasiswaBloc, MahasiswaState>(
          listener: (context, state) {
            if (state is RemoteMahasiswaCreate) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data Created!')),
              );
            } else if (state is RemoteMahasiswaError) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error While Create Data')),
              );
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 24),
                // 🔹 Step indicator di sini
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: StepIndicator(currentStep: currentStep, totalSteps: 3),
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
                      StepOneForm(onNext: nextStep),
                      StepTwoForm(onNext: nextStep, onBack: previousStep),
                      StepThreeForm(onBack: previousStep),
                    ],
                  ),
                ),
              ],
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

  void _dialogPopUp(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Txt(
          value: "Information",
          size: 18,
          align: TextAlign.left,
        ),
        content: Txt(
          value: message,
          size: 14,
          align: TextAlign.left,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Txt(
              value: "OK",
              size: 16,
              align: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk generate nama file random
  String _generateRandomFileName(String originalPath) {
    final extension = path.extension(originalPath);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(9999).toString().padLeft(4, '0');
    return 'image_${timestamp}_$random$extension';
  }

  void _showImagePicker(BuildContext context,
      ValueNotifier<File?> selectedImage, ImagePicker picker) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 1024,
                    maxHeight: 1024,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    selectedImage.value = File(image.path);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil Foto'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.camera,
                    maxWidth: 1024,
                    maxHeight: 1024,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    selectedImage.value = File(image.path);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSubmitPressed(BuildContext context, final dataMhs) {
    if (!emailCheck(dataMhs.email!)) {
      _dialogPopUp("Wrong Format Email", context);
      return;
    }

    // Validasi field yang wajib diisi
    if (dataMhs.firstName.isEmpty ||
        dataMhs.lastName.isEmpty ||
        dataMhs.email.isEmpty ||
        dataMhs.phone.isEmpty ||
        dataMhs.residence.isEmpty ||
        dataMhs.faculty.isEmpty ||
        dataMhs.major.isEmpty ||
        dataMhs.dateOfBirth.isEmpty ||
        dataMhs.gender == null) {
      _dialogPopUp("Mohon lengkapi semua field yang wajib diisi", context);
      return;
    }

    String imageFileName = dataMhs.image != null
        ? _generateRandomFileName(dataMhs.image!.path)
        : "default_image.jpg";

    print("Generated filename: $imageFileName");

    final mahasiswaData = MahasiswaEntity(
        nim: 111,
        name: dataMhs.firstName + " " + dataMhs.lastName,
        asal: dataMhs.residence,
        email: dataMhs.email,
        phoneNumber: dataMhs.phone,
        fakultas: dataMhs.faculty,
        jurusan: dataMhs.major,
        dateOfBirth: dataMhs.dateOfBirth,
        gender: dataMhs.gender,
        image: imageFileName);

    BlocProvider.of<MahasiswaBloc>(context)
        .add(CreateMahasiswaEvent(mahasiswaData));
  }
}
