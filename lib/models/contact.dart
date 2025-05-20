import 'dart:typed_data';

class Contact {
  final String id;
  final String name;
  final String phoneNumber;
  final String? email;
  final List<String> categories;
  final Uint8List? photo;
  final DateTime? savedTimestamp;
  final String? location;
  final String? meetingEvent;
  final String? notes;
  final String? company;
  final bool isFavorite;
  final List<Map<String, String>>? addresses;

  Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.email,
    this.categories = const [],
    this.photo,
    this.savedTimestamp,
    this.location,
    this.meetingEvent,
    this.notes,
    this.company,
    this.isFavorite = false, 
    this.addresses,
  });

  Contact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    List<String>? categories,
    Uint8List? photo,
    DateTime? savedTimestamp,
    String? location,
    String? meetingEvent,
    String? notes,
    String? company,
    bool? isFavorite, 
    List<Map<String, String>>? addresses,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      categories: categories ?? this.categories,
      photo: photo ?? this.photo,
      savedTimestamp: savedTimestamp ?? this.savedTimestamp,
      location: location ?? this.location,
      meetingEvent: meetingEvent ?? this.meetingEvent,
      notes: notes ?? this.notes,
      company: company ?? this.company,
      isFavorite: isFavorite ?? this.isFavorite, 
      addresses: addresses ?? this.addresses,
    );
  }
}
