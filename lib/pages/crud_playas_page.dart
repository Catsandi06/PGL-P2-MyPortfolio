import 'package:flutter/material.dart';

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
    required this.isClean,
    required this.approximatePeople,
  });

  final String name;
  final String description;
  final String category;
  final String imageUrl;
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
                color: _teal,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.format_list_bulleted,
                        color: Colors.white,
                        size: 30,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Playas guardadas',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Este marcador siempre refleja la longitud actual.
                      Badge(
                        label: Text('${_beaches.length}'),
                        backgroundColor: _orange,
                        textColor: Colors.white,
                        child: const Icon(
                          Icons.inventory_2_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
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
                              child: beach.imageUrl.isEmpty
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
  String _category = beachCategories.first;
  bool _isClean = true;

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
        isClean: _isClean,
        approximatePeople: int.parse(_peopleController.text.trim()),
      ),
    );
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
