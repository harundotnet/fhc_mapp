import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fusion_healthcare/core/key_constant.dart';
import 'package:fusion_healthcare/dtos/patient.dart';
import 'package:fusion_healthcare/dtos/appointment_response.dart';
import 'package:fusion_healthcare/models/patient_appointment.dart';
import 'package:fusion_healthcare/pages/checkin_confirmation_page.dart';
import 'package:fusion_healthcare/providers/appointment_provider.dart';
import 'package:fusion_healthcare/services/healthcare_data_service_api.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AppointmentCheckInPage extends StatefulWidget {
  final Patient? existingPatient;
  const AppointmentCheckInPage({super.key, this.existingPatient});

  @override
  State<AppointmentCheckInPage> createState() => _AppointmentCheckInPageState();
}

class _AppointmentCheckInPageState extends State<AppointmentCheckInPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _postCodeController = TextEditingController();
  final _messageController = TextEditingController();

  DateTime? _selectedDoB;
  int _patientId = 0;
  String _selectedSex = 'Male';
  final List<TestDetails> _selectedServices = [];
  List<TestDetails> _availableServices = [];

  @override
  void initState() {
    super.initState();
    loadTypeOfServiceData();
    if (widget.existingPatient != null) _fillForm(widget.existingPatient);
  }

  Future<void> loadTypeOfServiceData() async {
    final data = await HealthcareDataServiceApi().getTestAll();
    setState(() {
      _availableServices = data;
    });
  }

  void _fillForm(Patient? patient) {
    _patientId = patient?.id ?? 0;
    _firstNameController.text = patient?.firstName ?? '';
    _lastNameController.text = patient?.lastName ?? '';
    _emailController.text = patient?.email ?? '';
    _phoneController.text = patient?.phoneNumber ?? '';
    _addressController.text = patient?.address ?? '';
    _postCodeController.text = patient?.postCode ?? '';
    _selectedDoB = patient?.dateOfBirth;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('en', 'GB'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.grey.shade900,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDoB) {
      setState(() {
        _selectedDoB = picked;
      });
    }
  }

  void _toggleService(TestDetails test) {
    setState(() {
      if (_selectedServices.contains(test)) {
        _selectedServices.remove(test);
      } else {
        _selectedServices.add(test);
      }
    });
  }

  Future<void> _handleCheckIn() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDoB == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select Date of Birth')),
        );
        return;
      }
      if (_selectedServices.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one service')),
        );
        return;
      }
      var dob =
          '${_selectedDoB!.year}-${_selectedDoB!.month.toString().padLeft(2, '0')}-${_selectedDoB!.day.toString().padLeft(2, '0')}';
      PatientAppointment patient = PatientAppointment(
        id: 0,
        patientId: _patientId,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        dateOfBirth: dob,
        gender: _selectedSex,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        address: _addressController.text,
        postcode: _postCodeController.text,
        notes: _messageController.text,
        testDetails: _selectedServices,
      );
      final provider = context.read<AppointmentProvider>();
      AppointmentResponse apiResponse = await provider.saveAppointment(patient);

      if (!context.mounted) return;
      if (apiResponse.success) {
        if (!mounted) return;
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => CheckInConfirmationPage(
        //       appointmentNo: apiResponse.appointmentNo!,
        //     ),
        //   ),
        // );

        //// Traditional Usage Pattern of PageTransition package
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            childBuilder: (context) => CheckInConfirmationPage(
              appointmentNo: apiResponse.appointmentNo!,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhonePortrait = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        // iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Appointment Check In',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFFA8D5BA),
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Patient Information Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.health_and_safety,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Patient Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),

                        // Responsive layout
                        if (isPhonePortrait)
                          Column(
                            children: [
                              _buildFirstNameField(),
                              const SizedBox(height: 16),
                              _buildLastNameField(),
                              const SizedBox(height: 16),
                              _buildDateOfBirthField(),
                              const SizedBox(height: 16),
                              _buildSexField(),
                              const SizedBox(height: 16),
                              _buildAddressField(),
                              const SizedBox(height: 16),
                              _buildPostCodeField(),
                              const SizedBox(height: 16),
                              _buildEmailField(),
                              const SizedBox(height: 16),
                              _buildPhoneField(),
                              const SizedBox(height: 16),
                              _buildMessageField(),
                            ],
                          )
                        else
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    _buildFirstNameField(),
                                    const SizedBox(height: 16),
                                    _buildDateOfBirthField(),
                                    const SizedBox(height: 16),
                                    _buildEmailField(),
                                    const SizedBox(height: 16),
                                    _buildAddressField(),
                                    const SizedBox(height: 16),
                                    _buildMessageField(),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  children: [
                                    _buildLastNameField(),
                                    const SizedBox(height: 16),
                                    _buildSexField(),
                                    const SizedBox(height: 16),
                                    _buildPhoneField(),
                                    const SizedBox(height: 16),
                                    _buildPostCodeField(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Services Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.medical_services,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Type of Services',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Select all that apply:',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 12),

                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _availableServices.map((item) {
                            //  final service = _availableServices[index];
                            final service = _availableServices.firstWhere(
                              (e) => e == item,
                            );
                            return FilterChip(
                              label: Text(service.name),
                              selected: _selectedServices.contains(service),
                              onSelected: (_) => _toggleService(service),
                              selectedColor: Theme.of(
                                context,
                              ).primaryColor.withValues(alpha: .2),
                              checkmarkColor: Theme.of(context).primaryColor,
                              backgroundColor: Colors.grey.shade50,
                              side: BorderSide(
                                color: _selectedServices.contains(service)
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey.shade400,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const SizedBox(height: 24),

                // Check In Button
                Center(
                  child: Consumer<AppointmentProvider>(
                    builder: (context, provider, _) {
                      return ElevatedButton(
                        onPressed: provider.isLoading ? null : _handleCheckIn,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(140, 46),
                          maximumSize: Size(200, 48),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          elevation: 1,
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),

                        child: provider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Check In Now!',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),
                // Footer
                Center(
                  child: Text(
                    KeyConstant.copyRightInfo,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFirstNameField() {
    return TextFormField(
      controller: _firstNameController,
      decoration: const InputDecoration(
        labelText: 'First Name*',
        prefixIcon: Icon(Icons.person_outline),
        hintText: 'Enter first name',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'First name is required';
        }
        return null;
      },
    );
  }

  Widget _buildLastNameField() {
    return TextFormField(
      controller: _lastNameController,
      decoration: const InputDecoration(
        labelText: 'Last Name*',
        prefixIcon: Icon(Icons.person_outline),
        hintText: 'Enter last name',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Last name is required';
        }
        return null;
      },
    );
  }

  Widget _buildDateOfBirthField() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Date of Birth*',
          prefixIcon: Icon(Icons.cake_outlined),
          border: OutlineInputBorder(),
        ),
        child: Text(
          _selectedDoB == null
              ? 'Select date dd/mm/yyyy'
              : '${_selectedDoB!.day.toString().padLeft(2, '0')}/${_selectedDoB!.month.toString().padLeft(2, '0')}/${_selectedDoB!.year}',
          style: TextStyle(
            color: _selectedDoB == null ? Colors.grey : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildSexField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        RadioGroup<String>(
          groupValue: _selectedSex,
          onChanged: (String? value) {
            setState(() {
              _selectedSex = value ?? _selectedSex;
            });
          },
          child: Wrap(
            spacing: 10,
            runSpacing: 5,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text("Gender*:"),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(value: "Male"),
                  GestureDetector(
                    onTap: () => handleSelectedSexTap("Male"),
                    child: const Text("Male"),
                  ),
                ],
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(value: "Female"),
                  GestureDetector(
                    onTap: () => handleSelectedSexTap("Female"),
                    child: const Text("Female"),
                  ),
                ],
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(value: "Other"),
                  GestureDetector(
                    onTap: () => handleSelectedSexTap("Other"),
                    child: const Text("Other"),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  void handleSelectedSexTap(String gender) {
    setState(() {
      _selectedSex = gender;
    });
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      decoration: const InputDecoration(
        labelText: 'Address',
        prefixIcon: Icon(Icons.location_on_outlined),
        hintText: 'Enter address',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPostCodeField() {
    return TextFormField(
      controller: _postCodeController,
      keyboardType: TextInputType.text,
      // inputFormatters: <TextInputFormatter>[
      //   //FilteringTextInputFormatter.digitsOnly, // Restricts input to digits 0-9
      //   LengthLimitingTextInputFormatter(4),
      // ],
      decoration: const InputDecoration(
        labelText: 'Post Code',
        prefixIcon: Icon(Icons.account_balance_outlined),
        hintText: 'Enter post code',
        border: OutlineInputBorder(),
      ),
      // validator: (value) {
      //   if (value != null && value.isNotEmpty && value.length < 4) {
      //     return 'Postcode must be 4 characters';
      //   }
      //   return null;
      // },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email*',
        prefixIcon: Icon(Icons.email_outlined),
        hintText: 'mail@example.com',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email is required';
        }
        if (!value.contains('@') || !value.contains('.')) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      decoration: const InputDecoration(
        labelText: 'Phone Number*',
        prefixIcon: Icon(Icons.phone_outlined),
        hintText: '(555) 123-4567',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Phone number is required';
        }
        if (value.length < 10) {
          return 'Enter a valid phone number';
        }
        return null;
      },
    );
  }

  Widget _buildMessageField() {
    return TextFormField(
      controller: _messageController,
      keyboardType: TextInputType.multiline,
      minLines: 1, // Normal height to start
      maxLines: null, // Grows indefinitely as user types
      decoration: const InputDecoration(
        labelText: 'Message (if any)',
        prefixIcon: Icon(Icons.message_outlined),
        hintText: 'Enter any additional notes or concerns...',
        border: OutlineInputBorder(),
      ),
    );
  }
}
