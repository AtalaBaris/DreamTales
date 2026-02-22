import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart'; // YENİ: Hafıza kontrolü için eklendi

// Anasayfaya geçiş yapabilmek için import ediyoruz
import '../../../home/presentation/home_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Karşılama Ekranı İçerikleri
  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Sihirli Dünyaya\nAdım Atın",
      "description": "Çocuğunuz için her gece yepyeni, eğitici ve eğlenceli masallar keşfedin.",
      "icon": Icons.auto_awesome,
      "color": const Color(0xFF9A67EA),
    },
    {
      "title": "Kendi Kahramanını\nYarat",
      "description": "Gemini Yapay Zeka sayesinde çocuğunuz kendi masalının başrolünde yer alsın.",
      "icon": Icons.face_retouching_natural_rounded,
      "color": const Color(0xFF65C7F7),
    },
    {
      "title": "Dinlendirici\nSesli Okuma",
      "description": "Uyku öncesi göz yormayan karanlık tasarım ve rahatlatıcı sesli okuma özelliği.",
      "icon": Icons.headphones_rounded,
      "color": const Color(0xFFFEE140),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. CANLI & FERAH ARKA PLAN (Anasayfa ile uyumlu)
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
          Positioned(top: -100, right: -100, child: _buildBlurShape(const Color(0xFF9A67EA).withOpacity(0.5))),
          Positioned(bottom: -150, left: -150, child: _buildBlurShape(const Color(0xFF65C7F7).withOpacity(0.5))),

          // 2. KAYDIRILABİLİR İÇERİK (PageView)
          SafeArea(
            child: Column(
              children: [
                // Sağ üstte 'Geç' butonu
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () => _goToHome(),
                    child: Text(
                      'Geç',
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      return _buildPageContent(
                        _onboardingData[index]['title'],
                        _onboardingData[index]['description'],
                        _onboardingData[index]['icon'],
                        _onboardingData[index]['color'],
                      );
                    },
                  ),
                ),

                // 3. ALT KONTROLLER (Noktalar ve İleri/Başla Butonu)
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Sayfa Noktaları (Indicators)
                      Row(
                        children: List.generate(
                          _onboardingData.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 8),
                            height: 8,
                            width: _currentPage == index ? 24 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index ? Colors.white : Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),

                      // İleri veya Başla Butonu
                      GestureDetector(
                        onTap: () {
                          if (_currentPage == _onboardingData.length - 1) {
                            _goToHome(); // Son sayfadaysa anasayfaya git
                          } else {
                            _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 60,
                          width: _currentPage == _onboardingData.length - 1 ? 150 : 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
                          ),
                          child: Center(
                            child: _currentPage == _onboardingData.length - 1
                                ? Text('Hemen Başla', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))
                                : const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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

  Widget _buildPageContent(String title, String description, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Cam Efektli İkon Kartı
          Container(
            height: 200, width: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.15),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
              boxShadow: [BoxShadow(color: iconColor.withOpacity(0.3), blurRadius: 40, spreadRadius: 10)],
            ),
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Center(child: Icon(icon, size: 100, color: Colors.white)),
              ),
            ),
          ),
          const SizedBox(height: 60),
          
          // Başlık
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 32, 
              fontWeight: FontWeight.bold, 
              color: Colors.white,
              height: 1.2,
              shadows: [Shadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
            ),
          ),
          const SizedBox(height: 20),
          
          // Açıklama
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16, 
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // YENİ: Hafızaya Yazan ve Yönlendiren Fonksiyon
  void _goToHome() async {
    // 1. SharedPreferences'ı çağır ve 'hasSeenOnboarding' değerini true yap
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);

    // 2. Widget hala ekrandaysa yönlendirmeyi yap (Flutter kuralı)
    if (!mounted) return;
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }
}