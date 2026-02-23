import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const PoleApp());
}

class PoleApp extends StatelessWidget {
  const PoleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polepositionsignal',
      theme: ThemeData(useMaterial3: true),
      home: const HomeShell(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const SettingsPage(),
      const ResultsPage(),
    ];
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.tune), label: 'Ayarlar'),
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Sonuçlar'),
        ],
      ),
    );
  }
}

class BotSettings {
  double long4hMin;
  double long4hMax;
  double long1hMin;
  double long1hMax;

  double short4hMin;
  double short4hMax;
  double short1hMin;
  double short1hMax;

  double m15_7_25_Min;
  double m15_7_25_Max;

  double m15_25_7_Min;
  double m15_25_7_Max;

  double m15_7_45_Min;
  double m15_7_45_Max;

  double m15_45_7_Min;
  double m15_45_7_Max;

  int topN;
  int orderbookN;
  int topLevels;

  BotSettings({
    required this.long4hMin,
    required this.long4hMax,
    required this.long1hMin,
    required this.long1hMax,
    required this.short4hMin,
    required this.short4hMax,
    required this.short1hMin,
    required this.short1hMax,
    required this.m15_7_25_Min,
    required this.m15_7_25_Max,
    required this.m15_25_7_Min,
    required this.m15_25_7_Max,
    required this.m15_7_45_Min,
    required this.m15_7_45_Max,
    required this.m15_45_7_Min,
    required this.m15_45_7_Max,
    required this.topN,
    required this.orderbookN,
    required this.topLevels,
  });

  static BotSettings defaults() => BotSettings(
        // Senin mantık: 4H en sıkı, 1H orta, 15m daha geniş, 45 daha geniş
        long4hMin: 1.0000, long4hMax: 1.0020,
        long1hMin: 1.0000, long1hMax: 1.0050,
        short4hMin: 1.0000, short4hMax: 1.0020,
        short1hMin: 1.0000, short1hMax: 1.0050,

        // 15m pencereleri (sen oynayacaksın)
        m15_7_25_Min: 1.0000, m15_7_25_Max: 1.0200, // EMA7/25 long tarafı
        m15_25_7_Min: 1.0000, m15_25_7_Max: 1.0200, // EMA25/7 short tarafı

        m15_7_45_Min: 1.0000, m15_7_45_Max: 1.0300, // EMA7/45
        m15_45_7_Min: 1.0000, m15_45_7_Max: 1.0300, // EMA45/7

        topN: 50,
        orderbookN: 50,
        topLevels: 3,
      );

  Map<String, dynamic> toMap() => {
        'long4hMin': long4hMin,
        'long4hMax': long4hMax,
        'long1hMin': long1hMin,
        'long1hMax': long1hMax,
        'short4hMin': short4hMin,
        'short4hMax': short4hMax,
        'short1hMin': short1hMin,
        'short1hMax': short1hMax,
        'm15_7_25_Min': m15_7_25_Min,
        'm15_7_25_Max': m15_7_25_Max,
        'm15_25_7_Min': m15_25_7_Min,
        'm15_25_7_Max': m15_25_7_Max,
        'm15_7_45_Min': m15_7_45_Min,
        'm15_7_45_Max': m15_7_45_Max,
        'm15_45_7_Min': m15_45_7_Min,
        'm15_45_7_Max': m15_45_7_Max,
        'topN': topN,
        'orderbookN': orderbookN,
        'topLevels': topLevels,
      };

  static BotSettings fromPrefs(SharedPreferences p) {
    final d = BotSettings.defaults();
    double gD(String k, double def) => p.getDouble(k) ?? def;
    int gI(String k, int def) => p.getInt(k) ?? def;

    return BotSettings(
      long4hMin: gD('long4hMin', d.long4hMin),
      long4hMax: gD('long4hMax', d.long4hMax),
      long1hMin: gD('long1hMin', d.long1hMin),
      long1hMax: gD('long1hMax', d.long1hMax),
      short4hMin: gD('short4hMin', d.short4hMin),
      short4hMax: gD('short4hMax', d.short4hMax),
      short1hMin: gD('short1hMin', d.short1hMin),
      short1hMax: gD('short1hMax', d.short1hMax),
      m15_7_25_Min: gD('m15_7_25_Min', d.m15_7_25_Min),
      m15_7_25_Max: gD('m15_7_25_Max', d.m15_7_25_Max),
      m15_25_7_Min: gD('m15_25_7_Min', d.m15_25_7_Min),
      m15_25_7_Max: gD('m15_25_7_Max', d.m15_25_7_Max),
      m15_7_45_Min: gD('m15_7_45_Min', d.m15_7_45_Min),
      m15_7_45_Max: gD('m15_7_45_Max', d.m15_7_45_Max),
      m15_45_7_Min: gD('m15_45_7_Min', d.m15_45_7_Min),
      m15_45_7_Max: gD('m15_45_7_Max', d.m15_45_7_Max),
      topN: gI('topN', d.topN),
      orderbookN: gI('orderbookN', d.orderbookN),
      topLevels: gI('topLevels', d.topLevels),
    );
  }

