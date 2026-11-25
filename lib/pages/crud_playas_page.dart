import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/beach.dart';
import '../viewmodels/playas_viewmodel.dart';
import '../widgets/add_beach_dialog.dart';
import '../widgets/app_drawer.dart';
import '../widgets/beach_list_item.dart';
import '../widgets/beaches_summary_card.dart';
import '../widgets/delete_all_dialog.dart';
import '../widgets/empty_beaches_message.dart';

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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
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
              child: BeachesSummaryCard(
                beachCount: beaches.length,
                onDeleteAll: beaches.isEmpty
                    ? null
                    : () => _confirmDeleteAll(context),
              ),
            ),
            Expanded(
              child: beaches.isEmpty
                  ? const EmptyBeachesMessage()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                      itemCount: beaches.length,
                      itemBuilder: (context, index) {
                        final beach = beaches[index];
                        return BeachListItem(
                          beach: beach,
                          onDelete: () => _deleteBeach(context, index),
                          deleteButtonColor: _orange,
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
