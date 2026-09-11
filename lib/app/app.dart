import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'routes.dart';

/// Widget raíz de la aplicación (US3, FR-009).
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Empleados',
      theme: AppTheme.light,
      initialRoute: AppRoutes.root,
      routes: buildAppRoutes(),
    );
  }
}