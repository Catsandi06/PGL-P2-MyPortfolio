import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/beach.dart';
import '../viewmodels/playas_viewmodel.dart';
import '../widgets/add_beach_dialog.dart';
import '../widgets/app_drawer.dart';
import '../widgets/delete_all_dialog.dart';

/// Pantalla principal para consultar, crear y borrar playas.
/// Esta es solo la View: consume el ViewModel a través de ChangeNotifierProvider
/// y delega toda la lógica de negocio a los componentes correspondientes.
class CrudPlayasPage extends StatelessWidget {
  const CrudPlayasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlayasViewModel(),
      child: const _CrudPlayasView(),
    );
  }
}

class _CrudPlayasView extends StatelessWidget {
  const _CrudPlayasView();

  static const _teal = Color(0xFF2A9D8F);
  static const _orange = Color(0xFFC9502B);
  static const _surface = Color(0xFFF4F8F7);

  String _fallbackImageForCategory(String category) => switch (category) {
    'Playa urbana' || 'Playa familiar' => 'assets/images/home_bg.jpg',
    _ => 'assets/images/Sandi_proto.jpg',
  };

  Future<void> _showAddBeachDialog(BuildContext context) async {
    final viewModel = context.read<PlayasViewModel>();
    
    // El diálogo devuelve la playa mediante Navigator.pop cuando el formulario
    // supera todas sus validaciones.
    final newBeach = await showDialog<Beach>(
      context: context,
      builder: (context) => const AddBeachDialog(),
    );

    if (context.mounted && newBeach != null) {
      viewModel.addBeach(newBeach);
      _showFeedback(context);
    }
  }

  void _deleteBeach(BuildContext context, int index) {
    final viewModel = context.read<PlayasViewModel>();
    viewModel.deleteBeach(index);
    _showFeedback(context);
  }

  Future<void> _confirmDeleteAll(BuildContext context) async {
    final viewModel = context.read<PlayasViewModel>();
    if (viewModel.beaches.isEmpty) {
      return;
    }

    // La confirmación evita borrar la lista con un toque accidental.
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => const DeleteAllDialog(),
    );

    if (context.mounted && shouldDelete == true) {
      viewModel.deleteAllBeaches();
      _showFeedback(context);
    }
  }

  void _showFeedback(BuildContext context) {
    final viewModel = context.read<PlayasViewModel>();
    final message = viewModel.feedbackMessage;
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      viewModel.clearFeedback();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PlayasViewModel>();
    final beaches = viewModel.beaches;

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
                              label: Text('${beaches.length}'),
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
                        const Text(
                          'Organiza tus playas favoritas y consulta su estado.',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: beaches.isEmpty
                              ? null
                              : () => _confirmDeleteAll(context),
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
              child: beaches.isEmpty
                  ? const _EmptyBeachesMessage()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                      itemCount: beaches.length,
                      itemBuilder: (context, index) {
                        final beach = beaches[index];
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
                              onPressed: () => _deleteBeach(context, index),
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
        onPressed: () => _showAddBeachDialog(context),
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
