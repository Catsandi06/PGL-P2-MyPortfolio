import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../models/beach.dart';
import '../utils/image_validator.dart';

/// Diálogo para crear una nueva playa con validaciones de formulario.
class AddBeachDialog extends StatefulWidget {
  const AddBeachDialog({super.key});

  @override
  State<AddBeachDialog> createState() => _AddBeachDialogState();
}

class _AddBeachDialogState extends State<AddBeachDialog> {
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

      // Se trabajan los bytes en memoria: nunca se ejecuta ni se reutiliza
      // como ruta un archivo elegido por el usuario.
      final bytes = await pickedFile.readAsBytes();

      // Validar tamaño
      final sizeError = ImageValidator.validateSize(bytes.length);
      if (sizeError != null) {
        _showImageError(sizeError);
        return;
      }

      // Validar formato
      final formatError = ImageValidator.validateFormat(bytes);
      if (formatError != null) {
        _showImageError(formatError);
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
                  if (url.isNotEmpty && !url.startsWith('https://')) {
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
