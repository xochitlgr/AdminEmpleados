import 'package:flutter/widgets.dart';

import '../features/employees/presentation/pages/employee_form_page.dart';
import '../features/employees/presentation/pages/employee_success_page.dart';

/// Nombres de las rutas nombradas de la aplicación.
class AppRoutes {
  AppRoutes._();

  static const String root = '/';
  static const String form = '/form';
  static const String success = '/success';
}

/// Construye el mapa de rutas.
///
/// La ruta raíz `/` se completa al existir `EmployeeListPage`.
Map<String, WidgetBuilder> buildAppRoutes() => {
      AppRoutes.form: (_) => const EmployeeFormPage(),
      AppRoutes.success: (_) => const EmployeeSuccessPage(),
    };