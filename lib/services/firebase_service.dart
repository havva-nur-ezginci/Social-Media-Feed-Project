import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String collectionName = 'posts';
  static const int pageSize = 5;

  // Yeni bir gönderi ekleme metodu
  Future<void> addPost({
    required String header,
    required String body,
    String? imageUrl,
  }) async {
    try {
      DateTime now = DateTime.now(); // Mevcut tarihi al
      await _db.collection(collectionName).add({
        'date': Timestamp.fromDate(now), // Gönderinin tarihi
        'header': header,
        'body': body,
        'imageUrl': imageUrl,
      });
    } catch (e) {
      print('Error adding post: $e'); // Hata mesajını yazdır
      throw Exception('Failed to add post'); // Hata fırlat
    }
  }

  // Gönderileri alma metodu
  Future<QuerySnapshot> getPosts({DocumentSnapshot? lastDocument}) async {
    try {
      // Gönderileri tarihe göre sıralayıp sayfa boyutunda sınırla
      Query query = _db
          .collection(collectionName)
          .orderBy('date', descending: true) // Tarihe göre sıralama
          .limit(pageSize);

      // Son doküman belirtilmişse ondan sonraki dokümanları al
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      return await query.get(); // Sorguyu çalıştır ve sonucu döndür
    } catch (e) {
      print('Error getting posts: $e'); // Hata mesajını yazdır
      throw Exception('Failed to get posts'); // Hata fırlat
    }
  }

  // Resim yükleme metodu
  Future<String> uploadImage(String filePath) async {
    try {
      File file = File(filePath); // Yüklenecek dosyayı oluştur
      String fileName = DateTime.now()
          .millisecondsSinceEpoch
          .toString(); // Dosya adı olarak zaman damgası kullan
      Reference ref = _storage
          .ref()
          .child('post_images')
          .child(fileName); // Depolama referansı oluştur
      UploadTask uploadTask = ref.putFile(file); // Dosyayı yükle
      TaskSnapshot snapshot = await uploadTask; // Yükleme sonucunu al
      return await snapshot.ref
          .getDownloadURL(); // Yüklenen dosyanın URL'sini döndür
    } catch (e) {
      print('Error uploading image: $e'); // Hata mesajını yazdır
      throw Exception('Failed to upload image'); // Hata fırlat
    }
  }
}
