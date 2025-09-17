import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/contact.dart';
import '../services/storage_service.dart';

class EditContactScreen extends StatefulWidget {
  final Contact contact;
  const EditContactScreen({super.key, required this.contact});

  @override
  State<EditContactScreen> createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  File? _imageFile;
  final StorageService storage = StorageService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact.name);
    _phoneController = TextEditingController(text: widget.contact.phone);
    _emailController = TextEditingController(text: widget.contact.email);
    if (widget.contact.imagePath != null &&
        File(widget.contact.imagePath!).existsSync()) {
      _imageFile = File(widget.contact.imagePath!);
    }
  }


  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }


  Future<String> _saveImagePermanently(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final savedImage = await image.copy("${directory.path}/$fileName.jpg");
    return savedImage.path;
  }

 
  void _updateContact() async {
    if (_formKey.currentState!.validate()) {
      String? imagePath = widget.contact.imagePath;

      if (_imageFile != null &&
          (_imageFile!.path != widget.contact.imagePath)) {
        imagePath = await _saveImagePermanently(_imageFile!);
      }

      final updated = Contact(
        id: widget.contact.id,
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        imagePath: imagePath,
      );

      await storage.updateContact(updated);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Contact"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
          
              CircleAvatar(
                radius: 64,
                backgroundColor: Colors.amber,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                  child: _imageFile == null
                      ? const Icon(Icons.person, size: 60, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                ),
                onPressed: pickImage,
                child: Text(_imageFile == null ? 'Add Photo' : 'Change Photo'),
              ),

              const SizedBox(height: 30),

              
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  contentPadding: const EdgeInsets.all(20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide:
                        const BorderSide(color: Colors.amber, width: 2.0),
                  ),
                ),
                validator: (v) => v!.trim().isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 30),

              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  contentPadding: const EdgeInsets.all(20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide:
                        const BorderSide(color: Colors.amber, width: 2.0),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (v) => v!.trim().isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 30),

              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  contentPadding: const EdgeInsets.all(20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide:
                        const BorderSide(color: Colors.amber, width: 2.0),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _updateContact,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
