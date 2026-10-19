import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';

void main() => runApp(const NoorQuranApp());

const Color emerald = Color(0xFF064E3B);
const Color gold = Color(0xFFD6B36A);
const Color cream = Color(0xFFFFF8E8);

class NoorQuranApp extends StatefulWidget {
  const NoorQuranApp({super.key});
  @override
  State<NoorQuranApp> createState() => _NoorQuranAppState();
}

class _NoorQuranAppState extends State<NoorQuranApp> {
  bool dark = false;
  int tab = 0;
  final Set<String> bookmarks = {'الفاتحة: 1'};
  final List<String> surahs = const [
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
  @override
  Widget build(BuildContext context) {
    final base = ThemeData(useMaterial3: true, fontFamily: 'NotoNaskhArabic', colorScheme: ColorScheme.fromSeed(seedColor: emerald, brightness: dark ? Brightness.dark : Brightness.light));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نور القرآن',
      theme: base.copyWith(scaffoldBackgroundColor: dark ? const Color(0xFF101916) : cream, appBarTheme: const AppBarTheme(backgroundColor: emerald, foregroundColor: Colors.white, centerTitle: true)),
      home: Directionality(textDirection: TextDirection.rtl, child: Scaffold(
        appBar: AppBar(title: const Text('☪ نور القرآن', style: TextStyle(fontWeight: FontWeight.bold)), actions: [
          IconButton(tooltip: 'الوضع الليلي', onPressed: () => setState(() => dark = !dark), icon: Icon(dark ? Icons.light_mode : Icons.dark_mode))
        ]),
        body: IndexedStack(index: tab, children: [
          HomePage(onOpenQuran: () => setState(() => tab = 1), onOpenFeature: (i) => setState(() => tab = i), surahs: surahs, bookmarks: bookmarks),
          QuranPage(surahs: surahs, bookmarks: bookmarks, onChanged: () => setState(() {})),
          const ListenPage(),
          const FeaturesPage(),
          const SettingsPage(),
        ]),
        bottomNavigationBar: NavigationBar(selectedIndex: tab, onDestinationSelected: (v) => setState(() => tab = v), destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'المصحف'),
          NavigationDestination(icon: Icon(Icons.headphones), label: 'التلاوة'),
          NavigationDestination(icon: Icon(Icons.grid_view), label: 'المزيد'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'الإعدادات'),
        ]),
      )),
    );
  }
}

class HomePage extends StatelessWidget {
  final VoidCallback onOpenQuran;
  final void Function(int) onOpenFeature;
  final List<String> surahs;
  final Set<String> bookmarks;
  const HomePage({super.key, required this.onOpenQuran, required this.onOpenFeature, required this.surahs, required this.bookmarks});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
    Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [emerald, Color(0xFF0D7660)]), borderRadius: BorderRadius.circular(24), border: Border.all(color: gold, width: 1.3)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('السَّلَامُ عَلَيْكُمْ', style: TextStyle(color: gold, fontSize: 18)),
      SizedBox(height: 8), Text('رفيقك اليومي مع القرآن الكريم', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
      SizedBox(height: 8), Text('اقرأ، استمع، وتدبّر في كل يوم', style: TextStyle(color: Colors.white70)),
    ]),
    const SizedBox(height: 16),
    Card(child: ListTile(leading: const Icon(Icons.bookmark, color: gold), title: const Text('متابعة القراءة'), subtitle: const Text('سورة الفاتحة • علامة تجريبية'), trailing: const Icon(Icons.chevron_left), onTap: onOpenQuran)),
    const SizedBox(height: 8), const Text('الوصول السريع', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    const SizedBox(height: 8),
    GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, childAspectRatio: 1.55, crossAxisSpacing: 10, mainAxisSpacing: 10, children: [
      _QuickCard(icon: Icons.menu_book, title: 'المصحف الشريف', onTap: onOpenQuran),
      _QuickCard(icon: Icons.headphones, title: 'استمع للقرآن', onTap: () => onOpenFeature(2)),
      _QuickCard(icon: Icons.explore, title: 'القبلة والصلاة', onTap: () => onOpenFeature(3)),
      _QuickCard(icon: Icons.favorite, title: 'الأذكار والتسبيح', onTap: () => onOpenFeature(3)),
    ]),
    const SizedBox(height: 16), const Text('سور القرآن', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    ...surahs.take(6).asMap().entries.map((e) => ListTile(leading: CircleAvatar(backgroundColor: emerald, foregroundColor: Colors.white, child: Text('${e.key+1}')), title: Text(e.value), subtitle: const Text('اضغط لفتح المصحف'), trailing: const Icon(Icons.chevron_left), onTap: onOpenQuran)),
  ]);
}