  static Future<void> saveToPrefs(BotSettings s) async {
    final p = await SharedPreferences.getInstance();
    Future<void> sD(String k, double v) async => p.setDouble(k, v);
    Future<void> sI(String k, int v) async => p.setInt(k, v);

    await sD('long4hMin', s.long4hMin);
    await sD('long4hMax', s.long4hMax);
    await sD('long1hMin', s.long1hMin);
    await sD('long1hMax', s.long1hMax);
    await sD('short4hMin', s.short4hMin);
    await sD('short4hMax', s.short4hMax);
    await sD('short1hMin', s.short1hMin);
    await sD('short1hMax', s.short1hMax);

    await sD('m15_7_25_Min', s.m15_7_25_Min);
    await sD('m15_7_25_Max', s.m15_7_25_Max);
    await sD('m15_25_7_Min', s.m15_25_7_Min);
    await sD('m15_25_7_Max', s.m15_25_7_Max);

    await sD('m15_7_45_Min', s.m15_7_45_Min);
    await sD('m15_7_45_Max', s.m15_7_45_Max);
    await sD('m15_45_7_Min', s.m15_45_7_Min);
    await sD('m15_45_7_Max', s.m15_45_7_Max);

    await sI('topN', s.topN);
    await sI('orderbookN', s.orderbookN);
    await sI('topLevels', s.topLevels);
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  BotSettings s = BotSettings.defaults();
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      s = BotSettings.fromPrefs(p);
      loaded = true;
    });
  }

  Future<void> _save() async {
    await BotSettings.saveToPrefs(s);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kaydedildi ✅')),
    );
  }

  Widget _ratioRow(String title, double minV, double maxV, void Function(double) setMin,
      void Function(double) setMax) {
    String fmt(double v) => v.toStringAsFixed(6);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: fmt(minV),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'MIN'),
                    onChanged: (v) => setMin(double.tryParse(v) ?? minV),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    initialValue: fmt(maxV),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'MAX'),
                    onChanged: (v) => setMax(double.tryParse(v) ?? maxV),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(children: [
                    const Expanded(child: Text('TOP N')),
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        initialValue: s.topN.toString(),
                        keyboardType: TextInputType.number,
                        onChanged: (v) => setState(() => s.topN = int.tryParse(v) ?? s.topN),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Expanded(child: Text('ORDERBOOK (kaç kademe)')),
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        initialValue: s.orderbookN.toString(),
                        keyboardType: TextInputType.number,
                        onChanged: (v) =>
                            setState(() => s.orderbookN = int.tryParse(v) ?? s.orderbookN),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Expanded(child: Text('Top Level sayısı (3)')),
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        initialValue: s.topLevels.toString(),
                        keyboardType: TextInputType.number,
                        onChanged: (v) =>
                            setState(() => s.topLevels = int.tryParse(v) ?? s.topLevels),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),

          _ratioRow('4H LONG gate (EMA7/25)',
              s.long4hMin, s.long4hMax,
              (v) => setState(() => s.long4hMin = v),
              (v) => setState(() => s.long4hMax = v),
          ),
          _ratioRow('4H SHORT gate (EMA25/7)',
              s.short4hMin, s.short4hMax,
              (v) => setState(() => s.short4hMin = v),
              (v) => setState(() => s.short4hMax = v),
          ),
          _ratioRow('1H LONG gate (EMA7/25)',
              s.long1hMin, s.long1hMax,
              (v) => setState(() => s.long1hMin = v),
              (v) => setState(() => s.long1hMax = v),
          ),
          _ratioRow('1H SHORT gate (EMA25/7)',
              s.short1hMin, s.short1hMax,
              (v) => setState(() => s.short1hMin = v),
              (v) => setState(() => s.short1hMax = v),
          ),

          _ratioRow('15m LONG radar (EMA7/25)',
              s.m15_7_25_Min, s.m15_7_25_Max,
              (v) => setState(() => s.m15_7_25_Min = v),
              (v) => setState(() => s.m15_7_25_Max = v),
          ),
          _ratioRow('15m SHORT radar (EMA25/7)',
              s.m15_25_7_Min, s.m15_25_7_Max,
              (v) => setState(() => s.m15_25_7_Min = v),
              (v) => setState(() => s.m15_25_7_Max = v),
          ),

          _ratioRow('15m ekstra (EMA7/45)',
              s.m15_7_45_Min, s.m15_7_45_Max,
              (v) => setState(() => s.m15_7_45_Min = v),
              (v) => setState(() => s.m15_7_45_Max = v),
          ),
          _ratioRow('15m ekstra (EMA45/7)',
              s.m15_45_7_Min, s.m15_45_7_Max,
              (v) => setState(() => s.m15_45_7_Min = v),
              (v) => setState(() => s.m15_45_7_Max = v),
          ),

          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Kaydet'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () async {
              final d = BotSettings.defaults();
              setState(() => s = d);
              await BotSettings.saveToPrefs(d);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Varsayılanlara döndü')),
              );
            },
            child: const Text('Varsayılanlara dön'),
          ),
        ],
      ),
    );
  }
}

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final List<String> logs = [];
  Timer? t;

  @override
  void initState() {
    super.initState();
    // Şimdilik demo: sonuç akışı gibi gösteriyoruz.
    // Sonraki adımda bunu senin python tarayıcıdan gelecek data ile besleyeceğiz.
    t = Timer.periodic(const Duration(seconds: 3), (_) {
      setState(() {
        final now = DateTime.now().toIso8601String().substring(11, 19);
        logs.insert(0, "[$now] Bekleniyor… (scanner bağlanınca burası dolacak)");
        if (logs.length > 200) logs.removeLast();
      });
    });
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sonuçlar'),
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const PoleApp());
}

