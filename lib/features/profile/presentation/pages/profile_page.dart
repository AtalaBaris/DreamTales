import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// PRO state'imizi dinlemek için import ediyoruz
import 'package:dream_tales/core/providers/premium_provider.dart';
// Paywall'dan sonra masal sayfasına geçmek istersek diye
import 'package:dream_tales/features/story_creator/presentation/pages/story_creator_page.dart';
import 'package:dream_tales/features/profile/presentation/pages/ai_history_page.dart';

// StatelessWidget yerine ConsumerWidget yaptık ki Riverpod'u dinleyebilelim
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Kullanıcı PRO mu değil mi anında öğreniyoruz!
    final isPro = ref.watch(premiumProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // 1. ANA SAYFA İLE UYUMLU FERAH ARKA PLAN
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE0C3FC),
                  Color(0xFF8EC5FC),
                  Color(0xFFC2E9FB),
                  Color(0xFFFEE140),
                ],
                stops: [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
          Positioned(
            top: -100, right: -100,
            child: _buildBlurShape(const Color(0xFF9A67EA).withOpacity(0.4)),
          ),
          Positioned(
            bottom: -150, left: -150,
            child: _buildBlurShape(const Color(0xFF65C7F7).withOpacity(0.4)),
          ),

          // 2. PROFİL İÇERİĞİ
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profilim',
                      style: GoogleFonts.poppins(
                        fontSize: 32, 
                        color: Colors.white, 
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black.withOpacity(0.1), offset: const Offset(0, 2), blurRadius: 4)],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Profil Bilgileri (Avatar & İsim)
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                // Eğer PRO ise altın sarısı parlasın!
                                colors: isPro 
                                    ? [const Color(0xFFFFD700), const Color(0xFFFFA500)] 
                                    : [const Color(0xFF9A67EA), const Color(0xFF65C7F7)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: (isPro ? const Color(0xFFFFD700) : const Color(0xFF9A67EA)).withOpacity(0.4), 
                                  blurRadius: 15, offset: const Offset(0, 8)
                                )
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage('https://picsum.photos/seed/avatar/200/200'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Masal Sever', 
                            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          
                          // İŞTE BURASI: PRO mu değil mi etiketini değiştiriyoruz
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: isPro ? const Color(0xFFFFD700).withOpacity(0.2) : Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isPro ? const Color(0xFFFFD700) : Colors.white.withOpacity(0.3)),
                            ),
                            child: Text(
                              isPro ? '✨ PRO Üye' : 'Kayıtlı Kullanıcı', 
                              style: GoogleFonts.poppins(
                                fontSize: 12, 
                                fontWeight: FontWeight.w600,
                                color: isPro ? const Color(0xFFFFD700) : Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // 3. ✨ AKILLI PRO VİTRİNİ ✨
                    // Eğer kullanıcı PRO değilse satın alma kartını, PRO ise teşekkür kartını göster
                    isPro ? _buildProActiveBanner() : _buildProUpsellBanner(context, ref),
                    const SizedBox(height: 30),

                    // 4. LİSTE ELEMANLARI
                    _buildMenuTitle('Hesap Ayarları'),
                    _buildMenuItem(Icons.person_outline, 'Kişisel Bilgiler'),
                    _buildMenuItem(Icons.notifications_none, 'Bildirimler'),
                    _buildMenuItem(
                    Icons.history, 
                    'Yapay Zeka Geçmişi', 
                    onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AiHistoryPage()));
                    },
                    ),
                    
                    const SizedBox(height: 20),
                    _buildMenuTitle('Diğer'),
                    _buildMenuItem(Icons.help_outline, 'Sıkça Sorulan Sorular'),
                    _buildMenuItem(Icons.privacy_tip_outlined, 'Gizlilik Politikası'),
                    
                    // TEST İÇİN: PRO üyeliği sıfırlama butonu (Gerçekte çıkış yap butonu olacak)
                    _buildMenuItem(
                      isPro ? Icons.refresh : Icons.logout, 
                      isPro ? 'PRO Üyeliği Sıfırla (Test)' : 'Çıkış Yap', 
                      isDestructive: true,
                      onTap: () {
                        if (isPro) {
                          ref.read(premiumProvider.notifier).setPremium(false);
                        } else {
                          // İleride Firebase çıkış kodu buraya gelecek
                        }
                      }
                    ),
                    
                    const SizedBox(height: 40), 
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- YARDIMCI WİDGET'LAR ---

  Widget _buildBlurShape(Color color) {
    return Container(
      width: 300, height: 300,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100), child: Container(color: Colors.transparent)),
    );
  }

  // KULLANICI ÜCRETSİZ İSE GÖRÜNEN SATIN ALMA KARTI
  Widget _buildProUpsellBanner(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        // Tıklayınca anasayfadaki gibi Paywall'u açabiliriz ama şimdilik direkt PRO yapalım test için
        ref.read(premiumProvider.notifier).setPremium(true);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF9A9E), Color(0xFFFECFEF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: const Color(0xFFFF9A9E).withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10))
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star_rounded, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dream Tales PRO',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    'Sınırsız masal üretmek için tıkla ve PRO\'ya geç!',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withOpacity(0.9)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  // KULLANICI PRO İSE GÖRÜNEN TEŞEKKÜR KARTI
  Widget _buildProActiveBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFEE140), Color(0xFFFA709A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: const Color(0xFFFA709A).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Premium Aktif',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  'Sınırlar kaldırıldı. Çocuğunuz için dilediğiniz kadar masal üretebilirsiniz.',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withOpacity(0.9)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.7)),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {bool isDestructive = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: ListTile(
          leading: Icon(icon, color: isDestructive ? Colors.redAccent : Colors.white),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16, 
              fontWeight: FontWeight.w500, 
              color: isDestructive ? Colors.redAccent : Colors.white,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
        ),
      ),
    );
  }
}