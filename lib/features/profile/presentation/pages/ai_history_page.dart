import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Yollar (Kendi projenin yapısına tam uygundur)
import 'package:dream_tales/features/story_creator/presentation/providers/story_provider.dart';
import 'package:dream_tales/features/home/presentation/pages/story_detail_page.dart';

class AiHistoryPage extends ConsumerWidget {
  const AiHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Riverpod'dan yapay zeka masallarımızı çekiyoruz
    final aiStories = ref.watch(storyNotifierProvider).stories;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Yapay Zeka Geçmişi', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // 1. Ferah Arka Plan
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC), Color(0xFFC2E9FB), Color(0xFFFEE140)],
                stops: [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
          Positioned(top: -100, right: -100, child: _buildBlurShape(const Color(0xFF9A67EA).withOpacity(0.4))),
          Positioned(bottom: -150, left: -150, child: _buildBlurShape(const Color(0xFF65C7F7).withOpacity(0.4))),

          // 2. Liste İçeriği
          SafeArea(
            child: aiStories.isEmpty 
              ? Center(
                  child: Text(
                    'Henüz masal üretmedin.\nHadi anasayfadaki sihirli butona dokun!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: aiStories.length,
                  itemBuilder: (context, index) {
                    final story = aiStories[index];
                    final imageUrl = 'https://picsum.photos/seed/${story.title.hashCode}/400/500'; // Rastgele kapak resmi
                    
                    return Card(
                      color: Colors.white.withOpacity(0.15),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                        ),
                        title: Text(story.title, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Text(
                          story.content,
                          maxLines: 2, // Sadece ilk 2 satırı gösterir
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8), fontSize: 12),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 18),
                        onTap: () {
                          // Tıklayınca okuma sayfasına (StoryDetailPage) yönlendirir
                          Navigator.push(context, MaterialPageRoute(
                            builder: (_) => StoryDetailPage(title: story.title, imageUrl: imageUrl, content: story.content)
                          ));
                        },
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurShape(Color color) {
    return Container(
      width: 300, height: 300,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100), child: Container(color: Colors.transparent)),
    );
  }
}