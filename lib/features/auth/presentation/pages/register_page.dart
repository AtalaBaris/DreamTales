import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/injection/injection.dart';
import '../../domain/repositories/auth_repository.dart';

/// RegisterPage - Kayıt Sayfası Component
/// 
/// React'taki bir "Page Component" mantığında çalışır.
/// StatefulWidget kullanarak state yönetimi yapılır (React'taki useState gibi).
/// 
/// Bu sayfa:
/// - Email, şifre ve şifre tekrar input alanları içerir
/// - Kayıt ol butonu içerir
/// - Giriş yap linki içerir
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

/// _RegisterPageState - RegisterPage'in state yönetim sınıfı
/// 
/// React'taki functional component + useState hook mantığına benzer:
/// ```javascript
/// const [email, setEmail] = useState('');
/// const [password, setPassword] = useState('');
/// const [confirmPassword, setConfirmPassword] = useState('');
/// const [isLoading, setIsLoading] = useState(false);
/// ```
class _RegisterPageState extends State<RegisterPage> {
  // TextEditingController - Input değerlerini kontrol eder
  // React'taki useRef veya controlled input mantığına benzer:
  // const emailRef = useRef(null); veya
  // const [email, setEmail] = useState('');
  
  /// Email input controller
  /// React'taki: const emailRef = useRef(null);
  final TextEditingController _emailController = TextEditingController();

  /// Password input controller
  /// React'taki: const passwordRef = useRef(null);
  final TextEditingController _passwordController = TextEditingController();

  /// Confirm Password input controller
  /// React'taki: const confirmPasswordRef = useRef(null);
  final TextEditingController _confirmPasswordController = TextEditingController();

  /// isLoading - Kayıt işlemi yükleniyor mu?
  /// React'taki: const [isLoading, setIsLoading] = useState(false);
  bool _isLoading = false;

  /// Form key - Form validation için kullanılır
  /// React'taki form validation (örn: react-hook-form) mantığına benzer
  final _formKey = GlobalKey<FormState>();

  /// _isPasswordVisible - Şifre görünür mü? (şifre göster/gizle için)
  /// React'taki: const [isPasswordVisible, setIsPasswordVisible] = useState(false);
  bool _isPasswordVisible = false;

  /// _isConfirmPasswordVisible - Şifre tekrar görünür mü?
  bool _isConfirmPasswordVisible = false;

  /// errorMessage - Hata mesajı (textbox'un üstünde gösterilecek)
  /// React'taki: const [errorMessage, setErrorMessage] = useState('');
  String? _errorMessage;

  @override
  void dispose() {
    // Component unmount olduğunda (sayfa kapatıldığında) çalışır
    // React'taki useEffect cleanup function'ına benzer:
    // useEffect(() => {
    //   return () => {
    //     emailRef.current = null;
    //   };
    // }, []);

    // Controller'ları temizle (memory leak önlemek için)
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// handleRegister - Kayıt butonuna tıklandığında çağrılan fonksiyon
  /// React'taki event handler fonksiyonuna benzer:
  /// const handleRegister = async () => {
  ///   setIsLoading(true);
  ///   try {
  ///     await register(email, password);
  ///   } finally {
  ///     setIsLoading(false);
  ///   }
  /// };
  Future<void> _handleRegister() async {
    // Form validation - React'taki form validation mantığına benzer
    if (!_formKey.currentState!.validate()) {
      return; // Form geçersizse işlemi durdur
    }

    // Şifre eşleşme kontrolü
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Şifreler eşleşmiyor'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // setState - React'taki setState veya state setter'ına benzer
    // setState(() => { _isLoading = true; }) gibi
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Hata mesajını temizle
    });

    try {
      // AuthRepository'yi get_it ile al
      final authRepository = getIt<AuthRepository>();

      // Gerçek register API çağrısı
      await authRepository.signUp(
        _emailController.text.trim(),
        _passwordController.text,
      );

      // Başarılı kayıt sonrası yönlendirme
      if (mounted) {
        // Email confirmation açıksa bilgilendirme mesajı göster
        final needsEmailConfirmation = authRepository.currentUser == null;
        
        // Loading'i kapat
        setState(() {
          _isLoading = false;
        });
        
        // Başarı dialog'unu göster (ekranın ortasında, spinner ile)
        // Dialog otomatik olarak kapanacak ve login'e yönlendirecek
        if (mounted) {
          // Dialog'u göster
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              // Dialog içinde timer başlat
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted && Navigator.of(dialogContext).canPop()) {
                  Navigator.of(dialogContext).pop(); // Dialog'u kapat
                }
                // Register sayfasını kapat, login'e dön
                // true değeri ile Login sayfasına form'u temizlemesi için sinyal gönder
                if (mounted && Navigator.of(context).canPop()) {
                  Navigator.of(context).pop(true); // Register sayfasını kapat, login'e dön (result: true)
                }
              });
              
