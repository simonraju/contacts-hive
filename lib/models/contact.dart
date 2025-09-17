class Contact {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? imagePath;

  Contact({required this.id, required this.name, required this.phone, this.email, this.imagePath});

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
        "imagePath": imagePath
      };

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json["id"],
      name: json["name"],
      phone: json["phone"],
      email: json["email"],
      imagePath: json["imagePath"]
    );
  }
}
