import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';

const Color emerald = Color(0xFF064E3B);
const Color gold = Color(0xFFD6B36A);

class ReciterData {
  final String name;
  final String serverUrl;
  const ReciterData({required this.name, required this.serverUrl});
}

const List<ReciterData> recitersList = [
  ReciterData(name: 'مشاري العفاسي', serverUrl: 'https://server8.mp3quran.net/afs/'),
  ReciterData(name: 'عبد الباسط عبد الصمد', serverUrl: 'https://server7.mp3quran.net/basit/'),
  ReciterData(name: 'محمد صديق المنشاوي', serverUrl: 'https://server10.mp3quran.net/minsh/'),
  ReciterData(name: 'محمود خليل الحصري', serverUrl: 'https://server13.mp3quran.net/husr/'),
  ReciterData(name: 'ماهر المعيقلي', serverUrl: 'https://server12.mp3quran.net/maher/'),
  ReciterData(name: 'عبد الرحمن السديس', serverUrl: 'https://server11.mp3quran.net/sds/'),
];

const List<String> surahsList = [
  'الفاتحة','البقرة','آل عمران','النساء','المائدة','الأنعام','الأعراف','الأنفال','التوبة','يونس',
  'هود','يوسف','الرعد','إبراهيم','الحجر','النحل','الإسراء','الكهف','مريم','طه',
  'الأنبياء','الحج','المؤمنون','النور','الفرقان','الشعراء','النمل','القصص','العنكبوت','الروم',
  'لقمان','السجدة','الأحزاب','سبأ','فاطر','يس','الصافات','ص','الزمر','غافر',
  'فصلت','الشورى','الزخرف','الدخان','الجاثية','الأحقاف','محمد','الفتح','الحجرات','ق',
  'الذاريات','الطور','النجم','القمر','الرحمن','الواقعة','الحديد','المجادلة','الحشر','الممتحنة',
  'الصف','الجمعة','المنافقون','التغابن','الطلاق','التحريم','الملك','القلم','الحاقة','المعارج',
  'نوح','الجن','المزمل','المدثر','القيامة','الإنسان','المرسلات','النبأ','النازعات','عبس',
  'التكوير','الانفطار','المطففين','الانشقاق','البروج','الطارق','الأعلى','الغاشية','الفجر','البلد',
  'الشمس','الليل','الضحى','الشرح','التين','العلق','القدر','البينة','الزلزلة','العاديات',
  'القارعة','التكاثر','العصر','الهمزة','الفيل','قريش','الماعون','الكوثر','الكافرون','النصر',
  'المسد','الإخلاص','الفلق','الناس'
];

class AdhkarPage extends StatefulWidget {
  const AdhkarPage({super.key});
  @override
  State<AdhkarPage> createState() => _AdhkarPageState();
}

class _AdhkarPageState extends State<AdhkarPage> {
  int tasbeeh = 0;
  final List<Map<String, String>> azkar = const [
    {'title': 'سيد الاستغفار', 'text': 'اللَّهُمَّ أَنْتَ رَبِّي لاَ إِلَهَ إِلاَّ أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ.'},
    {'title': 'أذكار الصباح والمساء', 'text': 'بِسْمِ اللَّهِ الَّذِي لاَ يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الأَرْضِ وَلاَ فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ.'},
    {'title': 'التسبيح والتحميد', 'text': 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، عَدَدَ خَلْقِهِ، وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ، وَمِدَادَ كَلِمَاتِهِ.'},
    {'title': 'الحوقلة', 'text': 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ الْعَلِيِّ الْعَظِيمِ، كَنْزٌ مِنْ كُنُوزِ الْجَنَّةِ.'},
  ];

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Card(
        color: emerald,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            const Text('السبحة الإلكترونية', style: TextStyle(color: gold, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('$tasbeeh', style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: gold, foregroundColor: Colors.black), onPressed: () => setState(() => tasbeeh++), icon: const Icon(Icons.touch_app), label: const Text('سبِّح')),
              const SizedBox(width: 12),
              OutlinedButton(style: OutlinedButton.styleFrom(foregroundColor: Colors.white), onPressed: () => setState(() => tasbeeh = 0), child: const Text('تصفير')),
            ]),
          ]),
        ),
      ),
      const SizedBox(height: 16),
      const Text('أدعية وأذكار المسلم', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      ...azkar.map((z) => Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          leading: const Icon(Icons.favorite, color: gold),
          title: Text(z['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Padding(padding: const EdgeInsets.only(top: 6), child: Text(z['text']!, style: const TextStyle(fontSize: 15))),
        ),
      )),
    ],
  );
}

class QuranVideoStudioPage extends StatefulWidget {
  const QuranVideoStudioPage({super.key});
  @override State<QuranVideoStudioPage> createState() => _QuranVideoStudioPageState();
}

class _QuranVideoStudioPageState extends State<QuranVideoStudioPage> {
  String surah = 'الفاتحة';
  String format = 'عمودي 9:16 (Reels/TikTok)';
  bool busy = false;
  String? audioPath;
  String? imagePath;
  String? outputPath;
  String status = 'اختَر ملف التلاوة وخلفية صورة للبدء.';

  Future<void> pickAudio() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (res?.files.single.path != null) setState(() { audioPath = res!.files.single.path; status = 'تم اختيار الصوت بنجاح.'; });
  }

  Future<void> pickImage() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.image);
    if (res?.files.single.path != null) setState(() { imagePath = res!.files.single.path; status = 'تم اختيار الصورة بنجاح.'; });
  }

  Future<void> exportVideo() async {
    if (audioPath == null || imagePath == null) {
      setState(() => status = 'يرجى اختيار ملف الصوت وملف الصورة أولاً.');
      return;
    }
    setState(() { busy = true; status = 'جاري التصدير...'; });
    try {
      final dir = await getApplicationDocumentsDirectory();
      final out = '${dir.path}/Noor_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final sz = format.startsWith('أفقي') ? '1920:1080' : '1080:1920';
      final cmd = '-y -loop 1 -framerate 30 -i "$imagePath" -i "$audioPath" -vf "scale=$sz:force_original_aspect_ratio=increase,crop=$sz,format=yuv420p" -c:v libx264 -preset veryfast -c:a aac -b:a 192k -shortest "$out"';
      final s = await FFmpegKit.execute(cmd);
      final rc = await s.getReturnCode();
      if (ReturnCode.isSuccess(rc)) {
        setState(() { outputPath = out; status = 'تم تصدير الفيديو بنجاح!'; });
      } else {
        setState(() => status = 'حدث خطأ أثناء المعالجة.');
      }
    } catch (e) {
      setState(() => status = 'تعذر التصدير: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('استوديو فيديو القرآن')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      OutlinedButton.icon(onPressed: busy ? null : pickAudio, icon: const Icon(Icons.audio_file), label: Text(audioPath == null ? 'اختيار ملف الصوت' : 'تم اختيار الصوت ✓')),
      const SizedBox(height: 8),
      OutlinedButton.icon(onPressed: busy ? null : pickImage, icon: const Icon(Icons.image), label: Text(imagePath == null ? 'اختيار صورة الخلفية' : 'تم اختيار الصورة ✓')),
      const SizedBox(height: 12),
      FilledButton.icon(onPressed: busy ? null : exportVideo, icon: busy ? const CircularProgressIndicator(color: Colors.white) : const Icon(Icons.movie_creation), label: Text(busy ? 'جاري المعالجة...' : 'تصدير فيديو MP4')),
      const SizedBox(height: 12),
      Card(child: Padding(padding: const EdgeInsets.all(12), child: Text(status))),
    ]),
  );
}