class PoleApp extends StatelessWidget {
  const PoleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polepositionsignal',
      theme: ThemeData(useMaterial3: true),
      home: const HomeShell(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const SettingsPage(),
      const ResultsPage(),
    ];
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.tune), label: 'Ayarlar'),
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Sonuçlar'),
        ],
      ),
    );
  }
}

class BotSettings {
  double long4hMin;
  double long4hMax;
  double long1hMin;
  double long1hMax;

  double short4hMin;
  double short4hMax;
  double short1hMin;
  double short1hMax;

  double m15_7_25_Min;
  double m15_7_25_Max;

  double m15_25_7_Min;
  double m15_25_7_Max;

  double m15_7_45_Min;
  double m15_7_45_Max;

  double m15_45_7_Min;
  double m15_45_7_Max;

  int topN;
  int orderbookN;
  int topLevels;

  BotSettings({
    required this.long4hMin,
    required this.long4hMax,
    required this.long1hMin,
    required this.long1hMax,
    required this.short4hMin,
    required this.short4hMax,
    required this.short1hMin,
    required this.short1hMax,
    required this.m15_7_25_Min,
    required this.m15_7_25_Max,
    required this.m15_25_7_Min,
    required this.m15_25_7_Max,
    required this.m15_7_45_Min,
    required this.m15_7_45_Max,
    required this.m15_45_7_Min,
    required this.m15_45_7_Max,
    required this.topN,
    required this.orderbookN,
    required this.topLevels,
  });

  static BotSettings defaults() => BotSettings(
        // Senin mantık: 4H en sıkı, 1H orta, 15m daha geniş, 45 daha geniş
        long4hMin: 1.0000, long4hMax: 1.0020,
        long1hMin: 1.0000, long1hMax: 1.0050,
        short4hMin: 1.0000, short4hMax: 1.0020,
        short1hMin: 1.0000, short1hMax: 1.0050,

        // 15m pencereleri (sen oynayacaksın)
        m15_7_25_Min: 1.0000, m15_7_25_Max: 1.0200, // EMA7/25 long tarafı
        m15_25_7_Min: 1.0000, m15_25_7_Max: 1.0200, // EMA25/7 short tarafı

        m15_7_45_Min: 1.0000, m15_7_45_Max: 1.0300, // EMA7/45
        m15_45_7_Min: 1.0000, m15_45_7_Max: 1.0300, // EMA45/7

        topN: 50,
        orderbookN: 50,
        topLevels: 3,
      );

