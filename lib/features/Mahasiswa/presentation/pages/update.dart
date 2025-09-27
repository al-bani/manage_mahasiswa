import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_mahasiswa/core/validator/validator.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/widgets/components.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_bloc.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_event.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/bloc/mahasiswa_state.dart';
import 'package:manage_mahasiswa/injection_container.dart';

class UpdateScreen extends StatelessWidget {
  final int nim;
  const UpdateScreen(this.nim, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) =>
            containerInjection<MahasiswaBloc>()..add(GetMahasiswaEvent(nim)),
        child: BlocListener<MahasiswaBloc, MahasiswaState>(
          listener: (context, state) {
            if (state is RemoteMahasiswaUpdate) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data Has Been Updated!')),
              );
              GoRouter.of(context).goNamed('detail', extra: nim);
            } else if (state is RemoteMahasiswaError) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error While Update Data')),
              );
            }
          },
          child: _appbody(context, nim),
        ),
      ),
    );
  }
}

Widget _appbody(BuildContext context, int nimMhs) {
  final Map<String, dynamic> gender = {
    "Man": const Icon(Icons.man),
    "Woman": const Icon(Icons.woman),
    "Mechanic": const Icon(Icons.miscellaneous_services_rounded),
  };

  return BlocBuilder<MahasiswaBloc, MahasiswaState>(
    builder: (context, state) {
      if (state is RemoteMahasiswaLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is RemoteMahasiswaError) {
        return Center(child: Text("Error: ${state.error!["msg"]}"));
      } else if (state is RemoteMahasiswaDone) {
        MahasiswaEntity mhs = state.mahasiswa;
        DateTime parsed = DateTime.parse(mhs.dateOfBirth!);

        String formattedDate =
            "${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}";

        final TextEditingController nameController =
            TextEditingController(text: mhs.name);
        final TextEditingController emailController =
            TextEditingController(text: mhs.email);
        final TextEditingController phoneController =
            TextEditingController(text: mhs.phoneNumber);
        final TextEditingController dateOfBirthController =
            TextEditingController(text: formattedDate);
        final TextEditingController facultyController =
            TextEditingController(text: mhs.fakultas);
        final TextEditingController majorController =
            TextEditingController(text: mhs.jurusan);
        final TextEditingController residenceController =
            TextEditingController(text: mhs.asal);

        var genderOrigin = "Mechanic";

        if (mhs.gender!.toLowerCase() == 'l' ||
            mhs.gender!.toLowerCase() == 'man') {
          genderOrigin = "Man";
        } else if (mhs.gender!.toLowerCase() == 'p' ||
            mhs.gender!.toLowerCase() == 'woman') {
          genderOrigin = "Woman";
        }

        final ValueNotifier<String?> selectedValue =
            ValueNotifier<String?>(genderOrigin);

        return SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Update Mahasiswa",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                NormalFiled(text: "Name", controller: nameController),
                const SizedBox(height: 10),
                NormalFiled(text: "Email", controller: emailController),
                const SizedBox(height: 10),
                NormalFiled(text: "Phone Number", controller: phoneController),
                const SizedBox(height: 10),
                NormalFiled(text: "Residence", controller: residenceController),
                const SizedBox(height: 10),
                NormalFiled(text: "Faculty", controller: facultyController),
                const SizedBox(height: 10),
                NormalFiled(text: "Major", controller: majorController),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder<String?>(
                        valueListenable: selectedValue,
                        builder: (context, value, child) {
                          return DropdownButton<String>(
                            value: value,
                            hint: const Text("Select your Gender"),
                            items: gender.entries.map((entry) {
                              return DropdownMenuItem<String>(
                                value: entry.key,
                                child: Row(
                                  children: [
                                    entry.value, // Ikon dari Map
                                    const SizedBox(
                                        width: 8), // Spasi antara ikon dan teks
                                    Text(entry.key), // Teks dari Map
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              selectedValue.value = newValue;
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: dateOfBirthController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.calendar_month_outlined),
                          hintText: "Choose your birthday",
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2010),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2010),
                          );
                          if (pickedDate != null) {
                            dateOfBirthController.text =
                                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                const SizedBox(height: 20),
                state is RemoteMahasiswaLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          final dataMhs = (
                            nim: nimMhs,
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                            residence: residenceController.text,
                            faculty: facultyController.text,
                            major: majorController.text,
                            dateOfBirth: dateOfBirthController.text,
                            gender: selectedValue.value,
                          );
                          _onSubmitPressed(context, dataMhs);
                        },
                        child: const Text('Submit')),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () =>
                        GoRouter.of(context).goNamed('detail', extra: nimMhs),
                    child: const Text('Back to Home'),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return const Center(child: CircularProgressIndicator());
    },
  );
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

void _onSubmitPressed(BuildContext context, final dataMhs) {
  if (!emailCheck(dataMhs.email!)) {
    _dialogPopUp("Wrong Format Email", context);
    return;
  }

  final mahasiswaData = MahasiswaEntity(
      nim: dataMhs.nim,
      name: dataMhs.name,
      asal: dataMhs.residence,
      email: dataMhs.email,
      phoneNumber: dataMhs.phone,
      fakultas: dataMhs.faculty,
      jurusan: dataMhs.major,
      dateOfBirth: dataMhs.dateOfBirth,
      gender: dataMhs.gender,
      image: "images");

  int nim = dataMhs.nim;

  BlocProvider.of<MahasiswaBloc>(context)
      .add(UpdateMahasiswaEvent(mahasiswaData, nim));
}
