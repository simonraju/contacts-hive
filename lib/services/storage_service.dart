import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/contact.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();
  final String _key = "contacts";

  Future<List<Contact>> getContacts() async {
    String? data = await _storage.read(key: _key);
    if (data == null) return [];
    List decoded = jsonDecode(data);
    return decoded.map((c) => Contact.fromJson(c)).toList();
  }

Future<void> saveContacts(List<Contact> contacts) async {
  final jsonList = contacts.map((c) => c.toJson()).toList();
  await _storage.write(key: 'contacts', value: jsonEncode(jsonList));
}

  Future<void> addContact(Contact contact) async {
    List<Contact> contacts = await getContacts();
    contacts.add(contact);
    await saveContacts(contacts);
  }

  Future<void> updateContact(Contact updated) async {
    List<Contact> contacts = await getContacts();
    contacts = contacts.map((c) => c.id == updated.id ? updated : c).toList();
    await saveContacts(contacts);
  }

Future<void> deleteContact(String id) async {
  final contacts = await getContacts(); 
  final updated = contacts.where((c) => c.id != id).toList();
  await saveContacts(updated);
}
}
