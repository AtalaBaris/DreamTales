import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/story_provider.dart';

/// StoryCreatorPage - Masal oluşturma sayfası
/// 
/// Clean Architecture'da presentation katmanı:
/// - UI'ı render eder
/// - State'i Riverpod provider'lardan okur
/// - User action'ları notifier'a gönderir
class StoryCreatorPage extends ConsumerStatefulWidget {
  const StoryCreatorPage({super.key});

  @override
  ConsumerState<StoryCreatorPage> createState() => _StoryCreatorPageState();
}

class _StoryCreatorPageState extends ConsumerState<StoryCreatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _handleCreateStory() {
    if (_formKey.currentState!.validate()) {
      ref.read(storyNotifierProvider.notifier).createStory(
            title: _titleController.text,
            content: _contentController.text,
          );

      // Başarılı olursa geri dön
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Riverpod state'i dinle
    final storyState = ref.watch(storyNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Masal Oluştur'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                hintText: 'Masal Başlığı',
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Başlık gerekli';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: CustomTextField(
                  hintText: 'Masal İçeriği',
                  controller: _contentController,
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'İçerik gerekli';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Masalı Oluştur',
                onPressed: storyState.isLoading ? null : _handleCreateStory,
                isLoading: storyState.isLoading,
              ),
              if (storyState.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    storyState.error!.message,
                    style: const TextStyle(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
