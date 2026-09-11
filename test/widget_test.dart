import 'package:flutter_test/flutter_test.dart';
import 'package:employee_app/app/app.dart';
import 'package:employee_app/app/di/injector.dart';

void main() {
  testWidgets('la app arranca y muestra la lista de empleados', (tester) async {
    setupLocator();

    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.text('Empleados'), findsWidgets);
    expect(find.text('Ana García'), findsOneWidget);
  });
}