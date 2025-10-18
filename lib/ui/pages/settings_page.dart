import 'package:flutter/material.dart';
import '../../core/prefs/app_preferences.dart';

class SettingsPage extends StatefulWidget {
  final AppPreferences prefs;
  const SettingsPage({super.key, required this.prefs});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String _theme;
  late String _rating;
  late bool _autoplay;

  @override
  void initState() {
    super.initState();
    _theme = widget.prefs.getTheme();
    _rating = widget.prefs.getRating();
    _autoplay = widget.prefs.getAutoplay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            value: _theme,
            decoration: const InputDecoration(labelText: 'Tema'),
            items: const [
              DropdownMenuItem(value: 'light', child: Text('Claro')),
              DropdownMenuItem(value: 'dark', child: Text('Escuro')),
              DropdownMenuItem(value: 'system', child: Text('Sistema')),
            ],
            onChanged: (v) {
              if (v != null) {
                setState(() => _theme = v);
                widget.prefs.setTheme(v);
              }
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _rating,
            decoration: const InputDecoration(labelText: 'Classificação'),
            items: const [
              DropdownMenuItem(value: 'g', child: Text('G')),
              DropdownMenuItem(value: 'pg', child: Text('PG')),
              DropdownMenuItem(value: 'pg-13', child: Text('PG-13')),
              DropdownMenuItem(value: 'r', child: Text('R')),
            ],
            onChanged: (v) {
              if (v != null) {
                setState(() => _rating = v);
                widget.prefs.setRating(v);
              }
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Autoplay de GIFs'),
            value: _autoplay,
            onChanged: (v) {
              setState(() => _autoplay = v);
              widget.prefs.setAutoplay(v);
            },
          ),
        ],
      ),
    );
  }
}
