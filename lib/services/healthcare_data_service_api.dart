import 'package:dio/dio.dart';
import 'package:fusion_healthcare/core/api_constant.dart';
import 'package:fusion_healthcare/dtos/patient.dart';
import 'package:fusion_healthcare/dtos/appointment_response.dart';
import 'package:fusion_healthcare/models/patient_appointment.dart';

class HealthcareDataServiceApi {
  Future<List<TestDetails>> getTestAll() async {
    List<TestDetails> dataList = [];
    // final dio = await SecureDio.create();
    final dio = Dio();
    final apiUrl = '${ApiConstant.baseUrl}/api/Test/GetAll';
    final response = await dio.get(apiUrl);
    // // Extract the data array from response
    if (response.statusCode == 200 && response.data != null) {
      List<dynamic> responseData = response.data;
      dataList = responseData
          .map((objItem) => TestDetails.fromJson(objItem))
          .toList();
      return dataList;
    } else {
      return dataList;
    }
  }

  Future<Patient?> findPatient(String dob, String lastName) async {
    // final dio = await SecureDio.create();
    final dio = Dio();
    final apiUrl = '${ApiConstant.baseUrl}/api/HealthcarePatient/FindPatient';
    final response = await dio.get(
      apiUrl,
      queryParameters: {'dob': dob, 'lastName': lastName},
    );
    if (response.statusCode == 200 && response.data != null) {
      Patient data = Patient.fromJson(response.data);
      return data;
    } else {
      return null;
    }
  }

  Future<AppointmentResponse> createAppointment(
    PatientAppointment patient,
  ) async {
    try {
      final apiUrl = "${ApiConstant.baseUrl}/api/Appointment/CreateAppointment";
      var requestBody = patient.toJson();

      final dio = Dio();
      var headers = {'Content-Type': 'application/json'};
      var response = await dio.request(
        apiUrl,
        options: Options(method: 'POST', headers: headers),
        data: requestBody,
      );

      if (response.statusCode == 200) {
        AppointmentResponse dataObj = AppointmentResponse.fromJson(
          response.data,
        );
        // var dataObj = AppointmentResponse(
        //   success: response.data['success'],
        //   message: response.data['message'],
        // );
        return dataObj;
      } else {
        return AppointmentResponse(
          success: false,
          message: 'Something went wrong',
        );
      }
    } catch (e) {
      return AppointmentResponse(success: false, message: e.toString());
    }
  }
}
