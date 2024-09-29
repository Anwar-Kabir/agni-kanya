


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woman_safety/controllers/login_controller.dart';
import 'package:woman_safety/controllers/personalinfo_controller.dart';
import 'package:woman_safety/controllers/profile_details_controller.dart';
import 'package:woman_safety/controllers/state_controller.dart';
import 'package:woman_safety/utils/images.dart';
import 'package:woman_safety/utils/strings.dart';
import 'package:woman_safety/widgets/app_text_form_field.dart';
import 'package:woman_safety/widgets/custom_button.dart';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final loginController = Get.put(LoginController());
  final personalController = Get.put(PersonalinfoController());

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  final _formKey = GlobalKey<FormState>(); // GlobalKey for form validation
  final TextEditingController _zipController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  var isLoading = false.obs;

  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    personalController
        .fetchPersonalInfo(); // Fetch personal info when the page loads
  }

  @override
  Widget build(BuildContext context) {
    // final personalController = Get.put(PersonalinfoController());
    final stateController = Get.put(StateController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (personalController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        // Avatar and Image Picker Logic
                        Center(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 65,
                                backgroundColor: Colors.green[100],
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: _imageFile != null
                                      ? FileImage(File(_imageFile!.path))
                                      : (personalController
                                                  .avaterlink.isNotEmpty
                                              ? NetworkImage(personalController
                                                  .avaterlink.value)
                                              : const AssetImage(
                                                  AppImages.personallogo))
                                          as ImageProvider,
                                ),
                              ),
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () {
                                    _showImageSourceActionSheet(context);
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            Text(
                              AppStrings.personalInfoName,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Text("*", style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        AppTextFormField(
                          hintText: AppStrings.personalInfoNamehint,
                          controller: personalController.nameController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }

                            return null;
                          },
                        ),

                        

                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Text(
                              AppStrings.personalInfoPhone,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Text("*", style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        
                        AppTextFormField(
                          hintText: AppStrings.personalInfoEmailhint,
                          controller: personalController.phoneController,
                          keyboardType: TextInputType.number,
                          enabled: false,
                          validator: (value) {
                            // if (value == null || value.isEmpty) {
                            //   return 'Please enter your phone';
                            // }

                            // return null;
                            final RegExp phoneRegex = RegExp(r'^[6-9]\d{9}$');
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Phone';
                            } else if (!phoneRegex.hasMatch(value)) {
                              return 'Enter a valid 10-digit phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Text(
                              AppStrings.personalInfoEmail,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Text("*", style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        AppTextFormField(
                          hintText: AppStrings.personalInfoEmailhint,
                          controller: personalController.emailController,
                          keyboardType: TextInputType.emailAddress,
                          enabled: false,
                          validator: (value) {
                            // if (value == null || value.isEmpty) {
                            //   return 'Please enter your Email';
                            // }

                            // return null;
                            final RegExp emailRegex = RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Email';
                            } else if (!emailRegex.hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        // State
                        const Row(
                          children: [
                            Text(
                              AppStrings.personalInfoState,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        Obx(() {
                          return AppTextFormField(
                            hintText: 'Select State',
                            controller: TextEditingController(
                                text: personalController.selectedState.value),
                            isDropdown: true,
                            dropdownItems: stateController.states.map((state) {
                              return DropdownMenuItem<String>(
                                value: state['id'].toString(),
                                child: Text(state['name']),
                              );
                            }).toList(),
                            dropdownValue: stateController.selectedState.value,
                            onChanged: (String? value) {
                              stateController.updateSelectedState(value);
                              personalController.selectedState.value = value!;
                            },
                            validator: (value) {
                              if (stateController.selectedState.value == null) {
                                return 'Please select your State';
                              }
                              return null;
                            },
                          );
                        }),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Text(
                              AppStrings.personalInfoCity,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        Obx(() {
                          return AppTextFormField(
                            hintText: 'Select City',
                            controller: TextEditingController(
                                text: personalController.selectedCity.value),
                            isDropdown: true,
                            dropdownItems: stateController.cities.map((city) {
                              return DropdownMenuItem<String>(
                                value: city['id'].toString(),
                                child: Text(city['name']),
                              );
                            }).toList(),
                            dropdownValue: stateController.selectedCity.value,
                            onChanged: (String? value) {
                              stateController.updateSelectedCity(value);
                              personalController.selectedCity.value = value!;
                            },
                            validator: (value) {
                              if (stateController.selectedCity.value == null) {
                                return 'Please select your City';
                              }
                              return null;
                            },
                          );
                        }),

                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Text(
                              AppStrings.personalInfoZip,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),

                        // For the ZIP Code (automatically populated based on selected city) ======>working

                        Column(
                          children: [
                            // Switch to select whether to show custom ZIP field or auto-filled ZIP field

                            const SizedBox(
                              height: 10,
                            ),

                            // Conditionally display either the custom ZIP code field or the auto-filled ZIP code field
                            Obx(() {
                              return personalController.isCustomZipCode.value
                                  ? AppTextFormField(
                                      hintText: 'ZIP Code',
                                      controller: personalController
                                          .zipeController, // Use the controller directly
                                      keyboardType: TextInputType.number,
                                      enabled:
                                          true, // Enable input when switch is on
                                      maxLength: 6,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your ZIP code';
                                        }
                                        return null; // No error
                                      },
                                    )
                                  : const SizedBox
                                      .shrink(); // If the switch is on, hide the auto-filled ZIP
                            }),

                            Obx(() {
                              return !personalController.isCustomZipCode.value
                                  ? AppTextFormField(
                                      hintText: 'Auto-filled ZIP Code',
                                      controller: TextEditingController(
                                          text: stateController.zipCode.value ??
                                              '' // Fetches the ZIP code
                                          ),
                                      keyboardType: TextInputType.text,
                                      enabled:
                                          false, // ZIP code is auto-filled and can't be edited manually

                                      validator: (value) {
                                        if (stateController.zipCode.value ==
                                                null ||
                                            stateController
                                                .zipCode.value!.isEmpty) {
                                          return 'ZIP code not available';
                                        }
                                        personalController.zipeController.text =
                                            value!;
                                        return null;
                                      },
                                    )
                                  : const SizedBox.shrink();
                            }),

                            Obx(() {
                              return SwitchListTile(
                                activeTrackColor: Colors.yellow,
                                title: const Text("This is not my ZIP code"),
                                value: personalController.isCustomZipCode.value,
                                onChanged: (value) {
                                  personalController.isCustomZipCode.value =
                                      value;
                                  if (!value) {
                                    // If the switch is turned off, clear the custom ZIP input
                                    personalController.zipeController.clear();
                                  }
                                },
                              );
                            }),
                          ],
                        ),

                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Text(
                              AppStrings.personalInfoAddress,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                             
                          ],
                        ),
                        AppTextFormField(
                          hintText: AppStrings.personalInfoAddresshint,
                          controller: personalController.addressController,
                          keyboardType: TextInputType.text,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter your Address';
                          //   }
                          //   personalController.addressController.text = value;
                          //   return null;
                          // },
                        ),
                        const SizedBox(height: 35),
                        CustomButton(
                          text: "Update personal info",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // if (_imageFile == null) {
                              //   Get.snackbar(
                              //     "Error",
                              //     "Please select an image",
                              //     snackPosition: SnackPosition.TOP,
                              //     backgroundColor: Colors.red,
                              //     colorText: Colors.white,
                              //   );
                              //   return;
                              // }
                              //final imagePath = _imageFile!.path;
                              final imagePath =
                                  _imageFile != null ? _imageFile!.path : "";
                              personalController.submitPersonalInfo(imagePath,
                                  pageNmae: "editprofile");
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Obx(() {
                return personalController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink();
              }),
            ],
          );
        }),
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
