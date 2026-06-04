class AppointmentResponse {
  final bool success;
  final String? message;
  final int? id;
  final String? appointmentNo;

  AppointmentResponse({
    required this.success,
    this.message,
    this.id,
    this.appointmentNo,
  });

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentResponse(
      success: json['success'],
      message: json['message'],
      id: json['id'],
      appointmentNo: json['appointmentNo'] ?? '',
    );
  }
}
