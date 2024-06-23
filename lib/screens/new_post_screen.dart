import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_feed/services/firebase_service.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _headerController = TextEditingController();
  final _bodyController = TextEditingController();
  final _imageUrlController = TextEditingController();

  final FirebaseService _firebaseService = FirebaseService();

  bool _isLoading = false;
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  // Gönderi oluşturma
  void _createPost() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String header = _headerController.text.trim();
      String body = _bodyController.text.trim();
      String? imageUrl;

      // Görsel yükleme işlemi
      if (_imageFile != null) {
        imageUrl = await _firebaseService.uploadImage(_imageFile!.path);
      } else if (_imageUrlController.text.trim().isNotEmpty) {
        imageUrl = _imageUrlController.text.trim();
      }

      try {
        await _firebaseService.addPost(
          header: header,
          body: body,
          imageUrl: imageUrl,
        );
        Navigator.pop(context); // Yeni post oluşturulduktan sonra geri dön
      } catch (e) {
        print('Error creating post: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Gönderi oluşturulamadı. Tekrar deneyin.')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Görsel seçme metodu
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Gönderi Oluştur'),
      ),
      body: _isLoading // yükleme durumu
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //Header
                      TextFormField(
                        controller: _headerController,
                        decoration: const InputDecoration(labelText: 'Başlık'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen bir başlık girin';
                          }
                          return null;
                        },
                      ),
                      //Body
                      TextFormField(
                        controller: _bodyController,
                        decoration: const InputDecoration(labelText: 'İçerik'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen bir içerik girin';
                          }
                          return null;
                        },
                      ),
                      // Image Url
                      TextFormField(
                        controller: _imageUrlController,
                        decoration: const InputDecoration(
                          labelText: 'Görsel URL (opsiyonel)',
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Resim seçildiyse görseli göster
                      if (_imageFile != null)
                        Image.file(
                          _imageFile!,
                          height: 150,
                        ),
                      //Galeriden Resim Seç Butonu
                      ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: const Text('Galeriden Resim Seç'),
                      ),
                      const SizedBox(height: 12),
                      // Gönderi Oluştur Butonu
                      ElevatedButton(
                        onPressed: _createPost,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: const Text('Gönderi Oluştur'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
