import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod kullandığımız için ekledik

import 'package:dream_tales/main.dart';

void main() {
  testWidgets('Dream Tales app smoke test', (WidgetTester tester) async {
    // 1. Uygulamamızı test ortamında ayağa kaldırıyoruz.
    // Riverpod kullandığımız için ProviderScope ile sarmalamak zorundayız.
    // Ayrıca yeni eklediğimiz zorunlu 'hasSeenOnboarding' parametresini test için false veriyoruz.
    await tester.pumpWidget(
      const ProviderScope(
        child: DreamTalesApp(hasSeenOnboarding: false),
      ),
    );

    // 2. Uygulamanın çökmeden başarıyla açıldığını (MaterialApp'in ekrana çizildiğini) test ediyoruz.
    expect(find.byType(MaterialApp), findsOneWidget);
    
    // Uygulamamızda artık sayaç (counter) olmadığı için o eski test satırlarını tamamen kaldırdık!
  });
}