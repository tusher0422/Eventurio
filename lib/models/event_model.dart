import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String? id;
  final String title;
  final String description;
  final String category;
  final bool isPaid;
  final DateTime date;
  final String location;
  final String createdBy;
  final List<String> attendees;
  final double? price;
  final DateTime createdAt;

  Event({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.isPaid,
    required this.date,
    required this.location,
    required this.createdBy,
    required this.attendees,
    this.price,
    required this.createdAt,
  });


  factory Event.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? 'General',
      isPaid: data['isPaid'] ?? false,
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      location: data['location'] ?? '',
      createdBy: data['createdBy'] ?? '',
      attendees: List<String>.from(data['attendees'] ?? []),
      price: (data['price'] != null) ? (data['price'] as num).toDouble() : null,
      createdAt:
      (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'isPaid': isPaid,
      'date': Timestamp.fromDate(date),
      'location': location,
      'createdBy': createdBy,
      'attendees': attendees,
      'price': price,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Event copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    bool? isPaid,
    DateTime? date,
    String? location,
    String? createdBy,
    List<String>? attendees,
    double? price,
    DateTime? createdAt,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      isPaid: isPaid ?? this.isPaid,
      date: date ?? this.date,
      location: location ?? this.location,
      createdBy: createdBy ?? this.createdBy,
      attendees: attendees ?? this.attendees,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
