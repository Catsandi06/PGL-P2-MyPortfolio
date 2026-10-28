import 'package:flutter_test/flutter_test.dart';

import 'package:pgl_p2_myportfolio/main.dart';

void main() {
  testWidgets('muestra la pantalla de bienvenida', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Hola, Nichel'), findsOneWidget);
    expect(find.text('Explorar playas'), findsOneWidget);
  });

  testWidgets('el drawer solo muestra bienvenida y portfolio', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('Abrir menú'));
    await tester.pumpAndSettle();

    expect(find.text('Bienvenida'), findsOneWidget);
    expect(find.text('Portfolio'), findsOneWidget);
    expect(find.text('Sobre mí'), findsNothing);
    expect(find.text('Proyectos'), findsNothing);
    expect(find.text('Contacto'), findsNothing);
  });

  testWidgets('abre el portfolio con hobbies y repositorio', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('Abrir menú'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Portfolio'));
    await tester.pumpAndSettle();

    expect(find.text('Este es mi portfolio'), findsOneWidget);
    expect(find.text('La informática'), findsOneWidget);
    expect(find.text('Los gatos'), findsOneWidget);

    await tester.tap(find.text('Mi repositorio'));
    await tester.pumpAndSettle();

    expect(find.text('¡Sandi Proto, el mejor gato programador!'), findsOneWidget);

    await tester.tap(find.byTooltip('Abrir menú'));
    await tester.pumpAndSettle();
    expect(find.text('Bienvenida'), findsOneWidget);
    expect(find.text('Portfolio'), findsNWidgets(2));
  });
}
