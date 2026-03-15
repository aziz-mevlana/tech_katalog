import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const TechKatalogApp());
}

class TechKatalogApp extends StatelessWidget {
  const TechKatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tech & Gadget Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Ana renk paleti (Tailwind Indigo ve Slate tonları)
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5), // Modern Indigo
          surface: const Color(0xFFF8FAFC), // Çok hafif grimsi beyaz arka plan
          surfaceContainerHighest: const Color(0xFFF1F5F9), // Arama çubuğu vb. için
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        
        // Modern AppBar tasarımı (Arka planla bütünleşik, gölgesiz)
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF0F172A),
        ),
        

        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
          color: Colors.white,
        ),
        
        // Butonların köşelerini daha yumuşak yapıyoruz
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: const Color(0xFF4F46E5),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        
        // Seçili kategori (ChoiceChip) tasarımı
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFFF1F5F9), // Açık gri arka plan
          labelStyle: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500), // Gri metin

          selectedColor: const Color(0xFF4F46E5),
          secondaryLabelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}