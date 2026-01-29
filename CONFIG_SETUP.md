# Supabase Config Kurulumu

Bu proje güvenli config yönetimi için üç farklı yöntem destekler:

## 🔒 Güvenlik Öncelik Sırası

1. **.env dosyası** (Development için önerilen)
2. **--dart-define** (CI/CD için önerilen)
3. **Default değerler** (Sadece development için)

## 📝 Yöntem 1: .env Dosyası (Development)

### Adımlar:

1. Proje root dizininde `.env.example` dosyasını `.env` olarak kopyalayın:
   ```bash
   cp .env.example .env
   ```

2. `.env` dosyasını açın ve Supabase değerlerinizi girin:
   ```env
   SUPABASE_URL=https://YOUR_PROJECT_ID.supabase.co
   SUPABASE_ANON_KEY=your_anon_key_here
   ```

3. `.env` dosyası otomatik olarak `.gitignore`'a eklenmiştir, bu sayede git'e commit edilmez.

### ✅ Avantajlar:
- Kolay kullanım
- Git'e commit edilmez (güvenli)
- Her geliştirici kendi değerlerini kullanabilir

## 🚀 Yöntem 2: --dart-define (CI/CD)

### Development:
```bash
flutter run --dart-define=SUPABASE_URL=https://YOUR_PROJECT_ID.supabase.co --dart-define=SUPABASE_ANON_KEY=your_anon_key
```

### Build:
```bash
flutter build apk --dart-define=SUPABASE_URL=https://YOUR_PROJECT_ID.supabase.co --dart-define=SUPABASE_ANON_KEY=your_anon_key
```

### ✅ Avantajlar:
- CI/CD pipeline'larında kolay kullanım
- Environment variables ile entegre
- Production build'lerde güvenli

## ⚙️ Yöntem 3: Default Değerler (Sadece Development)

⚠️ **UYARI**: Bu yöntem sadece development için kullanılmalıdır!

`lib/core/config/app_config.dart` dosyasındaki default değerleri değiştirebilirsiniz, ancak:
- ❌ Production'da kullanmayın
- ❌ Git'e commit etmeyin
- ✅ Sadece lokal development için

## 🔍 Config Validation

Uygulama başlangıcında config değerleri otomatik olarak validate edilir:

- ✅ URL format kontrolü
- ✅ Key uzunluk kontrolü
- ✅ Değerlerin ayarlanıp ayarlanmadığı kontrolü

## 📋 Supabase Değerlerini Bulma

1. [Supabase Dashboard](https://app.supabase.com/)'a giriş yapın
2. Projenizi seçin
3. **Settings** > **API** bölümüne gidin
4. **Project URL** ve **anon/public key** değerlerini kopyalayın

## 🛠️ Troubleshooting

### "Config değerleri ayarlanmamış" hatası:
- `.env` dosyasının proje root dizininde olduğundan emin olun
- `.env` dosyasında boşluk veya tırnak işareti olmadığından emin olun
- `pubspec.yaml`'da assets bölümünde `.env` dosyasının eklendiğinden emin olun

### "Geçersiz URL formatı" hatası:
- URL'in `https://` ile başladığından emin olun
- URL'in `.supabase.co` ile bittiğinden emin olun

### "Geçersiz Key formatı" hatası:
- Key'in tam olarak kopyalandığından emin olun
- Key'de boşluk veya yeni satır karakteri olmadığından emin olun

## 🔐 Güvenlik Best Practices

1. ✅ `.env` dosyasını `.gitignore`'a ekleyin (zaten ekli)
2. ✅ Production'da `--dart-define` kullanın
3. ✅ CI/CD pipeline'larında environment variables kullanın
4. ❌ Config değerlerini kod içine hardcode etmeyin
5. ❌ Config değerlerini git'e commit etmeyin
6. ❌ Public repository'lerde default değerlere gerçek key yazmayın
