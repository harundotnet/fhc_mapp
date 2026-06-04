class Patient {
  final int id;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String gender;
  final String? email;
  final String phoneNumber;
  final String? address;
  final String? notes;
  final String? postCode;

  Patient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    this.email,
    required this.phoneNumber,
    this.address,
    this.notes,
    this.postCode,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      gender: json['gender'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      notes: json['notes'],
      postCode: json['postCode'],
    );
  }
}
