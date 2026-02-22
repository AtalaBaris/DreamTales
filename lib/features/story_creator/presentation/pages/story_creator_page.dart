import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/story_provider.dart';

class StoryCreatorPage extends ConsumerStatefulWidget {
  const StoryCreatorPage({super.key});

  @override
  ConsumerState<StoryCreatorPage> createState() => _StoryCreatorPageState();
}

class _StoryCreatorPageState extends ConsumerState<StoryCreatorPage> {
  final _formKey = GlobalKey<FormState>();

  // Text Kontrolleri
  final _childNameController = TextEditingController();
  final _childAgeController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _siblingNameController = TextEditingController();
  final _petController = TextEditingController();

  // Seçmeli Alanlar
  String _selectedSetting = 'Büyülü Orman';
  String _selectedMoral = 'Cesaret';

  final List<String> _settings = [
    'Büyülü Orman', 'Uzay Macerası', 'Korsan Gemisi', 
    'Peri Şatosu', 'Sualtı Krallığı', 'Gizemli Ada'
  ];

  final List<String> _morals = [
    'Cesaret', 'Paylaşmak', 'Arkadaşlık', 
    'Dürüstlük', 'Doğa Sevgisi', 'Sabır'
  ];

  @override
  void dispose() {
    _childNameController.dispose();
    _childAgeController.dispose();
    _motherNameController.dispose();
    _fatherNameController.dispose();
    _siblingNameController.dispose();
    _petController.dispose();
    super.dispose();
  }

  // YENİDEN DÜZENLENEN KISIM: Riverpod'u tetikliyoruz
  Future<void> _handleGenerateStory() async {
    if (_formKey.currentState!.validate()) {
      // 1. Klavyeyi kapat (ekranda yer açsın)
      FocusScope.of(context).unfocus();

      // 2. Kullanıcıya bilgi ver
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✨ Masalın sihri hazırlanıyor... Lütfen bekleyin.')),
      );

      // 3. Prompt'u (Yapay zekaya gidecek metni) oluştur
      // Yapay zekaya "Bana şöyle bir masal yaz" demek için verileri düzgün bir cümleye çeviriyoruz.
      final promptText = '''
        Lütfen bana bir çocuk masalı yaz. 
        Ana Karakterin Adı: ${_childNameController.text}
        ${_childAgeController.text.isNotEmpty ? 'Yaşı: ${_childAgeController.text}' : ''}
        ${_motherNameController.text.isNotEmpty ? 'Annesinin Adı: ${_motherNameController.text}' : ''}
        ${_fatherNameController.text.isNotEmpty ? 'Babasının Adı: ${_fatherNameController.text}' : ''}
        ${_siblingNameController.text.isNotEmpty ? 'Kardeşinin Adı: ${_siblingNameController.text}' : ''}
        ${_petController.text.isNotEmpty ? 'Evcil Hayvanı: ${_petController.text}' : ''}
        Mekan: $_selectedSetting
        Masalın Ana Fikri (Dersi): $_selectedMoral
        Lütfen masalı yaratıcı, eğitici ve çocuklara uygun bir dille yaz.
      ''';

      print('Yapay Zekaya Giden Prompt: \n$promptText');

      // 4. Riverpod üzerinden CreateStory UseCase'ini çağır
      // Masalın başlığını şimdilik dinamik bir şey yapıyoruz.
      final baslik = "${_childNameController.text}'in $_selectedSetting Macerası";

      await ref.read(storyNotifierProvider.notifier).createStory(
        title: baslik,
        content: promptText, // Şimdilik prompt'u content olarak yolluyoruz. Aslında yapay zeka servisin bu prompt'u alıp sana masal döndürecek.
      );

      // 5. İşlem bittikten sonra hata yoksa (state.error null ise) önceki sayfaya dön
      if (mounted) {
        final state = ref.read(storyNotifierProvider);
        if (state.error == null) {
          Navigator.of(context).pop(); // Başarılıysa ana sayfaya geri dön!
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('🎉 Masal başarıyla oluşturuldu!')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Riverpod state'ini dinliyoruz
    final storyState = ref.watch(storyNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Kendi Masalını Yarat',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              _buildSectionTitle('Kahramanımız Kim?'),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildTextField(
                      controller: _childNameController,
                      label: 'Çocuğun Adı*',
                      icon: Icons.face,
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: _buildTextField(
                      controller: _childAgeController,
                      label: 'Yaşı',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Ailesi ve Dostları (İsteğe Bağlı)'),
              _buildTextField(
                controller: _motherNameController,
                label: 'Anne Adı',
                icon: Icons.woman,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _fatherNameController,
                label: 'Baba Adı',
                icon: Icons.man,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _siblingNameController,
                label: 'Kardeşinin Adı',
                icon: Icons.child_care,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _petController,
                label: 'Evcil Hayvanı (Örn: Karabaş adında köpek)',
                icon: Icons.pets,
              ),
              const SizedBox(height: 32),

              _buildSectionTitle('Masal Nerede Geçsin?'),
              _buildChips(_settings, _selectedSetting, (val) {
                setState(() => _selectedSetting = val);
              }),
              const SizedBox(height: 32),

              _buildSectionTitle('Masalın Ana Fikri Ne Olsun?'),
              _buildChips(_morals, _selectedMoral, (val) {
                setState(() => _selectedMoral = val);
              }),
              const SizedBox(height: 40),

              // Oluştur Butonu (Yüklenme durumu bağlandı)
              ElevatedButton(
                onPressed: storyState.isLoading ? null : _handleGenerateStory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                ),
                child: storyState.isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Yapay Zeka ile Masal Oluştur',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
              if (storyState.error != null) ...[
                const SizedBox(height: 16),
                Text(
                  storyState.error!.message, // Eğer bir hata fırlatılırsa burada görünecek
                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: icon != null ? Icon(icon, color: AppColors.textSecondary) : null,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
        ),
      ),
      validator: isRequired
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Bu alan zorunludur';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildChips(List<String> items, String selectedItem, Function(String) onSelected) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final isSelected = selectedItem == item;
        return ChoiceChip(
          label: Text(item),
          selected: isSelected,
          onSelected: (_) => onSelected(item),
          selectedColor: Colors.deepPurpleAccent.withOpacity(0.3),
          backgroundColor: AppColors.surface,
          labelStyle: TextStyle(
            color: isSelected ? Colors.deepPurpleAccent : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          side: BorderSide(
            color: isSelected ? Colors.deepPurpleAccent : Colors.transparent,
          ),
        );
      }).toList(),
    );
  }
}