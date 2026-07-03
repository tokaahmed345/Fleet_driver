class LogInEntity {
  final String email;
  final String role;
  final String id;
  final String name;
  final String ?driverId;
 

  LogInEntity({
    required this.email, required this.role, required this.id, required this.name,  this.driverId,

  });
}