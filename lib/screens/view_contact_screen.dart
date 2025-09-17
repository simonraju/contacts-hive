import 'dart:io';
import 'package:flutter/material.dart';
import '../models/contact.dart';

class ViewContactScreen extends StatelessWidget {
  final Contact contact;
  const ViewContactScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    final bool hasImage =
        contact.imagePath != null && File(contact.imagePath!).existsSync();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 64,
              backgroundColor: Colors.amber,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                backgroundImage: hasImage ? FileImage(File(contact.imagePath!)) : null,
                child: !hasImage
                    ? const Icon(Icons.person, size: 60, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              contact.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            Row(
              children: [
                const Icon(Icons.phone, color: Colors.amber),
                const SizedBox(width: 10),
                Text(
                  contact.phone,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const Divider(height: 30, thickness: 0.8, color: Colors.grey),

            if (contact.email != null && contact.email!.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.email, color: Colors.amber),
                  const SizedBox(width: 10),
                  Text(
                    contact.email!,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const Divider(height: 30, thickness: 0.8, color: Colors.grey),
            ],
          ],
        ),
      ),
    );
  }
}
