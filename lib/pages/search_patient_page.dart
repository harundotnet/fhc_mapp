import 'package:flutter/material.dart';
import 'package:fusion_healthcare/pages/appointment_checkin_page.dart';
import 'package:fusion_healthcare/providers/appointment_provider.dart';
import 'package:provider/provider.dart';

class SearchPatientPage extends StatefulWidget {
  const SearchPatientPage({super.key});

  @override
  State<SearchPatientPage> createState() => _SearchPatientPageState();
}

class _SearchPatientPageState extends State<SearchPatientPage> {
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
      var dob =
          '${_selectedDoB!.year}-${_selectedDoB!.month.toString().padLeft(2, '0')}-${_selectedDoB!.day.toString().padLeft(2, '0')}';

      final provider = context.read<AppointmentProvider>();
      await provider.getPatientInfo(dob, _lastNameController.text);
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
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA8D5BA), Color(0xFFF5F5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // MAIN CONTENT (centered)
              Expanded(child: Center(child: _responsiveLayout(width))),

              // 🔻 FIXED FOOTER
              Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  "© ${DateTime.now().year} FusionHealthCare, All Rights Reserved",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _responsiveLayout(double width) {
    if (width > 1000) {
      return _buildForm(maxWidth: 700, logoSize: 140, isRow: true);
    } else if (width > 600) {
      return _buildForm(maxWidth: 500, logoSize: 110, isRow: true);
    } else {
      return _buildForm(maxWidth: 320, logoSize: 90, isRow: false);
      //return _buildForm(maxWidth: 250, logoSize: 90, isRow: false);
    }
  }

  Widget _buildForm({
    required double maxWidth,
    required double logoSize,
    required bool isRow,
  }) {
    return Container(
      width: maxWidth,
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const SizedBox(height: 20),
            // LOGO
            Center(
              child: Image.asset(
                'assets/images/logo_2000px.png',
                height: logoSize,
                width: logoSize,
                filterQuality: FilterQuality.high,
              ),
            ),

            const Text(
              "Search Patient Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),

            const SizedBox(height: 20),

            // INPUTS
            isRow
                ? Row(
                    children: [
                      Expanded(child: _dateField()),
                      const SizedBox(width: 16),
                      Expanded(child: _lastNameField()),
                    ],
                  )
                : Column(
                    children: [
                      _dateField(),
                      const SizedBox(height: 16),
                      _lastNameField(),
                    ],
                  ),

            const SizedBox(height: 20),

            // BUTTON
            SizedBox(
              width: isRow ? 220 : double.infinity,
              child: Consumer<AppointmentProvider>(
                builder: (context, provider, _) {
                  return ElevatedButton(
                    onPressed: provider.isLoading ? null : _buttonSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
                        : Text(
                            "Search Now!",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateField() {
    return TextFormField(
      controller: _dobController,
      readOnly: true,
      onTap: _pickDate,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please select Date of Birth";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Date Of Birth",
        filled: true,
        fillColor: Colors.grey[200],
        suffixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _lastNameField() {
    return TextFormField(
      controller: _lastNameController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please enter last name";
        }
        if (value.length < 2) {
          return "Minimum 2 characters required";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Last Name",
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
