# Dream Tales

**Masalları dinleyin, okuyun ve oluşturun.** Çocuklar ve aileler için hazır masallar, metin okuma (TTS) ve masal oluşturma özellikleriyle Flutter ile geliştirilmiş mobil uygulama.

---

## Özellikler

- **Kimlik doğrulama** — Supabase Auth ile giriş ve kayıt
- **Hazır masallar** — Grid yapısında 8 hazır masal kartı
- **Masal detay** — Tam sayfa masal görüntüleme, üstte görsel, altında metin
- **Seslendirme (TTS)** — Metin okuma, cümle cümle senkron vurgulama
- **Ses ayarları** — Hız (0.5x–2.0x), ses tonu (Kadın / Erkek)
- **Alt navigasyon** — Profil, Ayarlar, Anasayfa, ortada sihirli değnek FAB
- **Masal oluşturma** — Yeni masal ekleme (Story Creator)
- **Clean Architecture** — Feature-first, domain / data / presentation katmanları

---

## Teknoloji Stack

| Kategori | Teknoloji |
|----------|-----------|
| **Framework** | Flutter (Dart 3.10+) |
| **Auth & Backend** | Supabase |
| **State Management** | Riverpod |
| **Dependency Injection** | Get It |
| **HTTP** | Dio |
| **Text-to-Speech** | flutter_tts |
| **Local Storage** | shared_preferences |
| **Error Handling** | dartz (Either) |
| **Immutability** | freezed, equatable |

---

## Proje Yapısı

```
lib/
├── core/                      # Paylaşılan yapılar
│   ├── config/               # App config, .env
│   ├── error/                # Failure sınıfları
│   ├── injection/            # Get It DI
│   ├── network/              # NetworkInfo
│   ├── theme/                # AppColors, AppTheme
│   ├── usecases/             # Base use case
│   ├── utils/                # Input validator vb.
│   └── widgets/              # Custom button, text field, bottom nav
│
├── features/
│   ├── auth/                 # Giriş, kayıt
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── home/                 # Anasayfa, masal kartları, detay
│   │   └── presentation/
│   │       ├── home_page.dart
│   │       └── pages/
│   │           └── story_detail_page.dart
│   │
│   ├── audio_player/         # TTS servisi
│   │   ├── domain/services/  # TextToSpeechService
│   │   └── data/services/    # FlutterTtsServiceImpl
│   │
│   └── story_creator/        # Masal oluşturma
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── main.dart
```

Mimari detayı için [CLEAN_ARCHITECTURE.md](CLEAN_ARCHITECTURE.md) dosyasına bakın.

---

## Gereksinimler

- **Flutter** 3.10+ ([kurulum](https://docs.flutter.dev/get-started/install))
- **Dart** 3.10+
- **Supabase** hesabı (Auth için)
- **Android:** Android Studio / VS Code  
- **iOS:** Xcode (Mac), Apple ID (cihaza yükleme için)

---

## Kurulum

### 1. Repoyu klonlayın

```bash
git clone https://github.com/KULLANICI_ADINIZ/dream_tales.git
cd dream_tales
```

### 2. Bağımlılıkları yükleyin

```bash
flutter pub get
```

### 3. Ortam değişkenlerini ayarlayın

Supabase Auth kullanmak için proje kökünde `.env` dosyası oluşturun:

```bash
cp .env.example .env
```

`.env` içeriği:

```env
SUPABASE_URL=https://YOUR_PROJECT_ID.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
```

Supabase Dashboard → Project Settings → API bölümünden URL ve `anon` key’i alabilirsiniz.  
Daha fazla seçenek için [CONFIG_SETUP.md](CONFIG_SETUP.md) dosyasına bakın.

### 4. (İsteğe bağlı) Code generation

Freezed / JSON / Riverpod code generation kullanıyorsanız:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Çalıştırma

### Android

```bash
flutter run
```

veya cihaz/emülatör seçerek:

```bash
flutter devices
flutter run -d <device_id>
```

### iOS (Mac + Xcode)

```bash
cd ios
pod install
cd ..
flutter run
```

Xcode’da **Signing & Capabilities** altında bir **Team** (Apple ID) seçmeniz gerekebilir.  
Detay için: [Flutter iOS kurulumu](https://docs.flutter.dev/deployment/ios).

### Web

```bash
flutter run -d chrome
```

---

## Ortam Değişkenleri Olmadan Çalıştırma

`.env` yoksa uygulama varsayılan (boş) config ile açılır; Auth çalışmaz. Geliştirme için:

- `.env` kullanın veya  
- `--dart-define` ile Supabase değerlerini verin:

```bash
flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```

---

## Öne Çıkan Özellikler (Kısa)

- **Cümle cümle TTS:** Masal metni cümlelere bölünür, okunan cümle turuncu ve kalın, diğerleri beyaz; geçiş animasyonlu.
- **Hız / ses tonu:** Slider ile hız, dropdown ile Kadın/Erkek sesi; değişiklik anında uygulanır.
- **Hazır masallar:** Şu an 8 masal sabit içerikle; ileride DB/API’den çekilebilir.

---

## Katkıda Bulunma

1. Repoyu fork edin.
2. Feature branch oluşturun: `git checkout -b feature/yeni-ozellik`
3. Değişikliklerinizi commit edin: `git commit -m 'Yeni özellik eklendi'`
4. Branch’i push edin: `git push origin feature/yeni-ozellik`
5. Pull Request açın.

---

## Lisans

Bu proje şu an **publish_to: 'none'** ile yayımlanmıyor. Lisans eklemek isterseniz proje köküne `LICENSE` dosyası ekleyebilirsiniz.

---

## İletişim

Sorular veya öneriler için GitHub Issues kullanabilirsiniz.
