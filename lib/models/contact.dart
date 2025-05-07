import 'dart:typed_data';

class Contact {
  final String id;
  final String name;
  final String phoneNumber;
  final String? email;
  final List<String> categories;
  final Uint8List? photo;  

  Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.email,
    this.categories = const [],
    this.photo,
  });

  Contact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    List<String>? categories,
    Uint8List? photo,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      categories: categories ?? this.categories,
      photo: photo ?? this.photo,
    );
  }
}