              return PopScope(
                canPop: false, // Dialog'u kapatmayı engelle
                child: Dialog(
                  backgroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Spinner
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.success,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Başarı mesajı
                        Text(
                          needsEmailConfirmation
                              ? 'Kayıt başarılı!'
                              : 'Kayıt başarılı!',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          needsEmailConfirmation
                              ? 'E-posta adresinize doğrulama linki gönderdik.\nLütfen e-postanızı kontrol edin.'
                              : 'Giriş sayfasına yönlendiriliyorsunuz...',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      }
    } on AuthException catch (e) {
      // Supabase auth hataları - daha anlamlı mesajlar
      String errorMessage = 'Kayıt başarısız';
      
      // Hata koduna göre özel mesajlar
      if (e.message.contains('User already registered') ||
          e.message.contains('already registered')) {
        errorMessage = 'Bu e-posta adresi zaten kullanılıyor';
      } else if (e.message.contains('Password')) {
        errorMessage = 'Şifre çok zayıf. Lütfen daha güçlü bir şifre seçin';
      } else if (e.message.contains('Email')) {
        errorMessage = 'Geçersiz e-posta adresi';
      } else {
        errorMessage = e.message;
      }

      // Hata mesajını state'e kaydet (textbox'un üstünde gösterilecek)
      if (mounted) {
        setState(() {
          _errorMessage = errorMessage;
        });
      }
    } catch (e) {
      // Genel hatalar
      if (mounted) {
        setState(() {
          _errorMessage = 'Kayıt başarısız: ${e.toString()}';
        });
      }
    } finally {
      // Loading durumunu kapat
      // React'taki: setIsLoading(false);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // React'taki return JSX kısmına benzer
    // Burada widget tree'si oluşturulur

    return Scaffold(
      // Body - Sayfanın ana içeriği
      // React'taki <div className="container"> mantığına benzer
      body: SafeArea(
        // SafeArea - Telefonun notch ve status bar'ından kaçınır
        // React'taki CSS safe-area-inset mantığına benzer

        child: SingleChildScrollView(
          // SingleChildScrollView - İçerik taşarsa kaydırılabilir yapar
          // React'taki overflow: 'auto' CSS özelliğine benzer

          padding: const EdgeInsets.all(24),
          child: Form(
            // Form - Form validation için wrapper
            // React'taki <form> element'ine benzer
            key: _formKey,

            child: Column(
              // Column - Dikey sıralama (flex-direction: column)
              // React'taki flexbox mantığına benzer
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                // Logo/Başlık bölümü
                // React'taki <header> veya <div className="header"> mantığına benzer
                const SizedBox(height: 40),
                const Icon(
                  Icons.auto_awesome,
                  size: 80,
                  color: AppColors.secondary,
                ),
                const SizedBox(height: 24),
                const Text(
                  'DreamTales',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Masalların büyülü dünyasına katıl',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),

                // Input alanları bölümü
                // React'taki <div className="form-group"> mantığına benzer
                const SizedBox(height: 48),
                
                // Hata mesajı - textbox'un üstünde gösterilir
                if (_errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.error,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: AppColors.error,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                CustomTextField(
                  // Email input - React'taki <input type="email" />
                  hintText: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    // Form validation - React'taki validation mantığına benzer
                    if (value == null || value.isEmpty) {
                      return 'Email adresi gerekli';
                    }
                    if (!value.contains('@')) {
                      return 'Geçerli bir email adresi girin';
                    }
                    // Email format kontrolü (basit)
                    final emailRegex = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                    );
                    if (!emailRegex.hasMatch(value)) {
                      return 'Geçerli bir email adresi girin';
                    }
                    return null; // Geçerli
                  },
                ),

                const SizedBox(height: 16),
                // Password input - Şifre göster/gizle özelliği ile
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Şifre',
                    hintStyle: TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: AppColors.backgroundLight,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: AppColors.textTertiary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppColors.error,
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppColors.error,
                        width: 2,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.textSecondary,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        // Şifre görünürlüğünü toggle et
                        // React'taki: setIsPasswordVisible(!isPasswordVisible)
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Şifre gerekli';
                    }
                    if (value.length < 6) {
                      return 'Şifre en az 6 karakter olmalı';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                // Confirm Password input - Şifre tekrar göster/gizle özelliği ile
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Şifre Tekrar',
                    hintStyle: TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: AppColors.backgroundLight,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: AppColors.textTertiary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppColors.error,
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppColors.error,
                        width: 2,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.textSecondary,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        // Şifre tekrar görünürlüğünü toggle et
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Şifre tekrar gerekli';
                    }
                    if (value != _passwordController.text) {
                      return 'Şifreler eşleşmiyor';
                    }
                    return null;
                  },
                ),

                // Kayıt ol butonu
                // React'taki <button onClick={handleRegister}> mantığına benzer
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Kayıt Ol',
                  onPressed: _handleRegister, // React'taki onClick={handleRegister}
                  isLoading: _isLoading, // React'taki disabled={isLoading}
                ),

                // Giriş yap linki
                // React'taki <Link to="/login"> mantığına benzer
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    // Login sayfasına geri dön
                    // pop() kullanıyoruz çünkü Register sayfası Login'den açılıyor
                    // Alternatif: pushReplacement kullanılabilir (navigation stack'i temizler)
                    Navigator.of(context).pop();
                    // Veya pushReplacement ile:
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(builder: (context) => const LoginPage()),
                    // );
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        const TextSpan(text: 'Zaten hesabın var mı? '),
                        TextSpan(
                          text: 'Giriş Yap',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