class _QuickCard extends StatelessWidget {
  final IconData icon; final String title; final VoidCallback onTap;
  const _QuickCard({required this.icon, required this.title, required this.onTap});
  @override Widget build(BuildContext context) => Card(child: InkWell(borderRadius: BorderRadius.circular(14), onTap: onTap, child: Padding(padding: const EdgeInsets.all(12), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: gold, size: 28), const SizedBox(height: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.bold))]))));
}

class QuranPage extends StatefulWidget {
  final List<String> surahs; final Set<String> bookmarks; final VoidCallback onChanged;
  const QuranPage({super.key, required this.surahs, required this.bookmarks, required this.onChanged});
  @override State<QuranPage> createState() => _QuranPageState();
}
class _QuranPageState extends State<QuranPage> {
  String selected = 'الفاتحة';
  String query = '';
  bool pageMode = false;
  @override Widget build(BuildContext context) {
    final filtered = widget.surahs.where((s) => s.contains(query)).toList();
    return Column(children: [
      Padding(padding: const EdgeInsets.all(12), child: TextField(decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'ابحث عن سورة...', border: OutlineInputBorder()), onChanged: (v) => setState(() => query = v))),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Row(children: [
        Expanded(child: SegmentedButton<bool>(segments: const [ButtonSegment(value: false, label: Text('عرض الآيات')), ButtonSegment(value: true, label: Text('شكل الصفحات'))], selected: {pageMode}, onSelectionChanged: (v) => setState(() => pageMode = v.first))),
        const SizedBox(width: 8), DropdownButton<String>(value: selected, items: widget.surahs.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (v) => setState(() => selected = v ?? selected)),
      ])),
      Expanded(child: query.isNotEmpty ? ListView(children: filtered.map((s) => ListTile(title: Text(s), onTap: () => setState(() { selected = s; query = ''; }))).toList()) : ListView(padding: const EdgeInsets.all(16), children: [
        Center(child: Text('سُورَةُ $selected', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: gold))),
        const SizedBox(height: 12),
        if (selected == 'الفاتحة') const Text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\n\nالْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ\n\nالرَّحْمَٰنِ الرَّحِيمِ\n\nمَالِكِ يَوْمِ الدِّينِ\n\nإِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ\n\nاهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ\n\nصِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ', textAlign: TextAlign.center, style: TextStyle(fontSize: 25, height: 2.0)),
        if (selected != 'الفاتحة') const Text('سيتم ربط نص السورة الكامل من مصدر قرآني موثوق في مرحلة تجهيز بيانات المصحف.', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, height: 1.8)),
        const SizedBox(height: 16),
        OutlinedButton.icon(onPressed: () { setState(() { widget.bookmarks.add('$selected: 1'); }); widget.onChanged(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ علامة قراءة تجريبية'))); }, icon: const Icon(Icons.bookmark_add), label: const Text('حفظ علامة القراءة')),
        if (pageMode) const Text('وضع الصفحات: يحتاج ملفات صفحات المصحف المرخّصة ليعرض الرسم المطابق للمصحف الورقي.', textAlign: TextAlign.center),
      ])),
    ]);
  }
}

