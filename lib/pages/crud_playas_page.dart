import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/app_drawer.dart';

/// Categorías disponibles para clasificar cada playa.
const beachCategories = <String>[
  'Playa urbana',
  'Playa natural',
  'Playa familiar',
  'Playa deportiva',
];

/// Modelo inmutable que representa una playa creada desde el formulario.
class Beach {
  const Beach({
    required this.name,
    required this.description,
    required this.category,
    required this.imageUrl,
    this.imageBytes,
    required this.isClean,
    required this.approximatePeople,
  });

  final String name;
  final String description;
  final String category;
  final String imageUrl;
  final Uint8List? imageBytes;
  final bool isClean;
  final int approximatePeople;
}

class CrudPlayasPage extends StatefulWidget {
  const CrudPlayasPage({super.key});

  @override
  State<CrudPlayasPage> createState() => _CrudPlayasPageState();
}

class _CrudPlayasPageState extends State<CrudPlayasPage> {
  static const _teal = Color(0xFF2A9D8F);
  static const _orange = Color(0xFFC9502B);
  static const _surface = Color(0xFFF4F8F7);

  // La lista vive en el estado para que setState actualice la interfaz.
  final List<Beach> _beaches = [
    const Beach(
      name: 'Playa de Las Canteras',
      description: 'Una playa urbana para pasear y desconectar.',
      category: 'Playa urbana',
      imageUrl: '',
      isClean: true,
      approximatePeople: 120,
    ),
    const Beach(
      name: 'Playa de Maspalomas',
      description: 'Dunas, arena dorada y vistas al océano.',
      category: 'Playa natural',
      imageUrl: '',
      isClean: true,
      approximatePeople: 75,
    ),
  ];

  String _fallbackImageForCategory(String category) => switch (category) {
    'Playa urbana' || 'Playa familiar' => 'assets/images/home_bg.jpg',
    _ => 'assets/images/Sandi_proto.jpg',
  };

