import 'package:flutter/material.dart';

import '../services/local_storage_service.dart';
import '../widgets/app_drawer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const _beaches = [
    'Las Canteras',
    'Maspalomas',
    'El Médano',
    'Papagayo',
  ];

  final _messageController = TextEditingController();
  final _localStorage = LocalStorageService();
  String _selectedBeach = _beaches.first;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    try {
      final savedBeach = await _localStorage.getSelectedBeach();
      final savedMessage = await _localStorage.getMessage();
      if (!mounted) return;

      setState(() {
        if (savedBeach != null && _beaches.contains(savedBeach)) {
          _selectedBeach = savedBeach;
        }
        _messageController.text = savedMessage ?? '';
        _isLoading = false;
      });
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showMessage('No se pudieron cargar los ajustes: $error', isError: true);
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);
    try {
      await _localStorage.saveSettings(
        selectedBeach: _selectedBeach,
        message: _messageController.text.trim(),
      );
      if (!mounted) return;
      _showMessage('Ajustes guardados correctamente');
    } on Object catch (error) {
      if (!mounted) return;
      _showMessage('No se pudieron guardar los ajustes: $error', isError: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red.shade700 : null,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F7),
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu),
            tooltip: 'Abrir menú',
          ),
        ),
        title: const Text('Ajustes'),
        backgroundColor: const Color(0xFF2A9D8F),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Personaliza tu experiencia',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFF2A9D8F),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Estos datos se conservarán cuando vuelvas a abrir la aplicación.',
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  initialValue: _selectedBeach,
                  decoration: const InputDecoration(
                    labelText: 'Playa favorita',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.beach_access),
                  ),
                  items: _beaches
                      .map(
                        (beach) => DropdownMenuItem(
                          value: beach,
                          child: Text(beach),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _selectedBeach = value);
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _messageController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Tu mensaje',
                    hintText: 'Escribe algo para recordar...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.edit_note),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _isSaving ? null : _saveSettings,
                  icon: _isSaving
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(_isSaving ? 'Guardando...' : 'Guardar ajustes'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFC9502B),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ],
            ),
    );
  }
}
