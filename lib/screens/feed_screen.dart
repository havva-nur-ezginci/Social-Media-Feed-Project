import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_feed/models/post_model.dart';
import 'package:social_media_feed/screens/new_post_screen.dart';
import 'package:social_media_feed/screens/post_detail_screen.dart';
import 'package:social_media_feed/services/firebase_service.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final FirebaseService _firebaseService = FirebaseService();

  List<Post> _posts = [];
  bool _isLoading = false; // Veriler yükleniyor mu?
  bool _isLoadingMore = false; // Daha fazla veri yükleniyor mu?
  DocumentSnapshot? _lastDocument; // Son yüklenen doküman (pagination)

  final ScrollController _scrollController =
      ScrollController(); // Listenin kaydırma olaylarını dinleme

  @override
  void initState() {
    super.initState();
    _loadPosts(); // Gönderileri yükleme işlemi başlatılıyor
    _scrollController.addListener(_scrollListener); // Liste dinleyici ekleniyor
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Liste controller kapatılıyor
    super.dispose();
  }

  // Gönderileri Firestore'dan yükleme işlemi
  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true; // Yükleme işlemi başladı
    });

    try {
      QuerySnapshot snapshot =
          await _firebaseService.getPosts(); // Firestore'dan gönderileri getir
      List<Post> posts = snapshot.docs
          .map((doc) => Post.fromSnapshot(doc))
          .toList(); // Gönderileri Post nesnesine dönüştürme
      setState(() {
        _posts = posts; // Gönderiler listesini güncelleme
        _lastDocument = snapshot.docs.isNotEmpty
            ? snapshot.docs.last
            : null; // Son yüklenen dokümanı güncelleme
      });
    } catch (e) {
      print('Error loading posts: $e'); // Hata durumunda konsola hata yazdırma
    } finally {
      setState(() {
        _isLoading = false; // Yükleme işlemi tamamlandı
      });
    }
  }

  // Daha fazla gönderi yükleme işlemi
  Future<void> _loadMorePosts() async {
    if (_isLoadingMore || _lastDocument == null)
      return; // Şu anda başka bir yükleme işlemi varsa veya son doküman boşsa işlemi durdur

    setState(() {
      _isLoadingMore = true; // Daha fazla yükleme işlemi başladı
    });

    try {
      QuerySnapshot snapshot = await _firebaseService.getPosts(
          lastDocument:
              _lastDocument); // Firestore'dan sonraki gönderileri getir
      List<Post> posts = snapshot.docs
          .map((doc) => Post.fromSnapshot(doc))
          .toList(); // Gönderileri Post nesnesine dönüştürme
      setState(() {
        _posts.addAll(posts); // Varolan gönderilere yeni gönderileri ekleme
        _lastDocument = snapshot.docs.isNotEmpty
            ? snapshot.docs.last
            : null; // Son yüklenen dokümanı güncelleme
      });
    } catch (e) {
      print(
          'Error loading more posts: $e'); // Hata durumunda konsola hata yazdırma
    } finally {
      setState(() {
        _isLoadingMore =
            false; // Daha fazla yükleme işlemi tamamlandı, gösterici gizleniyor
      });
    }
  }

  // Liste scroll dinleyicisi
  void _scrollListener() {
    // Liste sonuna yaklaşıldığında ve daha fazla yükleme işlemi yoksa daha fazla gönderi yükle
    //Mesafe 500 pikselden daha az  ve _isLoadingMore değeri false ise
    if (_scrollController.position.extentAfter < 500 && !_isLoadingMore) {
      _loadMorePosts();
    }
  }

  // Yeni gönderi oluşturulduğunda gönderileri yeniden yükle
  void handleNewPostCreated() {
    _loadPosts();
  }

  // Tarih formatlama işlemi
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  // Gönderi detay sayfasına git
  void _navigateToPostDetail(Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostDetailScreen(post: post)),
    );
  }

  Widget _buildPostBody(Post post) {
    const int maxLines = 6; // Gösterilecek maksimum satır sayısı
    // Metin stilini ve rengini belirle
    final TextSpan postText = TextSpan(
      text: post.body,
      style: const TextStyle(color: Colors.black),
    );

    // Metnin boyutlandırılması ve yerleştirilmesi için TextPainter oluştur
    final TextPainter textPainter = TextPainter(
      text: postText,
      maxLines: maxLines,
      textDirection:
          TextDirection.ltr, //(left-to-right), metin soldan sağa doğru akacak
    )..layout(
        minWidth: 0,
        maxWidth: double
            .infinity); //Belirli bir genişlik ve yükseklik içine yerleştir

    // Eğer metin belirtilen satır sayısından fazla ise kesme işlemi yap
    if (textPainter.didExceedMaxLines) {
      final TextSpan cutText = TextSpan(
        text:
            '${post.body.substring(0, textPainter.getPositionForOffset(Offset.zero).offset)}...',
        style: const TextStyle(color: Colors.black),
      );
      return RichText(
          text: cutText,
          textAlign: TextAlign.justify // Metni her iki kenara yasla
          );
    }
    // Eğer metin belirtilen satır sayısına sığdıysa tam metni göster
    else {
      return Text(
        post.body,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis, // Fazla metni kes ve '...' ile göster
        textAlign: TextAlign.justify, // Metni her iki kenara yasla
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akış'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _loadPosts,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _posts.length + 1,
                itemBuilder: (context, index) {
                  if (index == _posts.length) {
                    return _isLoadingMore
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : Container();
                  }
                  Post post = _posts[index];

                  return GestureDetector(
                    //kullanıcı etkileşimi algılama
                    //tıklandığında ilgili post un detay sayfasına git
                    onTap: () => _navigateToPostDetail(post),
                    child: Card(
                      //dış kenar boşlıkları
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Text(
                              post.header,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //Image
                            if (post.imageUrl != null) // Resim varsa göster
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    post.imageUrl!,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            // Body
                            _buildPostBody(post), // Metin gösterimi
                            const SizedBox(height: 8),
                            //Date
                            Text(
                              _formatDate(post.date),
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewPostScreen()),
          ).then((value) {
            _loadPosts();
          });
        },
        child: const Icon(
          Icons.add,
          size: 44,
          color: Colors.white,
        ),
      ),
    );
  }
}
