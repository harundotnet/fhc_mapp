import 'package:flutter/material.dart';
import 'package:fusion_healthcare/dtos/patient.dart';
import 'package:fusion_healthcare/dtos/appointment_response.dart';
import 'package:fusion_healthcare/models/patient_appointment.dart';
import 'package:fusion_healthcare/services/healthcare_data_service_api.dart';

class AppointmentProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  // String? _appointmentNo;
  // String? get appointmentNo => _appointmentNo;

  Patient? patientInfo;

  Future<AppointmentResponse> saveAppointment(
    PatientAppointment patient,
  ) async {
    _isLoading = true;
    _isSuccess = false;

    notifyListeners();
    try {
      final result = await HealthcareDataServiceApi().createAppointment(
        patient,
      );

      if (result.success) {
        _isSuccess = true;
        return result;
      } else {
        _isSuccess = false;
        return AppointmentResponse(
          success: false,
          message: "Error: Something went wrong.",
          id: null,
          appointmentNo: '',
        );
      }
    } catch (e) {
      return AppointmentResponse(
        success: false,
        message: "Error: Something went wrong.",
        id: null,
        appointmentNo: '',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPatientInfo(String dob, String lastName) async {
    try {
      _isLoading = true;
      notifyListeners();
      // await Future.delayed(const Duration(seconds: 2));
      patientInfo = await HealthcareDataServiceApi().findPatient(dob, lastName);
    } catch (e) {
      _isLoading = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _isSuccess = false;
    patientInfo = null;
  }
}
