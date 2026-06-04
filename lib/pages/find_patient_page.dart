import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fusion_healthcare/pages/appointment_checkin_page.dart';
import 'package:fusion_healthcare/providers/appointment_provider.dart';
import 'package:provider/provider.dart';

class FindPatientPage extends StatefulWidget {
  const FindPatientPage({super.key});

  @override
  State<FindPatientPage> createState() => _FindPatientPageState();
}

class _FindPatientPageState extends State<FindPatientPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDoB;
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDoB = picked;
        _dobController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  Future<void> _buttonSearch() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDoB == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select Date of Birth')),
        );
        return;
      }

      var dob =
          '${_selectedDoB!.year}-${_selectedDoB!.month.toString().padLeft(2, '0')}-${_selectedDoB!.day.toString().padLeft(2, '0')}';

      final provider = context.read<AppointmentProvider>();
      await provider.getPatientInfo(dob, _lastNameController.text.trim());
      if (!mounted) return;
      if (provider.patientInfo != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AppointmentCheckInPage(existingPatient: provider.patientInfo),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Patient not found")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
    final isPhonePortrait = screenWidth < 600;
    // double logoSize = 120.0;

    // if (screenWidth >= 1000) {
    //   logoSize = 150.0;
    // } else if (screenWidth >= 600) {
    //   logoSize = 130.0;
    // } else {
    //   logoSize = screenHeight < 320 ? 90.0 : 120.0;
    // }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        //iconTheme: const IconThemeData(color: Colors.black),
        title: Text('Search Patient', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFA8D5BA),
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // LOGO
                          // Visibility(
                          //   visible: !isPhonePortrait,
                          //   child: Center(
                          //     child: Image.asset(
                          //       'assets/images/logo.png',
                          //       height: logoSize,
                          //       width: logoSize,
                          //       filterQuality: FilterQuality.high,
                          //     ),
                          //   ),
                          // ),
                          SizedBox(height: isPhonePortrait ? 5 : 20),

                          // Patient Search Info Card (Main Content)
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  if (isPhonePortrait)
                                    Column(
                                      children: [
                                        _buildDateOfBirthField(),
                                        const SizedBox(height: 16),
                                        _buildLastNameField(),
                                        const SizedBox(height: 16),
                                      ],
                                    )
                                  else
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              _buildDateOfBirthField(),
                                              const SizedBox(height: 16),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              _buildLastNameField(),
                                              const SizedBox(height: 16),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: isPhonePortrait ? 5 : 20),

                          // Search Button
                          Center(
                            child: Consumer<AppointmentProvider>(
                              builder: (context, provider, _) {
                                return ElevatedButton(
                                  onPressed: provider.isLoading
                                      ? null
                                      : _buttonSearch,
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(140, 46),
                                    maximumSize: const Size(200, 48),
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
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
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Search Now!',
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

                          // // Spacer to push footer to bottom
                          // const Spacer(),

                          // // Footer
                          // Column(
                          //   children: [
                          //     const SizedBox(height: 16),
                          //     Center(
                          //       child: Text(
                          //         '© ${DateTime.now().year} FusionHealthCare, All Rights Reserved',
                          //         style: TextStyle(
                          //           color: Colors.grey.shade600,
                          //           fontSize: 12,
                          //         ),
                          //       ),
                          //     ),
                          //     const SizedBox(height: 8),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        alignment: Alignment.center,
        child: Text(
          "© ${DateTime.now().year} FusionHealthCare, All Rights Reserved",
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildLastNameField() {
    return TextFormField(
      controller: _lastNameController,
      decoration: const InputDecoration(
        labelText: 'Last Name',
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
      onTap: () => _pickDate(),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Date of Birth',
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
}