  Future<void> _showAddBeachDialog() async {
    // showDialog devuelve la playa que el formulario pasa a Navigator.pop.
    final newBeach = await showDialog<Beach>(
      context: context,
      builder: (context) => const _AddBeachDialog(),
    );

    if (!mounted || newBeach == null) {
      return;
    }

    setState(() => _beaches.add(newBeach));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('«${newBeach.name}» añadida a la lista')),
    );
  }

  void _deleteBeach(int index) {
    final deletedBeach = _beaches[index];
    setState(() => _beaches.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('«${deletedBeach.name}» eliminada')),
    );
  }

  Future<void> _confirmDeleteAll() async {
    if (_beaches.isEmpty) {
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => const _DeleteAllDialog(),
    );

    if (!mounted || shouldDelete != true) {
      return;
    }

    setState(() => _beaches.clear());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Se han borrado todas las playas')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu),
            tooltip: 'Abrir menú',
          ),
        ),
        title: const Text('Mis playas'),
        backgroundColor: _teal,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Card(
                elevation: 3,
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_teal, Color(0xFF237A70)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.beach_access,
                              color: Colors.white,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Playas guardadas',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Badge(
                              label: Text('${_beaches.length}'),
                              backgroundColor: _orange,
                              textColor: Colors.white,
                              child: const Icon(
                                Icons.location_on_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Organiza tus playas favoritas y consulta su estado.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.88),
                          ),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: _beaches.isEmpty ? null : _confirmDeleteAll,
                          icon: const Icon(Icons.delete_sweep_outlined),
                          label: const Text('Borrar toda la lista'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _beaches.isEmpty
                  ? const _EmptyBeachesMessage()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                      itemCount: _beaches.length,
                      itemBuilder: (context, index) {
                        final beach = _beaches[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          clipBehavior: Clip.antiAlias,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: beach.imageBytes != null
                                  ? Image.memory(
                                      beach.imageBytes!,
                                      width: 68,
                                      height: 68,
                                      fit: BoxFit.cover,
                                    )
                                  : beach.imageUrl.isEmpty
                                  ? Image.asset(
                                      _fallbackImageForCategory(beach.category),
                                      width: 68,
                                      height: 68,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      beach.imageUrl,
                                      width: 68,
                                      height: 68,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Image.asset(
                                        _fallbackImageForCategory(
                                          beach.category,
                                        ),
                                        width: 68,
                                        height: 68,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            title: Text(
                              beach.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                '${beach.description}\n'
                                'Categoría: ${beach.category} · '
                                '${beach.isClean ? 'Limpia' : 'Pendiente de limpieza'}\n'
                                'Aforo aproximado: ${beach.approximatePeople} personas',
                              ),
                            ),
                            isThreeLine: true,
                            trailing: IconButton(
                              onPressed: () => _deleteBeach(index),
                              tooltip: 'Borrar ${beach.name}',
                              color: _orange,
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddBeachDialog,
        backgroundColor: _orange,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Añadir playa'),
      ),
    );
  }
}

class _EmptyBeachesMessage extends StatelessWidget {
  const _EmptyBeachesMessage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            const Text(
              'No hay playas todavía.\nPulsa «Añadir playa» para crear una.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddBeachDialog extends StatefulWidget {
  const _AddBeachDialog();

  @override
  State<_AddBeachDialog> createState() => _AddBeachDialogState();
}

class _AddBeachDialogState extends State<_AddBeachDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _peopleController = TextEditingController(text: '0');
  final _picker = ImagePicker();
  String _category = beachCategories.first;
  bool _isClean = true;
  Uint8List? _imageBytes;
  String? _selectedImageName;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _peopleController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      Beach(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _category,
        imageUrl: _imageUrlController.text.trim(),
        imageBytes: _imageBytes,
        isClean: _isClean,
        approximatePeople: int.parse(_peopleController.text.trim()),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
        requestFullMetadata: false,
      );

      if (pickedFile == null) {
        return;
      }

      final bytes = await pickedFile.readAsBytes();
      if (bytes.length > 10 * 1024 * 1024) {
        _showImageError('La imagen no puede superar los 10 MB.');
        return;
      }

      if (!_isSupportedRasterImage(bytes)) {
        _showImageError('Solo se aceptan imágenes JPEG, PNG o WebP.');
        return;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _imageBytes = bytes;
        _selectedImageName = pickedFile.name;
        _imageUrlController.clear();
      });
    } on PlatformException {
      _showImageError('No se pudo abrir el selector de imágenes.');
    } on Exception {
      _showImageError('No se pudo leer la imagen seleccionada.');
    }
  }

  bool _isSupportedRasterImage(Uint8List bytes) {
    final isJpeg = bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF;
    final isPng = bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47 &&
        bytes[4] == 0x0D &&
        bytes[5] == 0x0A &&
        bytes[6] == 0x1A &&
        bytes[7] == 0x0A;
    final isWebp = bytes.length >= 12 &&
        String.fromCharCodes(bytes.sublist(0, 4)) == 'RIFF' &&
        String.fromCharCodes(bytes.sublist(8, 12)) == 'WEBP';
    return isJpeg || isPng || isWebp;
  }

  void _showImageError(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Añadir playa'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Escribe un nombre'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                textCapitalization: TextCapitalization.sentences,
                maxLength: 120,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Descripción breve',
                  prefixIcon: Icon(Icons.notes),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Escribe una descripción'
                    : null,
              ),
              const SizedBox(height: 4),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: beachCategories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _category = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageUrlController,
                keyboardType: TextInputType.url,
                onChanged: (value) {
                  if (value.isNotEmpty && _imageBytes != null) {
                    setState(() {
                      _imageBytes = null;
                      _selectedImageName = null;
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'URL de imagen (opcional)',
                  hintText: 'https://ejemplo.com/playa.jpg',
                  prefixIcon: Icon(Icons.image_outlined),
                ),
                validator: (value) {
                  final url = value?.trim() ?? '';
                  if (url.isNotEmpty &&
                      !url.startsWith('https://')) {
                    return 'La URL debe comenzar por https://';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.upload_file),
                label: Text(
                  _selectedImageName == null
                      ? 'Seleccionar imagen del dispositivo'
                      : 'Imagen seleccionada',
                ),
              ),
              if (_selectedImageName != null) ...[
                const SizedBox(height: 6),
                Text(
                  'Archivo validado: $_selectedImageName',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 12),
              TextFormField(
                controller: _peopleController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Personas aproximadas',
                  prefixIcon: Icon(Icons.people_outline),
                ),
                validator: (value) {
                  final people = int.tryParse(value?.trim() ?? '');
                  if (people == null || people < 0) {
                    return 'Indica un número igual o mayor que 0';
                  }
                  return null;
                },
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('La playa está limpia'),
                value: _isClean,
                onChanged: (value) {
                  setState(() => _isClean = value ?? false);
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.check),
          label: const Text('Guardar'),
        ),
      ],
    );
  }
}

class _DeleteAllDialog extends StatefulWidget {
  const _DeleteAllDialog();

  @override
  State<_DeleteAllDialog> createState() => _DeleteAllDialogState();
}

class _DeleteAllDialogState extends State<_DeleteAllDialog> {
  static const _waitDuration = 10;
  static const _orange = Color(0xFFC9502B);
  Timer? _timer;
  int _secondsRemaining = _waitDuration;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsRemaining <= 1) {
        _timer?.cancel();
        if (mounted) {
          setState(() => _secondsRemaining = 0);
        }
      } else if (mounted) {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canDelete = _secondsRemaining == 0;

    return AlertDialog(
      icon: const Icon(Icons.warning_amber_rounded, color: _orange, size: 42),
      title: const Text('¿Borrar todas las playas?'),
      content: Text(
        'Esta acción eliminará todas las playas guardadas y no se puede deshacer.\n\n'
        'Por seguridad, el botón se activará en $_secondsRemaining segundos.',
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: canDelete ? () => Navigator.of(context).pop(true) : null,
          icon: const Icon(Icons.delete_forever),
          label: Text(
            canDelete ? 'Borrar todo' : 'Esperar ($_secondsRemaining)',
          ),
          style: FilledButton.styleFrom(backgroundColor: _orange),
        ),
      ],
    );
  }
}
