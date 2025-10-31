// lib/ui/pages/settings_page.dart
import 'package:flutter/material.dart';
import '../../core/prefs/app_preferences.dart';

class SettingsPage extends StatefulWidget {
  final AppPreferences prefs;
  const SettingsPage({super.key, required this.prefs});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _theme = 'system';
  String _rating = 'g';
  bool _autoplay = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final theme = await widget.prefs.getTheme();
    final rating = await widget.prefs.getRating();
    final autoplay = await widget.prefs.getAutoplay();
    
    setState(() {
      _theme = theme;
      _rating = rating;
      _autoplay = autoplay;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _theme,
                  decoration: const InputDecoration(labelText: 'Tema'),
                  items: const [
                    DropdownMenuItem(value: 'light', child: Text('Claro')),
                    DropdownMenuItem(value: 'dark', child: Text('Escuro')),
                    DropdownMenuItem(value: 'system', child: Text('Sistema')),
                  ],
                  onChanged: (v) async {
                    if (v != null) {
                      setState(() => _theme = v);
                      await widget.prefs.setTheme(v);
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _rating,
                  decoration: const InputDecoration(labelText: 'Classificação'),
                  items: const [
                    DropdownMenuItem(value: 'g', child: Text('G')),
                    DropdownMenuItem(value: 'pg', child: Text('PG')),
                    DropdownMenuItem(value: 'pg-13', child: Text('PG-13')),
                    DropdownMenuItem(value: 'r', child: Text('R')),
                  ],
                  onChanged: (v) async {
                    if (v != null) {
                      setState(() => _rating = v);
                      await widget.prefs.setRating(v);
                    }
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Autoplay de GIFs'),
                  value: _autoplay,
                  onChanged: (v) async {
                    setState(() => _autoplay = v);
                    await widget.prefs.setAutoplay(v);
                  },
                ),
                const Divider(height: 32),
                const Text(
                  '💾 Dados salvos no MySQL',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
    );
  }
}