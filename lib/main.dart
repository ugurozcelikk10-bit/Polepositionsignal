import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const PolePositionSignalApp());
}

class PolePositionSignalApp extends StatelessWidget {
  const PolePositionSignalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polepositionsignal',
      theme: ThemeData.dark(useMaterial3: true),
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

  final settings = ScanSettings();

  @override
  Widget build(BuildContext context) {
    final pages = [
      SettingsPage(settings: settings),
      ResultsPage(settings: settings),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(index == 0 ? "Ayarlar" : "Sonuçlar"),
      ),
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.tune), label: "Ayarlar"),
          NavigationDestination(icon: Icon(Icons.radar), label: "Sonuçlar"),
        ],
      ),
    );
  }
}

class ScanSettings {
  // Daha sonra VPS/PC’de çalışan python scanner’a bağlanacağımız endpoint
  String apiBaseUrl = "http://YOUR_SERVER_IP:8000";

  // Ratio pencereleri — senin mantık:
  // 4H: 1.0000 - 1.002
  double long4hMin = 1.0000, long4hMax = 1.0020;
  double short4hMin = 1.0000, short4hMax = 1.0020;

  // 1H: 1.0000 - 1.005
  double long1hMin = 1.0000, long1hMax = 1.0050;
  double short1hMin = 1.0000, short1hMax = 1.0050;

  // 15m (EMA7/25 & EMA25/7): 1.0000 - 1.02
  double long15m25Min = 1.0000, long15m25Max = 1.0200;
  double short15m25Min = 1.0000, short15m25Max = 1.0200;

  // 15m (EMA7/45 & EMA45/7): 1.0000 - 1.03
  double long15m45Min = 1.0000, long15m45Max = 1.0300;
  double short15m45Min = 1.0000, short15m45Max = 1.0300;

  int topN = 50;
  int orderbookDepth = 200;
}

class SettingsPage extends StatefulWidget {
  final ScanSettings settings;
  const SettingsPage({super.key, required this.settings});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final TextEditingController apiCtrl;
  late final TextEditingController topNCtrl;
  late final TextEditingController depthCtrl;

  @override
  void initState() {
    super.initState();
    apiCtrl = TextEditingController(text: widget.settings.apiBaseUrl);
    topNCtrl = TextEditingController(text: widget.settings.topN.toString());
    depthCtrl = TextEditingController(text: widget.settings.orderbookDepth.toString());
  }

  @override
  void dispose() {
    apiCtrl.dispose();
    topNCtrl.dispose();
    depthCtrl.dispose();
    super.dispose();
  }

  void save() {
    setState(() {
      widget.settings.apiBaseUrl = apiCtrl.text.trim();
      widget.settings.topN = int.tryParse(topNCtrl.text.trim()) ?? widget.settings.topN;
      widget.settings.orderbookDepth =
          int.tryParse(depthCtrl.text.trim()) ?? widget.settings.orderbookDepth;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Kaydedildi ✅")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.settings;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Polepositionsignal • Radar Ayarları",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),

        TextField(
          controller: apiCtrl,
          decoration: const InputDecoration(
            labelText: "API Base URL (scanner sunucusu)",
            hintText: "http://1.2.3.4:8000",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: topNCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "TOP_N",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: depthCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Orderbook depth (örn 200)",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 10),

        const Text("Ratio Pencereleri (min/max)", style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),

        RatioCard(
          title: "4H Gate",
          items: [
            RatioItem("LONG EMA7/25", s.long4hMin, s.long4hMax, (a, b) {
              s.long4hMin = a; s.long4hMax = b;
            }),
            RatioItem("SHORT EMA25/7", s.short4hMin, s.short4hMax, (a, b) {
              s.short4hMin = a; s.short4hMax = b;
            }),
          ],
          onChanged: () => setState(() {}),
        ),

        RatioCard(
          title: "1H Gate",
          items: [
            RatioItem("LONG EMA7/25", s.long1hMin, s.long1hMax, (a, b) {
              s.long1hMin = a; s.long1hMax = b;
            }),
            RatioItem("SHORT EMA25/7", s.short1hMin, s.short1hMax, (a, b) {
              s.short1hMin = a; s.short1hMax = b;
            }),
          ],
          onChanged: () => setState(() {}),
        ),

        RatioCard(
          title: "15m Entry (EMA25 ve EMA45)",
          items: [
            RatioItem("LONG EMA7/25", s.long15m25Min, s.long15m25Max, (a, b) {
              s.long15m25Min = a; s.long15m25Max = b;
            }),
            RatioItem("SHORT EMA25/7", s.short15m25Min, s.short15m25Max, (a, b) {
              s.short15m25Min = a; s.short15m25Max = b;
            }),
            RatioItem("LONG EMA7/45", s.long15m45Min, s.long15m45Max, (a, b) {
              s.long15m45Min = a; s.long15m45Max = b;
            }),
            RatioItem("SHORT EMA45/7", s.short15m45Min, s.short15m45Max, (a, b) {
              s.short15m45Min = a; s.short15m45Max = b;
            }),
          ],
          onChanged: () => setState(() {}),
        ),

        const SizedBox(height: 14),
        FilledButton.icon(
          onPressed: save,
          icon: const Icon(Icons.save),
          label: const Text("Kaydet"),
        ),
        const SizedBox(height: 10),
        const Text(
          "Not: Şimdilik app sadece ayar tutar ve sonuç endpoint’inden veri çeker.\n"
          "Scanner’ı VPS/PC’de çalıştırınca burada göreceğiz.",
          style: TextStyle(color: Colors.white70),
        )
      ],
    );
  }
}

class RatioItem {
  final String label;
  double min;
  double max;
  final void Function(double min, double max) set;
  RatioItem(this.label, this.min, this.max, this.set);
}

class RatioCard extends StatelessWidget {
  final String title;
  final List<RatioItem> items;
  final VoidCallback onChanged;

