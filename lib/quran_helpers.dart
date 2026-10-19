import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SurahInfo {
  final int number;
  final String name;
  final String englishName;
  final int ayahsCount;
  final String type;

  const SurahInfo({
    required this.number,
    required this.name,
    required this.englishName,
    required this.ayahsCount,
    required this.type,
  });
}

class AyahModel {
  final int numberInSurah;
  final String text;
  final String translation;
  final String tafsir;

  AyahModel({
    required this.numberInSurah,
    required this.text,
    required this.translation,
    required this.tafsir,
  });

  Map<String, dynamic> toJson() => {
    'numberInSurah': numberInSurah,
    'text': text,
    'translation': translation,
    'tafsir': tafsir,
  };

  factory AyahModel.fromJson(Map<String, dynamic> json) => AyahModel(
    numberInSurah: json['numberInSurah'] ?? 1,
    text: json['text'] ?? '',
    translation: json['translation'] ?? '',
    tafsir: json['tafsir'] ?? '',
  );
}

class QuranService {
  static const List<SurahInfo> surahs = [
    SurahInfo(number: 1, name: 'الفاتحة', englishName: 'Al-Fatiha', ayahsCount: 7, type: 'مكية'),
    SurahInfo(number: 2, name: 'البقرة', englishName: 'Al-Baqarah', ayahsCount: 286, type: 'مدنية'),
    // Add other surahs here
  ];

  static Future<List<AyahModel>> fetchAyahs(int surahNumber) async {
    final response = await http.get(Uri.parse('https://api.alquran.cloud/v1/surah/$surahNumber/quran-uthmani'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final ayahs = (data['data']['ayahs'] as List)
          .map((ayah) => AyahModel(
              numberInSurah: ayah['number'],
              text: ayah['text'],
              translation: '',
              tafsir: ''))
          .toList();
      return ayahs;
    } else {
      throw Exception('Failed to load ayahs');
    }
  }

  static Future<String> fetchTafsir(int surahNumber) async {
    // Implement tafsir fetching logic here
    return 'تفسير السورة';
  }

  static Future<String> fetchTranslation(int surahNumber) async {
    // Implement translation fetching logic here
    return 'ترجمة السورة';
  }
}
