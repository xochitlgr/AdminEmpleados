import '../../domain/entities/employee.dart';

/// Modelo de datos del feature empleados (capa data).
///
/// Extiende la entidad de dominio `Employee` añadiendo `copyWith`.
class EmployeeModel extends Employee {
  const EmployeeModel({
    required super.id,
    required super.nombreCompleto,
    required super.area,
    required super.puesto,
    required super.genero,
    required super.fechaEntrada,
    super.fechaNacimiento,
    super.isActive = true,
  });

  factory EmployeeModel.fromEmployee(Employee employee) {
    return EmployeeModel(
      id: employee.id,
      nombreCompleto: employee.nombreCompleto,
      area: employee.area,
      puesto: employee.puesto,
      genero: employee.genero,
      fechaEntrada: employee.fechaEntrada,
      fechaNacimiento: employee.fechaNacimiento,
      isActive: employee.isActive,
    );
  }

  EmployeeModel copyWith({
    int? id,
    String? nombreCompleto,
    Area? area,
    String? puesto,
    Genero? genero,
    DateTime? fechaEntrada,
    DateTime? fechaNacimiento,
    bool? isActive,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      area: area ?? this.area,
      puesto: puesto ?? this.puesto,
      genero: genero ?? this.genero,
      fechaEntrada: fechaEntrada ?? this.fechaEntrada,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      isActive: isActive ?? this.isActive,
    );
  }
}