  Map<String, dynamic> toMap() => {
        'long4hMin': long4hMin,
        'long4hMax': long4hMax,
        'long1hMin': long1hMin,
        'long1hMax': long1hMax,
        'short4hMin': short4hMin,
        'short4hMax': short4hMax,
        'short1hMin': short1hMin,
        'short1hMax': short1hMax,
        'm15_7_25_Min': m15_7_25_Min,
        'm15_7_25_Max': m15_7_25_Max,
        'm15_25_7_Min': m15_25_7_Min,
        'm15_25_7_Max': m15_25_7_Max,
        'm15_7_45_Min': m15_7_45_Min,
        'm15_7_45_Max': m15_7_45_Max,
        'm15_45_7_Min': m15_45_7_Min,
        'm15_45_7_Max': m15_45_7_Max,
        'topN': topN,
        'orderbookN': orderbookN,
        'topLevels': topLevels,
      };

  static BotSettings fromPrefs(SharedPreferences p) {
    final d = BotSettings.defaults();
    double gD(String k, double def) => p.getDouble(k) ?? def;
    int gI(String k, int def) => p.getInt(k) ?? def;

    return BotSettings(
      long4hMin: gD('long4hMin', d.long4hMin),
      long4hMax: gD('long4hMax', d.long4hMax),
      long1hMin: gD('long1hMin', d.long1hMin),
      long1hMax: gD('long1hMax', d.long1hMax),
      short4hMin: gD('short4hMin', d.short4hMin),
      short4hMax: gD('short4hMax', d.short4hMax),
      short1hMin: gD('short1hMin', d.short1hMin),
      short1hMax: gD('short1hMax', d.short1hMax),
      m15_7_25_Min: gD('m15_7_25_Min', d.m15_7_25_Min),
      m15_7_25_Max: gD('m15_7_25_Max', d.m15_7_25_Max),
      m15_25_7_Min: gD('m15_25_7_Min', d.m15_25_7_Min),
      m15_25_7_Max: gD('m15_25_7_Max', d.m15_25_7_Max),
      m15_7_45_Min: gD('m15_7_45_Min', d.m15_7_45_Min),
      m15_7_45_Max: gD('m15_7_45_Max', d.m15_7_45_Max),
      m15_45_7_Min: gD('m15_45_7_Min', d.m15_45_7_Min),
      m15_45_7_Max: gD('m15_45_7_Max', d.m15_45_7_Max),
      topN: gI('topN', d.topN),
      orderbookN: gI('orderbookN', d.orderbookN),
      topLevels: gI('topLevels', d.topLevels),
    );
  }

