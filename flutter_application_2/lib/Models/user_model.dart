class UserProfile {
  final String password; 
  final DateTime birthday;
  final String address;
  final String postalCode;
  final String city;
  final String documentId;
  final String username;

  UserProfile({
    required this.password,
    required this.birthday,
    required this.address,
    required this.postalCode,
    required this.city,
    required this.documentId,
    required this.username,
  });
}
