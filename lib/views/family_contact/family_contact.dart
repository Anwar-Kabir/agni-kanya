import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:woman_safety/controllers/family_controller.dart';
import 'package:woman_safety/utils/strings.dart';
import 'package:woman_safety/views/home/home.dart';
import 'package:woman_safety/widgets/app_text_form_field.dart';
import '../../widgets/custom_button.dart';

class FamilyContact extends StatefulWidget {
  const FamilyContact({super.key});

  @override
  State<FamilyContact> createState() => _FamilyContactState();
}

class _FamilyContactState extends State<FamilyContact>
    with SingleTickerProviderStateMixin {
  bool isWhatsapp = false;
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  Future<void> _onNextPressed(FamilyController familyController) async {
    if (_tabController.index == 0) {
      // If on the Family tab, validate the form and then call the API
      if (_formKey.currentState!.validate()) {
        await familyController.createFamily();

        // If Family API is successful, move to the Friends tab
        if (familyController.isFamilyCreated.isTrue) {
          print("Family API call was successful");
          _tabController.animateTo(_tabController.index + 1);
        } else {
          print("Family API call failed");
        }
      }
    } else if (_tabController.index == 1) {
      // If on the Friends tab, validate the form and then call the API
      if (_formKey.currentState!.validate()) {
        await familyController.createFriends();

        // If Friends API is successful, move to the WhatsApp tab
        if (familyController.isFriendsCreated.isTrue) {
          print("Friends API call was successful");
          _tabController.animateTo(_tabController.index + 1);
        } else {
          print("Friends API call failed");
        }
      }
    } else if (_tabController.index < 2) {
      // Simply move to the next tab
      _tabController.animateTo(_tabController.index + 1);
    } else {
      // If it's the last tab, go to the Home screen
      Get.to(const Home());
    }
  }

  /////=============================<<<<<< group code requried, its need in next update
  // Future<void> _onNextPressed(FamilyController familyController) async {
  //   if (_tabController.index == 0) {
  //     // If on the Family tab, validate the form and then call the API
  //     if (_formKey.currentState!.validate()) {
  //       await familyController.createFamily();

  //       // If Family API is successful, move to the Friends tab
  //       if (familyController.isFamilyCreated.isTrue) {
  //         print("Family API call was successful");
  //         _tabController.animateTo(_tabController.index + 1);
  //       } else {
  //         print("Family API call failed");
  //       }
  //     }
  //   } else if (_tabController.index == 1) {
  //     // If on the Friends tab, validate the form and then call the API
  //     if (_formKey.currentState!.validate()) {
  //       await familyController.createFriends();

  //       // If Friends API is successful, move to the WhatsApp tab
  //       if (familyController.isFriendsCreated.isTrue) {
  //         print("Friends API call was successful");
  //         _tabController.animateTo(_tabController.index + 1);
  //       } else {
  //         print("Friends API call failed");
  //       }
  //     }
  //   } else if (_tabController.index == 2) {
  //     // If on the WhatsApp tab, validate the form and then call the API
  //     if (_formKey.currentState!.validate()) {
  //       await familyController.createWhatsAppGroupLink();

  //       // If WhatsApp API is successful, go to the Home screen
  //       if (familyController.isWhatsAppGrouplinkCreated.isTrue) {
  //         print("WhatsApp API call was successful");
  //         Get.to(const Home());
  //       } else {
  //         print("WhatsApp API call failed");
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final familyController = Get.put(FamilyController());

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back_ios),
        title: const Text('Add Emergency Contacts',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
              child: Text('Step ${_tabController.index + 1} of 3',
                  style: const TextStyle(fontSize: 16, color: Colors.black))),
          const SizedBox(height: 20),
          IgnorePointer(
            child: TabBar(
            
              controller: _tabController,
              tabs: const [
                Tab(text: 'FAMILY'),
                Tab(text: 'FRIENDS'),
                Tab(text: 'WHATSAPP'),
              ],
              indicatorColor: Colors.yellow,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black54,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Form(
                key: _formKey,
                child: TabBarView(
                  controller: _tabController,
                   physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildFamilyForm(familyController),
                    _buildFriendsForm(familyController),
                    _buildWhatsAppForm(familyController),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              text: AppStrings.personalInfoNext,
              onPressed: () {
                _onNextPressed(familyController);
              },
            ),
          ),
        ],
      ),
    );
  }

 
  //family form

  Widget _buildFamilyForm(FamilyController familyController) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Person One',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Row(
            children: [
              Text(
                AppStrings.personalInfoName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                "*",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          AppTextFormField(
            hintText: AppStrings.familyNameHints,
            controller: familyController.familyNameController,
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
                AppStrings.familyPhone,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                "*",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          AppTextFormField(
            hintText: AppStrings.familyPhoneHints,
            controller: familyController.familyPhoneController,
            keyboardType: TextInputType.number,
            maxLength: 10,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Phone';
              }
              if (value.length != 10 ||
                  !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                return 'Please enter a valid 10-digit phone number';
              }
              return null;
            },
            onChanged: (value) {
              if (isWhatsapp) {
                // When the toggle is on, update WhatsApp field with phone number
                familyController.familyWhatsAppController.text = value!;
              }
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Is this your WhatsApp?',
                  style: TextStyle(fontSize: 16)),
              const Spacer(),
              Switch(
                value: isWhatsapp,
                activeTrackColor: Colors.yellow,
                onChanged: (value) {
                  setState(() {
                    isWhatsapp = value;
                    if (isWhatsapp) {
                      // Copy phone number to WhatsApp number when toggled on
                      familyController.familyWhatsAppController.text =
                          familyController.familyPhoneController.text;
                    } else {
                      // Clear WhatsApp number when toggled off (optional)
                      familyController.familyWhatsAppController.clear();
                    }
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Text(
                AppStrings.familyWhatsAppNumber,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                "*",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          AppTextFormField(
            hintText: AppStrings.familyWhatsAppNumberHints,
            controller: familyController.familyWhatsAppController,
            keyboardType: TextInputType.number,
            maxLength: 10,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your WhatsApp Number';
              }
              if (value.length != 10 ||
                  !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                return 'Please enter a valid 10-digit phone number';
              }
              return null;
            },
            enabled: !isWhatsapp, // Disable WhatsApp field if toggle is on
          ),
          const Spacer(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // friends
  bool isFriendWhatsapp = false;

  Widget _buildFriendsForm(FamilyController familyController) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Person One',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Row(
            children: [
              Text(
                AppStrings.personalInfoName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                "*",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          AppTextFormField(
            hintText: AppStrings.friendsNameHints,
            controller: familyController.friendNameController,
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
                AppStrings.familyPhone,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                "*",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
         
          AppTextFormField(
            hintText: AppStrings.friendsPhoneHints,
            controller: familyController.friendPhoneController,
            keyboardType: TextInputType.number,
            maxLength: 10,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Phone';
              }
              if (value.length != 10 ||
                  !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                return 'Please enter a valid 10-digit phone number';
              }
              // Check if the phone number matches the family phone number
              if (value == familyController.familyPhoneController.text) {
                return 'Phone number cannot be the same as Family member\'s';
              }
              return null;
            },
            onChanged: (value) {
              if (isFriendWhatsapp) {
                familyController.friendWhatsAppController.text = value!;
              }
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Is this your WhatsApp?',
                  style: TextStyle(fontSize: 16)),
              const Spacer(),
              Switch(
                value: isFriendWhatsapp,
                activeTrackColor: Colors.yellow,
                onChanged: (value) {
                  setState(() {
                    isFriendWhatsapp = value;
                    if (isFriendWhatsapp) {
                      // Copy phone number to WhatsApp when toggled on
                      familyController.friendWhatsAppController.text =
                          familyController.friendPhoneController.text;
                    } else {
                      // Optionally clear WhatsApp number when toggled off
                      familyController.friendWhatsAppController.clear();
                    }
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Text(
                AppStrings.friendsWhatsAppNumberHints,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                "*",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          AppTextFormField(
            hintText: AppStrings.friendsWhatsAppNumberHints,
            controller: familyController.friendWhatsAppController,
            keyboardType: TextInputType.number,
            maxLength: 10,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your WhatsApp Number';
              }
              if (value.length != 10 ||
                  !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                return 'Please enter a valid 10-digit phone number';
              }
              return null;
            },
            enabled:
                !isFriendWhatsapp, // Disable WhatsApp field if toggle is on
          ),
          const Spacer(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // whatsapp form

  Widget _buildWhatsAppForm(FamilyController familyController) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                AppStrings.whatsAppGroupLink,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                "",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          AppTextFormField(
            hintText: AppStrings.whatsAppGroupLinkhint,
            controller: familyController.whatsAppGroupLink,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your WhatsApp group link';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 5,
          ),
          const Text("Whats app group link optional, you can go next"),
          const Spacer(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
