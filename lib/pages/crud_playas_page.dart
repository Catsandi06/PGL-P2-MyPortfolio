import 'package:flutter/material.dart';

import '../models/beach.dart';
import '../widgets/add_beach_dialog.dart';
import '../widgets/app_drawer.dart';
import '../widgets/delete_all_dialog.dart';
import '../widgets/empty_beaches_message.dart';

/// Pantalla principal para consultar, crear y borrar playas.
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
    // El diálogo devuelve la playa mediante Navigator.pop cuando el formulario
    // supera todas sus validaciones.
    final newBeach = await showDialog<Beach>(
      context: context,
      builder: (context) => const AddBeachDialog(),
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

    // La confirmación evita borrar la lista con un toque accidental.
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => const DeleteAllDialog(),
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
                  ? const EmptyBeachesMessage()
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

/*
  Los widgets _EmptyBeachesMessage, _AddBeachDialog y _DeleteAllDialog
  se extrajeron a archivos dedicados:
  - lib/widgets/empty_beaches_message.dart
  - lib/widgets/add_beach_dialog.dart
  - lib/widgets/delete_all_dialog.dart
*/
