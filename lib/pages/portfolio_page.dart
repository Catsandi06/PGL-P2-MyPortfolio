import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../widgets/portfolio_drawer.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  static const _teal = Color(0xFF5E7A80);
  static const _orange = Color(0xFFC9502B);
  static const _surface = Color(0xFFF4F8F7);

  int _selectedIndex = 0;

  static const _hobbies = [
    'La informática',
    'La música',
    'Los gatos',
    'Las consolas retro',
    'Ser furry',
    'Los coches',
    'La impresión 3D',
    'Los viajes',
  ];

  void _openCatMemes() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => const _CatMemesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      drawer: const PortfolioDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: const BoxDecoration(
                color: _teal,
                border: Border(bottom: BorderSide(color: _orange, width: 5)),
              ),
              child: const Text(
                'Este es mi portfolio',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const _ProfileSection(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _selectedIndex == 0
                    ? _HobbiesView(
                        key: const ValueKey('hobbies'),
                        hobbies: _hobbies,
                        onCatsTap: _openCatMemes,
                      )
                    : const _RepositoryView(key: ValueKey('repository')),
              ),
            ),
            NavigationBar(
              backgroundColor: _teal,
              indicatorColor: _orange,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              labelTextStyle: const WidgetStatePropertyAll(
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.favorite_border, color: Colors.white),
                  selectedIcon: Icon(Icons.favorite, color: Colors.white),
                  label: 'Mis hobbies',
                ),
                NavigationDestination(
                  icon: Icon(Icons.folder_outlined, color: Colors.white),
                  selectedIcon: Icon(Icons.folder, color: Colors.white),
                  label: 'Mi repositorio',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFFFF1EC),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final avatar = ClipOval(
            child: Image.network(
              'https://github.com/Catsandi06.png',
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                width: 90,
                height: 90,
                child: ColoredBox(
                  color: Color(0xFF5E7A80),
                  child: Icon(Icons.person, size: 48, color: Colors.white),
                ),
              ),
            ),
          );
          const description = Text(
            'Soy alumno de 2º DAM y me gusta lo que hago. '
            'Intento hacerlo lo mejor que puedo.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          );

          if (constraints.maxWidth >= 520) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                avatar,
                const SizedBox(width: 20),
                Flexible(child: description),
              ],
            );
          }
          return Column(
            children: [avatar, const SizedBox(height: 12), description],
          );
        },
      ),
    );
  }
}

class _HobbiesView extends StatelessWidget {
  const _HobbiesView({
    required this.hobbies,
    required this.onCatsTap,
    super.key,
  });

  final List<String> hobbies;
  final VoidCallback onCatsTap;

  IconData _iconFor(String hobby) => switch (hobby) {
        'La informática' => Icons.computer,
        'La música' => Icons.music_note,
        'Los gatos' => Icons.pets,
        'Las consolas retro' => Icons.sports_esports,
        'Ser furry' => Icons.pets_outlined,
        'Los coches' => Icons.directions_car,
        'La impresión 3D' => Icons.view_in_ar,
        'Los viajes' => Icons.flight,
        _ => Icons.favorite,
      };

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: hobbies.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 260,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 76,
      ),
      itemBuilder: (context, index) {
        final hobby = hobbies[index];
        final isCats = hobby == 'Los gatos';
        return Card(
          margin: EdgeInsets.zero,
          color: index.isEven ? const Color(0xFFC9502B) : const Color(0xFF5E7A80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: InkWell(
            onTap: isCats ? onCatsTap : null,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  Icon(_iconFor(hobby), color: Colors.white, size: 26),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      hobby,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (isCats)
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RepositoryView extends StatelessWidget {
  const _RepositoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Image.asset(
            'assets/images/Sandi_proto.jpg',
            width: 180,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          const Text(
            '¡Sandi Proto, el mejor gato programador!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF5E7A80),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF5E7A80),
              borderRadius: BorderRadius.circular(12),
            ),
            child: QrImageView(
              data: 'https://github.com/Catsandi06/',
              version: QrVersions.auto,
              size: 200,
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _CatMemesPage extends StatelessWidget {
  const _CatMemesPage();

  static const _memes = [
    (
      'https://media.giphy.com/media/JIX9t2j0ZTN9S/giphy.gif',
      'Gato programando: cuando el código funciona a la primera',
    ),
    (
      'https://media.giphy.com/media/5i7umUqAOYYEw/giphy.gif',
      'Gato confundido: buscando el bug durante horas',
    ),
    (
      'https://media.giphy.com/media/7KwCQcpVaMvGo/giphy.gif',
      'Gato reclamando sus permisos de administrador',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F7),
      appBar: AppBar(
        title: const Text('Memes de gatos'),
        backgroundColor: const Color(0xFF5E7A80),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'El rincón de los gatos programadores',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF5E7A80),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._memes.map(
            (meme) => Card(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  Image.network(
                    meme.$1,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const SizedBox(
                      height: 220,
                      child: Center(
                        child: Icon(
                          Icons.pets,
                          color: Color(0xFFC9502B),
                          size: 64,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      meme.$2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF5E7A80),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
