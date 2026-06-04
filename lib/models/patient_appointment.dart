class PatientAppointment {
  final int id;
  final int patientId;
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String gender;
  final String? email;
  final String phoneNumber;
  final String? address;
  final String? notes;
  final String? postcode;
  final List<TestDetails> testDetails;

  PatientAppointment({
    required this.id,
    required this.patientId,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    this.email,
    required this.phoneNumber,
    this.address,
    this.notes,
    this.postcode,
    required this.testDetails,
  });

  factory PatientAppointment.fromJson(Map<String, dynamic> json) {
    return PatientAppointment(
      id: json['id'],
      patientId: json['patientId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      notes: json['notes'],
      postcode: json['postcode'],
      testDetails: (json['testDetails'] as List)
          .map((e) => TestDetails.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'notes': notes,
      'postcode': postcode,
      'testDetails': testDetails.map((e) => e.toJson()).toList(),
    };
  }
}

class TestDetails {
  final int id;
  final String name;

  TestDetails({required this.id, required this.name});

  factory TestDetails.fromJson(Map<String, dynamic> json) {
    return TestDetails(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
