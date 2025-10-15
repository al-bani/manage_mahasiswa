import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/widgets/components.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/widgets/button.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/widgets/text_field.dart';
import '../create.dart'; // Import FormDataModel

class StepOneForm extends StatefulWidget {
  final VoidCallback onNext;
  final FormDataModel formData;
  final Function({
    File? image,
    String? firstName,
    String? lastName,
    String? username,
  }) onDataUpdate;

  const StepOneForm({
    super.key,
    required this.onNext,
    required this.formData,
    required this.onDataUpdate,
  });

  @override
  State<StepOneForm> createState() => _StepOneFormState();
}

class _StepOneFormState extends State<StepOneForm> {
  final ValueNotifier<File?> selectedImage = ValueNotifier<File?>(null);
  final picker = ImagePicker();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load existing data
    selectedImage.value = widget.formData.image;
    firstNameController.text = widget.formData.firstName;
    lastNameController.text = widget.formData.lastName;
    usernameController.text = widget.formData.username;
  }

  void _onNext() {
    // Update data before moving to next step
    widget.onDataUpdate(
      image: selectedImage.value,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      username: usernameController.text,
    );
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Scrollable content area
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ValueListenableBuilder<File?>(
                    valueListenable: selectedImage,
                    builder: (context, image, child) {
                      final screenSize = MediaQuery.of(context).size;
                      // Responsive image size berdasarkan lebar layar
                      double imageSize;
                      if (screenSize.width < 360) {
                        imageSize = screenSize.width *
                            0.3; // 30% untuk layar sangat kecil
                      } else if (screenSize.width < 600) {
                        imageSize =
                            screenSize.width * 0.25; // 25% untuk layar kecil
                      } else if (screenSize.width < 900) {
                        imageSize =
                            screenSize.width * 0.2; // 20% untuk layar medium
                      } else {
                        imageSize =
                            screenSize.width * 0.15; // 15% untuk layar besar
                      }

                      // Batasi ukuran minimum dan maksimum
                      imageSize = imageSize.clamp(80.0, 150.0);

                      return Container(
                        width: imageSize,
                        height: imageSize,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: image == null
                            ? Stack(
                                children: [
                                  InkWell(
                                    onTap: () => _showImagePicker(
                                        context, selectedImage, picker),
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: const BoxDecoration(
                                        color: AppColors.secondary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.person,
                                            size: 60,
                                            color: AppColors.white,
                                          ),
                                          SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    height: 30,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                        onPressed: () => _showImagePicker(
                                            context, selectedImage, picker),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: FileImage(image),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    height: 30,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                        onPressed: () {
                                          selectedImage.value = null;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isSmallScreen = constraints.maxWidth < 600;

                      if (isSmallScreen) {
                        // Layout vertikal untuk layar kecil
                        return Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "First Name",
                                  style: AppTextStyles.openSansBoldItalic(
                                      fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                FormTextField(
                                  controller: firstNameController,
                                  hintText: "Enter your first name",
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Last Name",
                                  style: AppTextStyles.openSansBoldItalic(
                                      fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                FormTextField(
                                  controller: lastNameController,
                                  hintText: "Enter your last name",
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        // Layout horizontal untuk layar besar
                        return Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "First Name",
                                    style: AppTextStyles.openSansBoldItalic(
                                        fontSize: 12),
                                  ),
                                  const SizedBox(height: 4),
                                  FormTextField(
                                    controller: firstNameController,
                                    hintText: "Enter your first name",
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Last Name",
                                    style: AppTextStyles.openSansBoldItalic(
                                        fontSize: 12),
                                  ),
                                  const SizedBox(height: 4),
                                  FormTextField(
                                    controller: lastNameController,
                                    hintText: "Enter your last name",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Username",
                        style: AppTextStyles.openSansBoldItalic(fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: FormTextField(
                                controller: usernameController,
                                hintText: "Enter your username"),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            child: Text(
                              "Check",
                              style: AppTextStyles.openSansBold(
                                  fontSize: 12, color: AppColors.secondary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          // Fixed button area at bottom
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  flex: 2, // Button Back mendapat 2/5 dari lebar
                  child: ButtonForm(
                    onPressed: () => GoRouter.of(context).goNamed('home'),
                    text: "Back",
                    backgroundColor: AppColors.secondary,
                    textColor: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12), // Spacing antar button
                Expanded(
                  flex: 4, // Button Next mendapat 3/5 dari lebar (lebih lebar)
                  child: ButtonForm(
                    onPressed: _onNext, // Use the new method
                    text: "Next",
                    backgroundColor: AppColors.primary,
                    textColor: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showImagePicker(BuildContext context, ValueNotifier<File?> selectedImage,
    ImagePicker picker) {
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
