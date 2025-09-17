import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/contact.dart';
import '../services/storage_service.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final StorageService storage = StorageService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
   final _emailController = TextEditingController();
    File? _imageFile; 
  

   

  Future<void> pickImage() async{
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState((){
      _imageFile = File(pickedFile.path);

      });
    }
  }


   Future<String?> _saveImagePermanently(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final savedImage = await image.copy("${directory.path}/$fileName.jpg");
    return savedImage.path; 
  }

void _saveContact() async {
  if (_formKey.currentState!.validate()) {
    String? savedImagePath;

    if (_imageFile != null) {
      savedImagePath = await _saveImagePermanently(_imageFile!);
    }

    final newContact = Contact(
      id: const Uuid().v4(),
      name: _nameController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      imagePath: savedImagePath, 
    );

    await storage.addContact(newContact);
    Navigator.pop(context);
  }
}


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Add Contact"),
      ),

      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
               radius: 64,
              backgroundColor: Colors.amber,
             child: CircleAvatar( radius: 60,
                backgroundColor: Colors.white,
              backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
              child: _imageFile == null ? Icon(Icons.person, size: 60, color: Colors.grey,) : null,
            ),
            ),
              ElevatedButton(
                 style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        
                      ),
                 onPressed: pickImage,
                 child: Text(_imageFile == null ?'Add Photo' : 'Change Photo'),
               ),

            SizedBox(height: 30),
              TextFormField(
                controller: _nameController, 
                decoration: InputDecoration(
                  labelText: 'Name',
                  contentPadding: const EdgeInsets.all(20),
                                   enabledBorder:OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      borderSide: const BorderSide(color:  Colors.amber, width: 2.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      borderSide: const BorderSide(color: Colors.red, width: 2.0), 
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      borderSide: const BorderSide(color: Colors.red, width: 2.0), 
                                    ),
                  ), 
                  validator: (v) => v!.trim().isEmpty ? 'Name is Required' : null
                  ),
                    SizedBox(height: 30),
              TextFormField(
                controller: _phoneController, 
                decoration: InputDecoration(
                  labelText: 'Phone',
                  contentPadding: const EdgeInsets.all(20),
                                   enabledBorder:OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      borderSide: const BorderSide(color:  Colors.amber, width: 2.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      borderSide: const BorderSide(color: Colors.red, width: 2.0), 
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      borderSide: const BorderSide(color: Colors.red, width: 2.0), 
                                    ),
                  ), 
                  keyboardType: TextInputType.phone, 
                  validator: (v) => v!.trim().isEmpty ? 'Phone Number is Required' : null),

                    SizedBox(height: 30),


              TextFormField(
                controller: _emailController, 
                decoration:  InputDecoration(
                  labelText: 'Email',
                  contentPadding: const EdgeInsets.all(20),
                                   enabledBorder:OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: BorderSide(color: Colors.grey, width: 2.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      borderSide: BorderSide(color:  Colors.amber, width: 2.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      borderSide: BorderSide(color: Colors.red, width: 2.0), 
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      borderSide: const BorderSide(color: Colors.red, width: 2.0), 
                                    ),
                  ), 
                  keyboardType: TextInputType.emailAddress
                  ),
              const SizedBox(height: 20),
              ElevatedButton(
                 style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.white,
                                minimumSize: Size(double.infinity, 50),
                              ),
                onPressed: () => _saveContact(), 
                child: const Text('Save')
                ),
            ],
          )
          ),
        ),
    );
  }
}
