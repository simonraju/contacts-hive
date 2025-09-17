import 'dart:io';
import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/storage_service.dart';
import 'add_contact_screen.dart';
import 'edit_contact_screen.dart';
import 'package:contacts_secure_storage/screens/view_contact_screen.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final StorageService storage = StorageService();
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    contacts = await storage.getContacts();
    setState(() {});
  }

  Future<void> _deleteContact(String id) async {
    await storage.deleteContact(id); 
    await _loadContacts(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contacts")),
      body: contacts.isEmpty
          ? const Center(child: Text("No contacts available"))
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return Dismissible(
                  key: Key(contact.id),
                  direction: DismissDirection.horizontal,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.amber,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.edit, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      // 👉 Edit instead of dismiss
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditContactScreen(contact: contact),
                        ),
                      );
                      await _loadContacts(); 
                      return false;
                    } else if (direction == DismissDirection.startToEnd) {
                      bool? confirm = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Delete Contact"),
                          content: Text(
                              "Are you sure you want to delete ${contact.name}?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await _deleteContact(contact.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Contact ${contact.name} deleted')),
                        );
                      }
                      return false;
                    }
                    return false;
                  },
                  child: Card(
                    color: Colors.white,
                    child: ListTile(
                      leading: (contact.imagePath != null &&
                              File(contact.imagePath!).existsSync())
                          ? CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.amber,
                              child: CircleAvatar(
                                backgroundImage:
                                    FileImage(File(contact.imagePath!)),
                                radius: 25,
                              ),
                            )
                          : const CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.amber,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 25,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                      title: Text(contact.name),
                      subtitle: Text(contact.phone),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ViewContactScreen(contact: contact),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddContactScreen()),
          );
          _loadContacts(); 
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
