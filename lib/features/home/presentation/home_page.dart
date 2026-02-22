import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import 'pages/story_detail_page.dart';

// Garanti Import Yolları (Kırmızı yanmaları önler)
import 'package:dream_tales/features/story_creator/presentation/pages/story_creator_page.dart';
import 'package:dream_tales/features/story_creator/presentation/providers/story_provider.dart';
import 'package:dream_tales/features/profile/presentation/pages/profile_page.dart';

// Premium State Provider'ımız
import 'package:dream_tales/core/providers/premium_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(storyNotifierProvider.notifier).loadStories();
    });
  }

  // --- MASAL VERİLERİ ---
  static const List<Map<String, String>> _readyTales = [
    {
      'title': 'Kırmızı Başlıklı Kız',
      'imageUrl': 'https://picsum.photos/seed/1/400/500', 
      'content': _kirmiziBaslikliKizContent,
    },
    {
      'title': 'Pamuk Prenses',
      'imageUrl': 'https://picsum.photos/seed/2/400/500',
      'content': _pamukPrensesContent,
    },
    {
      'title': 'Üç Küçük Domuz',
      'imageUrl': 'https://picsum.photos/seed/3/400/500',
      'content': _ucKucukDomuzContent,
    },
    {
      'title': 'Altın Saçlı Kız',
      'imageUrl': 'https://picsum.photos/seed/4/400/500',
      'content': _altinSacliKizContent,
    },
    {
      'title': 'Uyuyan Güzel',
      'imageUrl': 'https://picsum.photos/seed/5/400/500',
      'content': _uyuyanGuzelContent,
    },
    {
      'title': 'Kurbağa Prens',
      'imageUrl': 'https://picsum.photos/seed/6/400/500',
      'content': _kurbagaPrensContent,
    },
    {
      'title': 'Hansel ve Gretel',
      'imageUrl': 'https://picsum.photos/seed/7/400/500',
      'content': _hanselVeGretelContent,
    },
    {
      'title': 'Çirkin Ördek Yavrusu',
      'imageUrl': 'https://picsum.photos/seed/8/400/500',
      'content': _cirkinOrdekYavrusuContent,
    },
  ];

  static const String _kirmiziBaslikliKizContent = '''
Bir zamanlar, ormanın kenarında küçük bir kulübede yaşayan bir kız vardı. Herkes ona "Kırmızı Başlıklı Kız" derdi çünkü büyükannesi ona kırmızı bir başlık hediye etmişti ve o başlığı hiç çıkarmazdı.

Bir gün annesi ona bir sepet hazırladı ve "Büyükannen hasta, ona bu sepeti götür. Yolda kimseyle konuşma ve doğrudan büyükannenin evine git" dedi.

Kırmızı Başlıklı Kız yola çıktı. Ormanda yürürken bir kurtla karşılaştı. Kurt ona nereye gittiğini sordu ve kız büyükannesinin evine gittiğini söyledi. Kurt hemen büyükannenin evine gitti, onu yuttu ve büyükannenin kıyafetlerini giydi.

Kız geldiğinde kurdun büyükannesi olmadığını fark etti ama çok geç kalmıştı. Kurt onu da yuttu. Neyse ki bir avcı geçiyordu ve kurdun karnını açarak hem büyükannesi hem de Kırmızı Başlıklı Kız'ı kurtardı. O günden sonra Kırmızı Başlıklı Kız annesinin sözünü hiç unutmadı.
''';

  static const String _pamukPrensesContent = '''
Bir zamanlar, güzel ve iyi kalpli bir prenses vardı. Annesi öldükten sonra babası yeni bir kraliçe ile evlendi. Yeni kraliçe çok güzeldi ama kalbi kötüydü. Her gün aynaya sorardı: "Ayna ayna, söyle bana, bu ülkede en güzel kim?"

Ayna hep onun en güzel olduğunu söylerdi. Ama bir gün Pamuk Prenses büyüdü ve ayna artık onun en güzel olduğunu söyledi. Kraliçe çok kızdı ve bir avcıya prensesi öldürmesini emretti.

Avcı prensese acıdı ve onu ormanda bıraktı. Prenses yedi cüce ile tanıştı ve onların evinde kalmaya başladı. Kraliçe bunu öğrenince zehirli bir elma hazırladı ve prensesi zehirledi.

Prenses derin bir uykuya daldı. Bir prens onu görünce aşık oldu ve öpücüğü ile prensesi uyandırdı. Kraliçe cezasını buldu ve prenses ile prens mutlu bir şekilde yaşadılar.
''';

  static const String _ucKucukDomuzContent = '''
Bir zamanlar üç küçük domuz vardı. Anneleri onlara "Artık büyüdünüz, kendi evlerinizi yapmalısınız" dedi.

İlk domuz samandan bir ev yaptı. İkinci domuz çubuklardan bir ev yaptı. Üçüncü domuz ise tuğladan sağlam bir ev yaptı.

Bir gün aç bir kurt geldi. İlk domuzun saman evini üfleyerek yıktı. Domuz kaçtı ve ikinci domuzun evine sığındı. Kurt çubuk evini de üfleyerek yıktı. İki domuz üçüncü domuzun tuğla evine kaçtı.

Kurt tuğla evi yıkamadı. Kızgınlıkla bacadan girmeye çalıştı ama üç domuz kazanı kaynattı ve kurt kaynar suya düştü. O günden sonra üç domuz güvenle yaşadılar ve her zaman çalışmanın önemini hatırladılar.
''';

  static const String _altinSacliKizContent = '''
Bir zamanlar altın saçlı güzel bir kız vardı. Saçları o kadar güzeldi ki herkes ona hayran kalırdı. Bir gün bir cadı onu kulesine hapsetti ve saçlarını merdiven olarak kullanıyordu.

Kızın saçları çok uzundu ve cadı her gün "Altın saçlı kız, saçlarını aşağı sarkıt" diye bağırırdı. Kız saçlarını pencereden sarkıtır, cadı saçlarına tutunarak yukarı çıkardı.

Bir gün bir prens kızın şarkısını duydu ve onu görmek istedi. Cadı yokken kuleye tırmandı ve kızla tanıştı. İkisi de birbirine aşık oldu.

Cadı bunu öğrenince çok kızdı ve kızın saçlarını kesti. Prens geldiğinde saçları bulamadı ama cadıyı yendi ve kızı kurtardı. İkisi de mutlu bir şekilde yaşadılar.
''';

  static const String _uyuyanGuzelContent = '''
Bir zamanlar bir kral ve kraliçe vardı. Uzun süre çocukları olmadı ama sonunda güzel bir kızları oldu. Doğum gününde tüm periler davet edildi ama bir peri unutuldu.

Unutulan peri çok kızdı ve prensesin on altıncı yaş gününde bir iğneye dokunarak öleceğini lanetledi. Diğer periler laneti yumuşattı ve prenses ölmek yerine yüz yıl uyuyacaktı.

Prenses on altıncı yaş gününde bir iğneye dokundu ve derin bir uykuya daldı. Tüm saray da onunla birlikte uyudu. Yüz yıl sonra bir prens geldi, prensesi öptü ve onu uyandırdı.

Tüm saray uyanıştı ve prenses ile prens evlendi. Mutlu bir şekilde yaşadılar ve lanet bir daha asla geri dönmedi.
''';

  static const String _kurbagaPrensContent = '''
Bir zamanlar güzel bir prenses vardı. Altın topunu kaybetti ve bir kurbağa ona yardım etti. Prenses kurbağaya "Eğer topumu bulursan seninle arkadaş olurum" dedi.

Kurbağa topu buldu ama prenses sözünü tutmadı. Kurbağa prensesin babasına şikayet etti ve kral kızına sözünü tutmasını söyledi.

Prenses kurbağayı saraya getirdi ama ondan nefret ediyordu. Bir gün kurbağayı duvara fırlattı ve kurbağa güzel bir prense dönüştü. Bir cadı onu lanetlemişti ve sadece bir prensesin sevgisi laneti kırabilirdi.

Prenses ve prens evlendi ve mutlu bir şekilde yaşadılar. Prenses sözünü tutmanın ve herkese nazik davranmanın önemini öğrendi.
''';

  static const String _hanselVeGretelContent = '''
Bir zamanlar fakir bir oduncu ve karısı vardı. İki çocukları vardı: Hansel ve Gretel. Aile çok fakirdi ve aç kalmışlardı. Üvey anne çocukları ormana bırakmaya karar verdi.

Hansel akıllıydı ve yolda beyaz taşlar bıraktı. Ay ışığında taşlar parladı ve çocuklar eve döndü. İkinci kez üvey anne onları ormana götürdüğünde Hansel ekmek kırıntıları bıraktı ama kuşlar onları yedi.

Çocuklar kayboldu ve şekerden yapılmış bir ev buldular. Evde yaşlı bir kadın vardı ama o aslında bir cadıydı. Cadı Hansel'i kafese koydu ve Gretel'i çalıştırmaya başladı.

Gretel akıllıydı ve cadıyı fırına itti. Cadı yandı ve çocuklar cadının hazinesini alarak eve döndüler. Artık hiç aç kalmayacaklardı ve mutlu bir şekilde yaşadılar.
''';

  static const String _cirkinOrdekYavrusuContent = '''
Bir zamanlar bir ördek yumurtalarını kuluçkaya yatırmıştı. Yumurtalardan güzel ördek yavruları çıktı ama bir tanesi diğerlerinden farklıydı. Diğerleri ona "çirkin" diyordu.

Çirkin ördek yavrusu çok üzgündü ve herkes ondan kaçıyordu. Kış geldi ve o çok zor zamanlar geçirdi. Ama bahar geldiğinde bir göl kenarında kendi yansımasını gördü.

Artık çirkin bir ördek yavrusu değil, güzel bir kuğuydu! Diğer kuğular onu aralarına aldılar ve o mutlu bir şekilde yaşadı. O gün öğrendi ki, farklı olmak kötü bir şey değildi ve gerçek güzellik içeriden geliyordu.
''';

  @override
  Widget build(BuildContext context) {
    final storyState = ref.watch(storyNotifierProvider);
    final aiStories = storyState.stories; 
    final totalItemCount = aiStories.length + _readyTales.length;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
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

          SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hoş Geldin,', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w500)),
                        Text('Masal Dünyası ✨', style: GoogleFonts.poppins(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black.withOpacity(0.1), offset: const Offset(0, 2), blurRadius: 4)])),
                      ],
                    ),
                  ),
                ),

                if (storyState.isLoading && aiStories.isEmpty)
                   const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(color: Colors.white)))
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20, childAspectRatio: 0.7,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          String title;
                          String imageUrl;
                          String content;

                          if (index < aiStories.length) {
                            final story = aiStories[index];
                            title = story.title;
                            content = story.content;
                            imageUrl = 'https://picsum.photos/seed/${story.title.hashCode}/400/500'; 
                          } else {
                            final int taleIndex = (index - aiStories.length).toInt(); 
                            final tale = _readyTales[taleIndex];
                            title = tale['title']!;
                            imageUrl = tale['imageUrl']!;
                            content = tale['content']!;
                          }

                          return _ModernGlassCard(
                            title: title,
                            imageUrl: imageUrl,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => StoryDetailPage(title: title, imageUrl: imageUrl, content: content),
                              ));
                            },
                          );
                        },
                        childCount: totalItemCount,
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)), 
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildModernBottomNav(context),
    );
  }

  Widget _buildBlurShape(Color color) {
    return Container(
      width: 300, height: 300,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100), child: Container(color: Colors.transparent)),
    );
  }

  // --- İŞTE DÜZELTİLEN ALT MENÜ KISMI ---
  Widget _buildModernBottomNav(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(0, Icons.home_rounded, 'Anasayfa'),
                
                // ORTADAKİ SİHİRLİ BUTON (Paywall kontrollü)
                GestureDetector(
                  onTap: () {
                    final isPro = ref.read(premiumProvider); 
                    if (isPro) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const StoryCreatorPage()));
                    } else {
                      _showPaywall(context, ref); 
                    }
                  },
                  child: Container(
                    height: 54, width: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(colors: [Color(0xFF9A67EA), Color(0xFF65C7F7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      boxShadow: [BoxShadow(color: const Color(0xFF9A67EA).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8))],
                    ),
                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
                  ),
                ),
                
                // PROFİL BUTONU (Çakışma çözüldü, direkt yönlendirme eklendi!)
                _buildNavItem(
                  1, 
                  Icons.person_rounded, 
                  'Profil',
                  onTapOverride: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // YENİ: İçeriye 'onTapOverride' adında özel bir emir komutu ekledik
  Widget _buildNavItem(int index, IconData icon, String label, {VoidCallback? onTapOverride}) {
    final isSelected = _navIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _navIndex = index);
        // Eğer dışarıdan "Şu sayfaya git" emri (onTapOverride) gelmişse onu çalıştır!
        if (onTapOverride != null) {
          onTapOverride();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected ? BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)) : null,
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.white.withOpacity(0.6), size: 26),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(label, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
            ],
          ],
        ),
      ),
    );
  }

  // --- ÖDEME DUVARI (PAYWALL) TASARIMI ---
  void _showPaywall(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 30),
                const Icon(Icons.auto_awesome, color: Color(0xFFFEE140), size: 60),
                const SizedBox(height: 16),
                Text('Sınırları Kaldırın', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 10),
                Text(
                  'Gemini Yapay Zeka ile çocuklarınız için her gün yepyeni, sınırsız ve özelleştirilmiş masallar üretmek için PRO sürümüne geçin.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white.withOpacity(0.7)),
                ),
                const SizedBox(height: 30),
                _buildPaywallFeature(Icons.check_circle, 'Sınırsız Masal Üretimi'),
                _buildPaywallFeature(Icons.check_circle, 'Kendi Karakterlerinizi Yaratın'),
                _buildPaywallFeature(Icons.check_circle, 'Reklamsız Deneyim'),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(premiumProvider.notifier).setPremium(true);
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const StoryCreatorPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9A67EA),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text('PRO\'ya Geç - ₺49,99/Ay', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Belki Daha Sonra', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white.withOpacity(0.5))),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaywallFeature(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF65C7F7), size: 20),
          const SizedBox(width: 12),
          Text(text, style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
        ],
      ),
    );
  }
}

class _ModernGlassCard extends StatelessWidget {
  const _ModernGlassCard({required this.title, required this.imageUrl, required this.onTap});
  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white.withOpacity(0.1),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 10))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                imageUrl, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.white.withOpacity(0.2),
                  child: const Icon(Icons.image_not_supported, color: Colors.white54, size: 40),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.5)],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),
              Positioned(
                left: 0, right: 0, bottom: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.3), width: 1)),
                      ),
                      child: Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white, height: 1.2,
                          shadows: [Shadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))],
                        ),
                        maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}