  const RatioCard({super.key, required this.title, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            ...items.map((it) => _RatioRow(item: it, onChanged: onChanged)),
          ],
        ),
      ),
    );
  }
}

class _RatioRow extends StatelessWidget {
  final RatioItem item;
  final VoidCallback onChanged;
  const _RatioRow({required this.item, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final minCtrl = TextEditingController(text: item.min.toStringAsFixed(6));
    final maxCtrl = TextEditingController(text: item.max.toStringAsFixed(6));

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(item.label)),
          const SizedBox(width: 8),
          SizedBox(
            width: 110,
            child: TextField(
              controller: minCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: "min"),
              onSubmitted: (v) {
                final nv = double.tryParse(v.trim());
                if (nv != null) { item.set(nv, item.max); onChanged(); }
              },
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 110,
            child: TextField(
              controller: maxCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: "max"),
              onSubmitted: (v) {
                final nv = double.tryParse(v.trim());
                if (nv != null) { item.set(item.min, nv); onChanged(); }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ResultsPage extends StatefulWidget {
  final ScanSettings settings;
  const ResultsPage({super.key, required this.settings});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  bool loading = false;
  String? error;
  List<Map<String, dynamic>> results = [];

  Future<void> fetchResults() async {
    setState(() { loading = true; error = null; });

    try {
      final url = Uri.parse("${widget.settings.apiBaseUrl}/results");
      final res = await http.get(url).timeout(const Duration(seconds: 8));

      if (res.statusCode != 200) {
        throw Exception("HTTP ${res.statusCode}");
      }

      final decoded = jsonDecode(res.body);
      if (decoded is List) {
        results = decoded.cast<Map<String, dynamic>>();
      } else {
        throw Exception("JSON formatı List değil");
      }
    } catch (e) {
      error = "Bağlantı yok / endpoint yok. Demo gösteriyorum.\n$e";
      results = demoResults();
    } finally {
      setState(() { loading = false; });
    }
  }

  List<Map<String, dynamic>> demoResults() {
    return [
      {
        "side": "SHORT",
        "symbol": "MOG-USDT-SWAP",
        "tf": "15m",
        "ratio_4h": 1.0185,
        "ratio_1h": 1.0151,
        "ratio_15m_25": 1.0050,
        "ratio_15m_45": 1.0103,
        "j": 24.3,
        "k": 25.0,
        "rsi_conf": "38.3→36.0 ↓",
        "rsi_live": "36.0→36.0 →",
        "support": "0.00000016 (x3.3)",
        "resistance": "0.00000017 (x8.1)"
      },
      {
        "side": "LONG",
        "symbol": "YGG-USDT-SWAP",
        "tf": "15m",
        "ratio_4h": 1.0012,
        "ratio_1h": 1.0021,
        "ratio_15m_25": 1.0099,
        "ratio_15m_45": 1.0122,
        "j": 108.8,
        "k": 82.2,
        "rsi_conf": "56.0→58.6 ↑",
        "rsi_live": "58.6→60.4 ↑",
        "support": "0.04610 (x2.6)",
        "resistance": "0.04720 (x3.8)"
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    // Açılışta demo gösterelim
    results = demoResults();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Endpoint: ${widget.settings.apiBaseUrl}",
                  style: const TextStyle(color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: loading ? null : fetchResults,
                icon: loading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.refresh),
                label: const Text("Çek"),
              ),
            ],
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(error!, style: const TextStyle(color: Colors.orangeAccent)),
          ),
        const SizedBox(height: 6),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: results.length,
            itemBuilder: (ctx, i) {
              final r = results[i];
              final side = (r["side"] ?? "—").toString();
              final symbol = (r["symbol"] ?? "—").toString();
              final tf = (r["tf"] ?? "—").toString();
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$side • $symbol • $tf", style: const TextStyle(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 6),
                      Text("4H ratio: ${r["ratio_4h"]}   | 1H ratio: ${r["ratio_1h"]}"),
                      Text("15m EMA25: ${r["ratio_15m_25"]}   | 15m EMA45: ${r["ratio_15m_45"]}"),
                      const SizedBox(height: 6),
                      Text("KDJ J:${r["j"]}  K:${r["k"]}"),
                      Text("RSI CONF: ${r["rsi_conf"]}  | LIVE: ${r["rsi_live"]}"),
                      const SizedBox(height: 6),
                      Text("🧱 Destek: ${r["support"]}"),
                      Text("🧱 Direnç: ${r["resistance"]}"),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
