import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final DateTime date;
  final String header;
  final String body;
  final String? imageUrl;

  Post({
    required this.date,
    required this.header,
    required this.body,
    this.imageUrl,
  });

  // Firestore'dan alınan verilerle Post nesnesi oluşturma
  factory Post.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Post(
      date: (data['date'] as Timestamp).toDate(),
      header: data['header'],
      body: data['body'],
      imageUrl: data['imageUrl'],
    );
  }
}