  static Future<void> saveToPrefs(BotSettings s) async {
    final p = await SharedPreferences.getInstance();
    Future<void> sD(String k, double v) async => p.setDouble(k, v);
    Future<void> sI(String k, int v) async => p.setInt(k, v);

    await sD('long4hMin', s.long4hMin);
    await sD('long4hMax', s.long4hMax);
    await sD('long1hMin', s.long1hMin);
    await sD('long1hMax', s.long1hMax);
    await sD('short4hMin', s.short4hMin);
    await sD('short4hMax', s.short4hMax);
    await sD('short1hMin', s.short1hMin);
    await sD('short1hMax', s.short1hMax);

    await sD('m15_7_25_Min', s.m15_7_25_Min);
    await sD('m15_7_25_Max', s.m15_7_25_Max);
    await sD('m15_25_7_Min', s.m15_25_7_Min);
    await sD('m15_25_7_Max', s.m15_25_7_Max);

    await sD('m15_7_45_Min', s.m15_7_45_Min);
    await sD('m15_7_45_Max', s.m15_7_45_Max);
    await sD('m15_45_7_Min', s.m15_45_7_Min);
    await sD('m15_45_7_Max', s.m15_45_7_Max);

    await sI('topN', s.topN);
    await sI('orderbookN', s.orderbookN);
    await sI('topLevels', s.topLevels);
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  BotSettings s = BotSettings.defaults();
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      s = BotSettings.fromPrefs(p);
      loaded = true;
    });
  }

  Future<void> _save() async {
    await BotSettings.saveToPrefs(s);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kaydedildi ✅')),
    );
  }

  Widget _ratioRow(String title, double minV, double maxV, void Function(double) setMin,
      void Function(double) setMax) {
    String fmt(double v) => v.toStringAsFixed(6);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: fmt(minV),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'MIN'),
                    onChanged: (v) => setMin(double.tryParse(v) ?? minV),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    initialValue: fmt(maxV),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'MAX'),
                    onChanged: (v) => setMax(double.tryParse(v) ?? maxV),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(children: [
                    const Expanded(child: Text('TOP N')),
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        initialValue: s.topN.toString(),
                        keyboardType: TextInputType.number,
                        onChanged: (v) => setState(() => s.topN = int.tryParse(v) ?? s.topN),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Expanded(child: Text('ORDERBOOK (kaç kademe)')),
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        initialValue: s.orderbookN.toString(),
                        keyboardType: TextInputType.number,
                        onChanged: (v) =>
                            setState(() => s.orderbookN = int.tryParse(v) ?? s.orderbookN),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Expanded(child: Text('Top Level sayısı (3)')),
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        initialValue: s.topLevels.toString(),
                        keyboardType: TextInputType.number,
                        onChanged: (v) =>
                            setState(() => s.topLevels = int.tryParse(v) ?? s.topLevels),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),

          _ratioRow('4H LONG gate (EMA7/25)',
              s.long4hMin, s.long4hMax,
              (v) => setState(() => s.long4hMin = v),
              (v) => setState(() => s.long4hMax = v),
          ),
          _ratioRow('4H SHORT gate (EMA25/7)',
              s.short4hMin, s.short4hMax,
              (v) => setState(() => s.short4hMin = v),
              (v) => setState(() => s.short4hMax = v),
          ),
          _ratioRow('1H LONG gate (EMA7/25)',
              s.long1hMin, s.long1hMax,
              (v) => setState(() => s.long1hMin = v),
              (v) => setState(() => s.long1hMax = v),
          ),
          _ratioRow('1H SHORT gate (EMA25/7)',
              s.short1hMin, s.short1hMax,
              (v) => setState(() => s.short1hMin = v),
              (v) => setState(() => s.short1hMax = v),
          ),

          _ratioRow('15m LONG radar (EMA7/25)',
              s.m15_7_25_Min, s.m15_7_25_Max,
              (v) => setState(() => s.m15_7_25_Min = v),
              (v) => setState(() => s.m15_7_25_Max = v),
          ),
          _ratioRow('15m SHORT radar (EMA25/7)',
              s.m15_25_7_Min, s.m15_25_7_Max,
              (v) => setState(() => s.m15_25_7_Min = v),
              (v) => setState(() => s.m15_25_7_Max = v),
          ),

          _ratioRow('15m ekstra (EMA7/45)',
              s.m15_7_45_Min, s.m15_7_45_Max,
              (v) => setState(() => s.m15_7_45_Min = v),
              (v) => setState(() => s.m15_7_45_Max = v),
          ),
          _ratioRow('15m ekstra (EMA45/7)',
              s.m15_45_7_Min, s.m15_45_7_Max,
              (v) => setState(() => s.m15_45_7_Min = v),
              (v) => setState(() => s.m15_45_7_Max = v),
          ),

          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Kaydet'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () async {
              final d = BotSettings.defaults();
              setState(() => s = d);
              await BotSettings.saveToPrefs(d);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Varsayılanlara döndü')),
              );
            },
            child: const Text('Varsayılanlara dön'),
          ),
        ],
      ),
    );
  }
}

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final List<String> logs = [];
  Timer? t;

  @override
  void initState() {
    super.initState();
    // Şimdilik demo: sonuç akışı gibi gösteriyoruz.
    // Sonraki adımda bunu senin python tarayıcıdan gelecek data ile besleyeceğiz.
    t = Timer.periodic(const Duration(seconds: 3), (_) {
      setState(() {
        final now = DateTime.now().toIso8601String().substring(11, 19);
        logs.insert(0, "[$now] Bekleniyor… (scanner bağlanınca burası dolacak)");
        if (logs.length > 200) logs.removeLast();
      });
    });
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sonuçlar'),
        actions: [
          IconButton(
            onPressed: () => setState(() => logs.clear()),
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Temizle',
          )
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: logs.length,
        separatorBuilder: (_, __) => const Divider(height: 8),
        itemBuilder: (context, i) => Text(logs[i]),
      ),
    );
  }
}        actions: [
          IconButton(
            onPressed: () => setState(() => logs.clear()),
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Temizle',
          )
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: logs.length,
        separatorBuilder: (_, __) => const Divider(height: 8),
        itemBuilder: (context, i) => Text(logs[i]),
      ),
    );
  }
}
