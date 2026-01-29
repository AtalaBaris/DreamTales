# Clean Architecture - Dream Tales

Bu proje Clean Architecture + Feature-First mimarisi kullanılarak geliştirilmiştir.

## Mimari Yapı

```
lib/
├── core/                    # Shared, uygulama genelinde kullanılan yapılar
│   ├── error/              # Failure sınıfları (hata yönetimi)
│   ├── injection/          # Dependency Injection setup
│   ├── network/            # Network info, API client
│   ├── theme/              # Tema ve renkler
│   ├── usecases/           # Base use case sınıfları
│   ├── utils/              # Yardımcı fonksiyonlar
│   └── widgets/            # Reusable widget'lar
│
├── features/               # Feature-First yapı
│   └── story_creator/     # Her feature kendi klasöründe
│       ├── data/          # Data katmanı
│       │   ├── datasources/    # Remote ve Local data sources
│       │   ├── models/         # Data modelleri (JSON serialization)
│       │   └── repositories/   # Repository implementasyonları
│       │
│       ├── domain/        # Domain katmanı (business logic)
│       │   ├── entities/      # Domain entity'leri
│       │   ├── repositories/  # Repository interface'leri (abstract)
│       │   └── usecases/      # Use case'ler (business logic)
│       │
│       └── presentation/   # Presentation katmanı (UI)
│           ├── pages/         # Sayfa widget'ları
│           ├── providers/     # Riverpod state management
│           └── widgets/       # Feature-specific widget'lar
│
└── main.dart              # Uygulama giriş noktası
```

## Katmanlar

### 1. Domain Layer (Business Logic)
- **Entities**: Veri yapıları (API/Firebase'den bağımsız)
- **Repositories**: Abstract interface'ler
- **Use Cases**: Tek sorumluluklu business logic

### 2. Data Layer (Veri Erişimi)
- **Data Sources**: Remote (API) ve Local (Cache) veri kaynakları
- **Models**: JSON serialization için data modelleri
- **Repository Implementation**: Domain repository'lerinin implementasyonu

### 3. Presentation Layer (UI)
- **Pages**: Sayfa widget'ları
- **Providers**: Riverpod state management
- **Widgets**: Feature-specific UI component'leri

## Kullanılan Paketler

### State Management
- **flutter_riverpod**: State management

### Dependency Injection
- **get_it**: Service locator
- **injectable**: Code generation için (opsiyonel)

### Functional Programming
- **dartz**: Either<Failure, Success> için hata yönetimi
- **freezed**: Immutable classes ve union types

### Data
- **dio**: HTTP client
- **shared_preferences**: Local storage
- **json_serializable**: JSON serialization

## Code Generation

Projeyi çalıştırmadan önce code generation yapılmalıdır:

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

Watch mode (otomatik rebuild):
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Yeni Feature Ekleme

1. **Domain katmanını oluştur**:
   - `domain/entities/`: Entity sınıfları
   - `domain/repositories/`: Abstract repository interface
   - `domain/usecases/`: Use case'ler

2. **Data katmanını oluştur**:
   - `data/models/`: JSON serialization modelleri
   - `data/datasources/`: Remote ve Local data sources
   - `data/repositories/`: Repository implementasyonu

3. **Presentation katmanını oluştur**:
   - `presentation/pages/`: Sayfa widget'ları
   - `presentation/providers/`: Riverpod providers
   - `presentation/widgets/`: Feature-specific widget'lar

4. **Dependency Injection'a ekle**:
   - `core/injection/injection.dart` dosyasına yeni dependency'leri ekle

## Test Stratejisi

- **Unit Tests**: Use case'ler ve repository'ler
- **Widget Tests**: Presentation katmanı
- **Integration Tests**: End-to-end testler

## Avantajlar

1. **Bağımsızlık**: API, Firebase, Supabase değişse bile domain katmanı değişmez
2. **Test Edilebilirlik**: Her katman bağımsız test edilebilir
3. **Bakım Kolaylığı**: Tek sorumluluk prensibi ile kod daha okunabilir
4. **Ölçeklenebilirlik**: Yeni feature'lar kolayca eklenebilir
