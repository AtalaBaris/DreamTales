import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/injection/injection.dart';
import '../../../home/presentation/home_page.dart';
import '../../domain/repositories/auth_repository.dart';
import 'register_page.dart';

/// LoginPage - Giriş Sayfası Component
/// 
/// React'taki bir "Page Component" mantığında çalışır.
/// StatefulWidget kullanarak state yönetimi yapılır (React'taki useState gibi).
/// 
/// Bu sayfa:
/// - Email ve şifre input alanları içerir
/// - Giriş butonu içerir
/// - Kayıt ol linki içerir
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// _LoginPageState - LoginPage'in state yönetim sınıfı
/// 
/// React'taki functional component + useState hook mantığına benzer:
/// ```javascript
/// const [email, setEmail] = useState('');
/// const [password, setPassword] = useState('');
/// const [isLoading, setIsLoading] = useState(false);
/// ```
class _LoginPageState extends State<LoginPage> {
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

  /// isLoading - Giriş işlemi yükleniyor mu?
  /// React'taki: const [isLoading, setIsLoading] = useState(false);
  bool _isLoading = false;

  /// errorMessage - Hata mesajı (textbox'un üstünde gösterilecek)
  /// React'taki: const [errorMessage, setErrorMessage] = useState('');
  String? _errorMessage;

  /// Form key - Form validation için kullanılır
  /// React'taki form validation (örn: react-hook-form) mantığına benzer
  final _formKey = GlobalKey<FormState>();

  /// Form'u temizle
  void _resetForm() {
    setState(() {
      _emailController.clear();
      _passwordController.clear();
      _errorMessage = null;
      _formKey.currentState?.reset();
    });
  }

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
    super.dispose();
  }

  /// handleLogin - Giriş butonuna tıklandığında çağrılan fonksiyon
  /// React'taki event handler fonksiyonuna benzer:
  /// const handleLogin = async () => {
  ///   setIsLoading(true);
  ///   try {
  ///     await login(email, password);
  ///   } finally {
  ///     setIsLoading(false);
  ///   }
  /// };
  Future<void> _handleLogin() async {
    // Form validation - React'taki form validation mantığına benzer
    if (!_formKey.currentState!.validate()) {
      return; // Form geçersizse işlemi durdur
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

      // Gerçek login API çağrısı
      await authRepository.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );

      // Başarılı giriş sonrası HomePage'e yönlendir
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const HomePage(),
          ),
        );
      }
    } on AuthException catch (e) {
      // Supabase auth hataları - daha anlamlı mesajlar
      String errorMessage = 'Giriş başarısız';
      
      // Hata koduna göre özel mesajlar
      if (e.message.contains('Invalid login credentials') ||
          e.message.contains('Invalid email or password')) {
        errorMessage = 'E-posta veya şifre hatalı';
      } else if (e.message.contains('Email not confirmed')) {
        errorMessage = 'E-posta adresinizi doğrulamanız gerekiyor';
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
          _errorMessage = 'Giriş başarısız: ${e.toString()}';
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
                const SizedBox(height: 60),
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
                  'Masalların büyülü dünyasına hoş geldin',
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
                    return null; // Geçerli
                  },
                ),

                const SizedBox(height: 16),
                CustomTextField(
                  // Password input - React'taki <input type="password" />
                  hintText: 'Şifre',
                  controller: _passwordController,
                  isPassword: true,
                  validator: (value) {
                    // Form validation - React'taki validation mantığına benzer
                    if (value == null || value.isEmpty) {
                      return 'Şifre gerekli';
                    }
                    if (value.length < 6) {
                      return 'Şifre en az 6 karakter olmalı';
                    }
                    return null; // Geçerli
                  },
                ),

                // Giriş butonu
                // React'taki <button onClick={handleLogin}> mantığına benzer
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Giriş Yap',
                  onPressed: _handleLogin, // React'taki onClick={handleLogin}
                  isLoading: _isLoading, // React'taki disabled={isLoading}
                ),

                // Kayıt ol linki - sadece "Kayıt ol" tıklanabilir
                const SizedBox(height: 24),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Hesabın yok mu?',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                        if (result == true && mounted) {
                          _resetForm();
                        }
                      },
                      child: Text(
                        'Kayıt ol',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
