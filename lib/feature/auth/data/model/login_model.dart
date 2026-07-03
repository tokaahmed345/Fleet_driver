import 'package:fleet_driver/feature/auth/domain/entity/login_entity.dart';

class LogInModel extends LogInEntity {

  LogInModel({
    required super.id,
    required super.email,
    required super.name,
    required super.role,  super.driverId,
  });

  factory LogInModel.fromJson(Map<String, dynamic> json) {
    return LogInModel(
      id: json['id'].toString(),
      email: json['email'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      driverId: json["driverId"] ?.toString(), 
    );
  }
}