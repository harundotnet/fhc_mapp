import 'package:flutter/material.dart';
import 'package:fusion_healthcare/core/key_constant.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:fusion_healthcare/pages/appointment_checkin_page.dart';
import 'package:fusion_healthcare/pages/find_patient_page.dart';
import 'package:page_transition/page_transition.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;

          if (width >= 1000) {
            return _buildKioskLayout(context);
          } else if (width >= 600) {
            return _buildTabletLayout(context);
          } else {
            return _buildMobileLayout(context);
          }
        },
      ),
    );
  }

  // ================= KIOSK =================
  Widget _buildKioskLayout(BuildContext context) {
    return _buildContainer(
      context,
      logoSize: 150,
      titleSize: 28,
      buttonWidth: 280,
      isVertical: false,
      padding: 60,
    );
  }

  // ================= TABLET =================
  Widget _buildTabletLayout(BuildContext context) {
    return _buildContainer(
      context,
      logoSize: 130,
      titleSize: 22,
      buttonWidth: 220,
      isVertical: false,
      padding: 40,
    );
  }

  // ================= MOBILE =================
  Widget _buildMobileLayout(BuildContext context) {
    return _buildContainer(
      context,
      logoSize: 120,
      titleSize: 16,
      // buttonWidth: double.infinity,
      buttonWidth: 240,
      isVertical: true,
      padding: 20,
    );
  }

  // ================= COMMON UI =================
  Widget _buildContainer(
    BuildContext context, {
    required double logoSize,
    required double titleSize,
    required double buttonWidth,
    required bool isVertical,
    required double padding,
  }) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFA8D5BA), Color(0xFFEAEAEA)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Column(
              children: [
                //// Logo Design
                // Container(
                //   width: logoSize,
                //   height: logoSize,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     border: Border.all(color: Colors.blue, width: 2),
                //   ),
                //   child: const Center(
                //     child: Icon(
                //       Icons.local_hospital,
                //       size: 40,
                //       color: Colors.blue,
                //     ),
                //   ),
                // ),
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: logoSize,
                    width: logoSize,
                    filterQuality: FilterQuality.high,
                  ),
                ),

                // To display from your assets folder:
                // SvgPicture.asset(
                //   'assets/images/logo_2000px.svg',
                //   width: 100,
                //   height: 100,
                //   semanticsLabel: 'Company Logo', // Good for accessibility!
                // ),
                const SizedBox(height: 10),

                // Title
                Text(
                  "Welcome to Fusion Healthcare",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 20),

                // Buttons
                isVertical
                    ? Column(children: _buttons(context, buttonWidth))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buttons(context, buttonWidth),
                      ),
              ],
            ),

            // Footer
            Padding(
              padding: EdgeInsets.only(bottom: padding),
              child: Text(
                KeyConstant.copyRightInfo,
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= BUTTONS (New Patient, Repeat Patient)=================
  List<Widget> _buttons(BuildContext context, double width) {
    return [
      SizedBox(
        width: width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            // Push replacement
            context.pushTransition(
              type: PageTransitionType.rightToLeft,
              duration: Duration(milliseconds: 300),
              child: AppointmentCheckInPage(),
            );
          },
          child: Text("New Patient", style: TextStyle(color: Colors.white)),
        ),
      ),
      const SizedBox(width: 20, height: 20),
      SizedBox(
        width: width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            ////Using Extensions (Recommended) Pattern of PageTransition package
            context.pushTransition(
              type: PageTransitionType.rightToLeft,
              duration: Duration(milliseconds: 300),
              child: FindPatientPage(),
            );
          },
          child: Text("Repeat Patient", style: TextStyle(color: Colors.white)),
        ),
      ),
    ];
  }
}
