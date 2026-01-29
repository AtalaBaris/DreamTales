import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/main_bottom_nav_bar.dart';
import 'pages/story_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// 0: Profil, 1: Ayarlar, 2: Anasayfa
  int _navIndex = 2;

  static const List<Map<String, String>> _readyTales = [
    {
      'title': 'Kırmızı Başlıklı Kız',
      'imageUrl': 'https://picsum.photos/seed/1/400/300',
      'content': _kirmiziBaslikliKizContent,
    },
    {
      'title': 'Pamuk Prenses',
      'imageUrl': 'https://picsum.photos/seed/2/400/300',
      'content': _pamukPrensesContent,
    },
    {
      'title': 'Üç Küçük Domuz',
      'imageUrl': 'https://picsum.photos/seed/3/400/300',
      'content': _ucKucukDomuzContent,
    },
    {
      'title': 'Altın Saçlı Kız',
      'imageUrl': 'https://picsum.photos/seed/4/400/300',
      'content': _altinSacliKizContent,
    },
    {
      'title': 'Uyuyan Güzel',
      'imageUrl': 'https://picsum.photos/seed/5/400/300',
      'content': _uyuyanGuzelContent,
    },
    {
      'title': 'Kurbağa Prens',
      'imageUrl': 'https://picsum.photos/seed/6/400/300',
      'content': _kurbagaPrensContent,
    },
    {
      'title': 'Hansel ve Gretel',
      'imageUrl': 'https://picsum.photos/seed/7/400/300',
      'content': _hanselVeGretelContent,
    },
    {
      'title': 'Çirkin Ördek Yavrusu',
      'imageUrl': 'https://picsum.photos/seed/8/400/300',
      'content': _cirkinOrdekYavrusuContent,
    },
  ];

  // Masal içerikleri
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Başlık
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Text(
                'Hazır masallar',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            // Grid kartlar
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: _readyTales.length,
                  itemBuilder: (context, index) {
                    final tale = _readyTales[index];
                    return _TaleCard(
                      title: tale['title']!,
                      imageUrl: tale['imageUrl']!,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => StoryDetailPage(
                              title: tale['title']!,
                              imageUrl: tale['imageUrl']!,
                              content: tale['content']!,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: _navIndex,
        onTap: (index) {
          setState(() => _navIndex = index);
          if (index == 0) {
            // TODO: Profil sayfasına yönlendir
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profil yakında')),
            );
          } else if (index == 1) {
            // TODO: Ayarlar sayfasına yönlendir
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ayarlar yakında')),
            );
          }
          // index == 2: Anasayfa, zaten buradayız
        },
      ),
      floatingActionButton: MainMagicFab(
        onPressed: () {
          // TODO: Masal oluşturma ekranına yönlendir
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Masal oluştur yakında')),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _TaleCard extends StatelessWidget {
  const _TaleCard({
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });

  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Arka plan görseli - kartın tamamını kaplar
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.surface,
                child: Icon(
                  Icons.image_not_supported_rounded,
                  size: 48,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
            // Alt gradient - başlığın okunabilir olması için
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.85),
                    ],
                  ),
                ),
              ),
            ),
            // Başlık
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