class ListenPage extends StatefulWidget { const ListenPage({super.key}); @override State<ListenPage> createState() => _ListenPageState(); }
class _ListenPageState extends State<ListenPage> {
  bool playing = false; bool repeat = false; String reader = 'مشاري العفاسي'; double progress = 0;
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(18), children: [
    const SizedBox(height: 16), const Icon(Icons.graphic_eq, size: 92, color: gold), const SizedBox(height: 12),
    const Center(child: Text('التلاوة والاستماع', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
    const SizedBox(height: 16), DropdownButtonFormField<String>(value: reader, decoration: const InputDecoration(labelText: 'اختر القارئ', border: OutlineInputBorder()), items: const ['مشاري العفاسي','عبدالرحمن السديس','ماهر المعيقلي','محمود خليل الحصري','محمد صديق المنشاوي'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(), onChanged: (v) => setState(() => reader = v ?? reader)),
    const SizedBox(height: 16), const Text('سورة الفاتحة • نموذج واجهة', textAlign: TextAlign.center),
    Slider(value: progress, onChanged: (v) => setState(() => progress = v)),
    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      IconButton(onPressed: () => setState(() => progress = 0), icon: const Icon(Icons.skip_previous)),
      FilledButton.icon(onPressed: () => setState(() => playing = !playing), icon: Icon(playing ? Icons.pause : Icons.play_arrow), label: Text(playing ? 'إيقاف مؤقت' : 'تشغيل')),
      IconButton(onPressed: () => setState(() => progress = 0), icon: const Icon(Icons.skip_next)),
    ]),
    SwitchListTile(value: repeat, onChanged: (v) => setState(() => repeat = v), title: const Text('تكرار الآية للحفظ'), subtitle: const Text('التكرار الصوتي الفعلي يحتاج ملفات التلاوات ومشغل الصوت')),
    const Card(child: Padding(padding: EdgeInsets.all(12), child: Text('تنبيه: اختيار القارئ وأزرار التشغيل في هذه النسخة واجهة أولية؛ لم تُضمّن تسجيلات صوتية بعد.'))),
  ]);
}

class FeaturesPage extends StatefulWidget { const FeaturesPage({super.key}); @override State<FeaturesPage> createState() => _FeaturesPageState(); }
class _FeaturesPageState extends State<FeaturesPage> {
  int tasbeeh = 0; final TextEditingController search = TextEditingController();
  final List<String> features = const ['استوديو فيديو القرآن','التفسير','الترجمة','اختبار الحفظ','مواقيت الصلاة والأذان','اتجاه القبلة','الأذكار والأدعية','التسبيح الإلكتروني','الآية اليومية','التحميل دون إنترنت'];
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
    TextField(controller: search, decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'ابحث في القرآن (واجهة أولية)', border: OutlineInputBorder()), onSubmitted: (_) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('سيتم ربط البحث بقاعدة بيانات القرآن الكاملة')))),
    const SizedBox(height: 12), ...features.map((f) => Card(child: ListTile(leading: Icon(_icon(f), color: gold), title: Text(f), subtitle: Text(_description(f)), onTap: () {
      if (f == 'التسبيح الإلكتروني') showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setD) => AlertDialog(title: const Text('التسبيح الإلكتروني'), content: Text('$tasbeeh', textAlign: TextAlign.center, style: const TextStyle(fontSize: 40)), actions: [TextButton(onPressed: () => setD(() => tasbeeh = 0), child: const Text('تصفير')), FilledButton(onPressed: () => setD(() => tasbeeh++), child: const Text('سبّح'))])));
      else if (f == 'استوديو فيديو القرآن') Navigator.push(context, MaterialPageRoute(builder: (_) => const QuranVideoStudioPage()));
      else showDialog(context: context, builder: (ctx) => AlertDialog(title: Text(f), content: Text('هذه الميزة موجودة في خطة التطبيق، وتحتاج ربط مصدر بيانات/خدمة موثوقة قبل تفعيلها بالكامل: $f'), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('حسنًا'))]));
    }))),
  ]);
  IconData _icon(String f) { if (f.contains('تفسير')) return Icons.menu_book; if (f.contains('ترجمة')) return Icons.translate; if (f.contains('اختبار')) return Icons.quiz; if (f.contains('صلاة')) return Icons.access_time; if (f.contains('قبلة')) return Icons.explore; if (f.contains('أذكار')) return Icons.favorite; if (f.contains('تسبيح')) return Icons.radio_button_checked; if (f.contains('يومية')) return Icons.wb_sunny; return Icons.download; }
  String _description(String f) { if (f.contains('تفسير')) return 'شرح معتمد للآيات'; if (f.contains('ترجمة')) return 'معاني القرآن بلغات متعددة'; if (f.contains('اختبار')) return 'تدريب على الحفظ والمراجعة'; if (f.contains('صلاة')) return 'بحسب الموقع وطريقة الحساب'; if (f.contains('قبلة')) return 'تحديد اتجاه القبلة'; if (f.contains('أذكار')) return 'أذكار الصباح والمساء والأدعية'; if (f.contains('تسبيح')) return 'عداد تسبيح بسيط يعمل الآن'; if (f.contains('يومية')) return 'آية يومية'; return 'تنزيل المحتوى للاستخدام دون اتصال'; }
}



