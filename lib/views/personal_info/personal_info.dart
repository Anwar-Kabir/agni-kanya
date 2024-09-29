import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:woman_safety/controllers/login_controller.dart';
import 'package:woman_safety/controllers/personalinfo_controller.dart';
import 'package:woman_safety/controllers/state_controller.dart';
import 'package:woman_safety/utils/images.dart';
import 'package:woman_safety/utils/strings.dart';
import 'package:woman_safety/widgets/app_text_form_field.dart';
import 'package:woman_safety/widgets/custom_button.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final loginController = Get.put(LoginController());

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

  String? _selectedCity;

  @override
  Widget build(BuildContext context) {
    final personalController = Get.put(PersonalinfoController());
    final stateController = Get.put(StateController());
    String phoneNumber = loginController.phoneController.text;

    return SafeArea(
      child: Scaffold(
        body: Stack(
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
                      const Center(
                        child: Text(
                          AppStrings.personalInfo,
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ),
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
                                    : const AssetImage(AppImages.personallogo)
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
                      const SizedBox(height: 20),
                      const Row(
                        children: [
                          Text(
                            AppStrings.personalInfoName,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "*",
                            style: TextStyle(color: Colors.red),
                          ),
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
                          Text(
                            "*",
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      AppTextFormField(
                        hintText: AppStrings.personalInfoPhonehint,
                         controller: personalController.phoneController,
                        //controller: loginController.phoneController,
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        validator: (value) {
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
                          Text(
                            "*",
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),

                      AppTextFormField(
                        hintText: AppStrings.personalInfoEmailhint,
                        controller: personalController.emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
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

                      //state
                      Obx(() {
                        return AppTextFormField(
                          hintText: 'Select State',
                          controller: TextEditingController(),
                          isDropdown: true,
                          dropdownItems: stateController.states.map((state) {
                            return DropdownMenuItem<String>(
                              value: state['id'].toString(), // Pass state ID
                              child: Text(state['name']),
                            );
                          }).toList(),
                          dropdownValue: stateController.selectedState.value,
                          onChanged: (String? value) {
                            stateController.updateSelectedState(value);
                            personalController.selectedState.value = value!;
                            debugPrint(personalController.selectedState.value);
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

                      //city
                      Obx(() {
                        return AppTextFormField(
                          hintText: 'Select City',
                          controller: TextEditingController(),
                          isDropdown: true,
                          dropdownItems: stateController.cities.map((city) {
                            return DropdownMenuItem<String>(
                              value: city['id'].toString(), // Pass city ID
                              child: Text(city['name']),
                            );
                          }).toList(),
                          dropdownValue: stateController.selectedCity.value,
                          onChanged: (String? value) {
                            stateController.updateSelectedCity(value);
                            personalController.selectedCity.value = value!;
                            debugPrint(personalController.selectedCity.value);
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

                      //  Obx(() {
                      //   return AppTextFormField(
                      //     hintText: 'ZIP Code',
                      //     controller: TextEditingController(
                      //         text: stateController.zipCode.value ??
                      //             '' // Fetches the ZIP code
                      //         ),
                      //     keyboardType: TextInputType.text,
                      //     enabled:
                      //         false, // ZIP code is auto-filled and can't be edited manually

                      //     validator: (value) {
                      //       if (stateController.zipCode.value == null ||
                      //           stateController.zipCode.value!.isEmpty) {
                      //         return 'ZIP code not available';
                      //       }
                      //       personalController.zipeController.text = value!;
                      //       return null;
                      //     },
                      //   );
                      // }),

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
                          // Obx(() {
                          //   return !personalController.isCustomZipCode.value
                          //       ? AppTextFormField(
                          //           hintText: 'Auto-filled ZIP Code',
                          //           controller: TextEditingController(
                          //             text: stateController.zipCode.value ?? '',
                          //           ),
                          //           keyboardType: TextInputType.number,
                          //           enabled:
                          //               false, // This field is disabled as it's auto-filled
                          //           validator: (value) {
                          //             if (stateController.zipCode.value ==
                          //                     null ||
                          //                 stateController
                          //                     .zipCode.value!.isEmpty) {
                          //               return 'ZIP code not available';
                          //             }
                          //             return null; // No error
                          //           },
                          //         )
                          //       : SizedBox
                          //           .shrink(); // Hide auto-filled ZIP if custom ZIP is enabled
                          // }),

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
                        //   return null;
                        // },
                      ),
                      const SizedBox(height: 35),
                      // CustomButton(
                      //   text: AppStrings.personalInfoNext,
                      //   onPressed: () {
                      //     if (_formKey.currentState!.validate()) {
                      //       final imagePath =
                      //           _imageFile != null ? _imageFile!.path : "";
                      //       personalController.submitPersonalInfo(imagePath);
                      //     }
                      //   },
                      // ),

                      CustomButton(
                        text: AppStrings.personalInfoNext,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Check if an image has been selected
                            //========>image is requried snack bar
                            // if (_imageFile == null) {
                            //   // Show error in snack bar if no image is selected
                            //   Get.snackbar(
                            //     "Error",
                            //     "Please select an image",
                            //     snackPosition: SnackPosition.TOP,
                            //     backgroundColor: Colors.red,
                            //     colorText: Colors.white,
                            //   );
                            //   return; // Prevent further execution
                            // }

                            // Proceed with submitting personal info if the image is selected
                            final imagePath =
                                _imageFile != null ? _imageFile!.path : "";
                            personalController.submitPersonalInfo(imagePath);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Circular Progress Indicator
            Obx(() {
              return personalController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox.shrink();
            }),
          ],
        ),
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
