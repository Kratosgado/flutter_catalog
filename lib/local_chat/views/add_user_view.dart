import 'package:flutter/material.dart';
import 'package:flutter_catalog/local_chat/models/user.dart';
import 'package:image_picker/image_picker.dart'; // Add this line
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart';
import 'dart:io';

import '../isar_service.dart'; // Add this line

class AddUserView extends StatefulWidget {
  final ChatService chatService; // Receive user data as an argument
  static const routename = 'addUserView';

  const AddUserView({super.key, required this.chatService});

  @override
  MemberRegistrationFormState createState() => MemberRegistrationFormState();
}

class MemberRegistrationFormState extends State<AddUserView> {
  /*
   * String? username;
  String? email;
  String? phone;
  String? profilePicture;
   */
  final formKey = GlobalKey<FormState>();
  File? imageFile; // For storing the selected image
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize other form fields with user data if available
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  // Method to handle selecting an image from the gallery
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Member Registration Form')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: imageFile != null
                      ? Image.file(
                          imageFile!,
                          height: 200,
                          width: 200,
                        ) // Show the selected image if available
                      : Image.asset(
                          "assets/images/kratos.jpg",
                          height: 200,
                          width: 200,
                        ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: pickImage, // Call the pickImage method when the button is pressed
                    child: const Text('Select Image'),
                  ),
                ),
                // Otherwise, hide the Image widget
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'phone'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    }),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'email'),
                  validator: (value) {
                    // Add your email validation logic here
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        // Save the form data to Firestore
                        final newUser = User()
                          ..email = emailController.text
                          ..phone = phoneController.text
                          ..username = nameController.text;
                        // final appDir = await getApplicationDocumentsDirectory();
                        // final imageDir = join(appDir.path, 'profile_pics');
                        // final imagePath = join(imageDir, imageFile!.path, '${newUser.id}');

                        newUser.profilePicture = "assets/images/kratos.jpg";
                        await widget.chatService.addUser(newUser);

                        if (mounted) {
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    child: const Text('Add User'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