class QuranVideoStudioPage extends StatefulWidget {
  const QuranVideoStudioPage({super.key});
  @override State<QuranVideoStudioPage> createState() => _QuranVideoStudioPageState();
}
class _QuranVideoStudioPageState extends State<QuranVideoStudioPage> {
  String surah = 'الفاتحة';
  String reader = 'مشاري العفاسي';
  String format = 'عمودي 9:16 (Reels/TikTok)';
  bool translation = true;
  bool subtitles = true;
  bool repeat = false;
  bool busy = false;
  String? audioPath;
  String? imagePath;
  String? outputPath;
  String status = 'اختَر ملف تلاوة صوتية وخلفية صورة للبدء.';
  double progress = 0;

  Future<void> pickAudio() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result?.files.single.path != null) {
      setState(() { audioPath = result!.files.single.path; status = 'تم اختيار ملف التلاوة.'; outputPath = null; });
    }
  }

  Future<void> pickBackground() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result?.files.single.path != null) {
      setState(() { imagePath = result!.files.single.path; status = 'تم اختيار الخلفية.'; outputPath = null; });
    }
  }

  String _videoSize() {
    if (format.startsWith('أفقي')) return '1920:1080';
    if (format.startsWith('مربع')) return '1080:1080';
    return '1080:1920';
  }

  Future<void> exportVideo() async {
    if (audioPath == null || imagePath == null) {
      setState(() => status = 'لازم تختار ملف التلاوة وخلفية صورة أولًا.');
      return;
    }
    setState(() { busy = true; progress = 0.08; status = 'جاري تجهيز الفيديو...'; outputPath = null; });
    try {
      final dir = await getApplicationDocumentsDirectory();
      final out = '${dir.path}/Noor_Quran_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final size = _videoSize();
      // Zoom/pan animation is applied to a still background, while audio determines duration.
      final filter = "scale=$size:force_original_aspect_ratio=increase,crop=$size,zoompan=z='min(zoom+0.0005,1.12)':d=1:s=$size:fps=30,format=yuv420p";
      final command = '-y -loop 1 -framerate 30 -i "${imagePath!}" -i "${audioPath!}" -vf "$filter" -map 0:v:0 -map 1:a:0 -c:v libx264 -preset veryfast -tune stillimage -c:a aac -b:a 192k -shortest -movflags +faststart "$out"';
      final session = await FFmpegKit.execute(command);
      final rc = await session.getReturnCode();
      if (ReturnCode.isSuccess(rc) && await File(out).exists() && await File(out).length() > 1024) {
        setState(() { outputPath = out; progress = 1; status = 'تم إنشاء الفيديو وحفظه داخل ملفات التطبيق على الهاتف.'; });
      } else {
        final logs = await session.getAllLogsAsString();
        setState(() { status = 'فشل تصدير الفيديو. تأكد أن ملف الصوت والصورة صالحان. ${logs ?? ""}'; });
      }
    } catch (e) {
      setState(() => status = 'تعذّر التصدير: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('استوديو فيديو القرآن')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Container(height: 155, decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF062E27), Color(0xFF0B6552), Color(0xFFB68B43)])), child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.movie_creation_outlined, size: 50, color: Color(0xFFE7C779)),
        SizedBox(height: 8), Text('استوديو فيديو القرآن', style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold)),
        SizedBox(height: 6), Text('خلفية متحركة + تلاوة كاملة + تصدير MP4', style: TextStyle(color: Colors.white70), textAlign: TextAlign.center),
      ])),
      const SizedBox(height: 14),
      DropdownButtonFormField<String>(value: surah, decoration: const InputDecoration(labelText: 'اسم السورة (للتنظيم)', border: OutlineInputBorder()), items: const ['الفاتحة','البقرة','آل عمران','الكهف','يس','الرحمن','الواقعة','الملك','الإخلاص','الفلق','الناس'].map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(), onChanged: (v) => setState(() { surah = v ?? surah; outputPath = null; })),
      const SizedBox(height: 10),
      DropdownButtonFormField<String>(value: reader, decoration: const InputDecoration(labelText: 'اسم القارئ (للعنوان فقط)', border: OutlineInputBorder()), items: const ['مشاري العفاسي','عبدالرحمن السديس','ماهر المعيقلي','محمود خليل الحصري','محمد صديق المنشاوي','قارئ آخر'].map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(), onChanged: (v) => setState(() { reader = v ?? reader; outputPath = null; })),
      const SizedBox(height: 10),
      DropdownButtonFormField<String>(value: format, decoration: const InputDecoration(labelText: 'مقاس الفيديو', border: OutlineInputBorder()), items: const ['عمودي 9:16 (Reels/TikTok)','أفقي 16:9 (YouTube)','مربع 1:1'].map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(), onChanged: (v) => setState(() { format = v ?? format; outputPath = null; })),
      const SizedBox(height: 10),
      OutlinedButton.icon(onPressed: busy ? null : pickAudio, icon: const Icon(Icons.audio_file), label: Text(audioPath == null ? 'اختيار ملف التلاوة الصوتية' : 'تم اختيار ملف التلاوة ✓')),
      OutlinedButton.icon(onPressed: busy ? null : pickBackground, icon: const Icon(Icons.image), label: Text(imagePath == null ? 'اختيار صورة مسجد أو طبيعة' : 'تم اختيار الخلفية ✓')),
      SwitchListTile(value: subtitles, onChanged: (v) => setState(() => subtitles = v), title: const Text('إظهار الآيات مكتوبة'), subtitle: const Text('سيتم تفعيلها عند ربط بيانات الآيات وتوقيتها')),
      SwitchListTile(value: translation, onChanged: (v) => setState(() => translation = v), title: const Text('إضافة ترجمة للمعاني'), subtitle: const Text('خيار واجهة؛ لم تتم إضافة نص الترجمة للفيديو بعد')),
      SwitchListTile(value: repeat, onChanged: (v) => setState(() => repeat = v), title: const Text('تكرار التلاوة'), subtitle: const Text('مدة الفيديو حاليًا تتبع مدة ملف الصوت المختار')),
      const SizedBox(height: 8),
      FilledButton.icon(onPressed: busy ? null : exportVideo, icon: busy ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.movie_filter), label: Text(busy ? 'جاري التصدير...' : 'إنشاء وحفظ فيديو MP4')),
      if (busy) Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: LinearProgressIndicator(value: progress)),
      const SizedBox(height: 10),
      Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(status),
        if (outputPath != null) ...[
          const SizedBox(height: 8), const Text('مسار الحفظ:', style: TextStyle(fontWeight: FontWeight.bold)), SelectableText(outputPath!),
          const SizedBox(height: 8), const Text('الفيديو محفوظ داخل مجلد بيانات التطبيق. قد تحتاج إلى مدير ملفات أو إضافة زر مشاركة/حفظ إلى مجلد التنزيلات للوصول إليه بسهولة.'),
        ],
      ]))),
      const SizedBox(height: 8),
      const Text('مهم: هذه النسخة تحرك صورة ثابتة بتأثير تكبير بطيء وتدمجها مع ملف التلاوة إلى MP4 بطول الصوت. مشاهد فيديو طبيعية/مساجد حقيقية متحركة، وكتابة الآيات المتزامنة، تحتاج ملفات فيديو أو صور مرخّصة وبيانات آيات وتوقيتات موثوقة.', style: TextStyle(fontSize: 12)),
    ]),
  );
}

class SettingsPage extends StatelessWidget { const SettingsPage({super.key}); @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: const [
  Text('الإعدادات', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
  SizedBox(height: 12), ListTile(leading: Icon(Icons.text_fields), title: Text('حجم الخط'), subtitle: Text('سيتم إضافة التحكم التفصيلي')),
  ListTile(leading: Icon(Icons.menu_book), title: Text('طريقة عرض المصحف'), subtitle: Text('عرض الآيات أو صفحات المصحف')),
  ListTile(leading: Icon(Icons.offline_pin), title: Text('المحتوى دون إنترنت'), subtitle: Text('يتطلب إدراج بيانات القرآن وملفات الصوت المرخّصة')),
  ListTile(leading: Icon(Icons.info_outline), title: Text('حول التطبيق'), subtitle: Text('نور القرآن • نسخة أولية قابلة للتطوير')),
  Padding(padding: EdgeInsets.all(12), child: Text('مهم: هذه نسخة واجهة أولية وليست إصدارًا نهائيًا دينيًا أو جاهزًا للنشر. يجب مراجعة نص القرآن ومصادر التفسير والتلاوات قبل النشر.', textAlign: TextAlign.center)),
]); }