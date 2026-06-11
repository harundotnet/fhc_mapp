import 'package:flutter/material.dart';
import 'package:fusion_healthcare/core/key_constant.dart';

class CheckInConfirmationPage extends StatelessWidget {
  final String appointmentNo;
  const CheckInConfirmationPage({super.key, required this.appointmentNo});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isKioskOrTablet = screenWidth > 600;

    // Scale down padding and spacing on very small screens
    final isVerySmallScreen = screenHeight < 600;
    final basePadding = isVerySmallScreen
        ? 12.0
        : (isKioskOrTablet ? 40.0 : 24.0);
    final iconSize = isVerySmallScreen ? 60.0 : 100.0;
    final iconPadding = isVerySmallScreen ? 12.0 : 20.0;
    final titleFontSize = isVerySmallScreen
        ? 24.0
        : (isKioskOrTablet ? 40.0 : 32.0);
    //final cardPadding = isVerySmallScreen ? 16.0 : 28.0;
    final cardPadding = isVerySmallScreen ? 8.0 : 12.0;
    final infoFontSize = isVerySmallScreen
        ? 16.0
        : (isKioskOrTablet ? 24.0 : 18.0);
    final messageFontSize = isVerySmallScreen
        ? 13.0
        : (isKioskOrTablet ? 18.0 : 16.0);
    final spacing1 = isVerySmallScreen ? 16.0 : 32.0;
    final spacing2 = isVerySmallScreen ? 12.0 : 20.0;
    final spacing3 = isVerySmallScreen ? 20.0 : 40.0;
    //final spacing4 = isVerySmallScreen ? 16.0 : 32.0;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // colors: [Colors.white, const Color(0xFFF0F7F7)],
            colors: [Color(0xFFA8D5BA), Color(0xFFF5F5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: SingleChildScrollView(
                  // SingleChildScrollView is SAFELY used here but NO scrollbar appears
                  // because we set physics and scrollbar theme appropriately
                  physics:
                      const NeverScrollableScrollPhysics(), // Disables user scrolling
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                      maxWidth: isKioskOrTablet ? 800 : 500,
                    ),
                    padding: EdgeInsets.all(basePadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Animated checkmark icon
                        TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.elasticOut,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Container(
                                padding: EdgeInsets.all(iconPadding),
                                decoration: BoxDecoration(
                                  color: Color(
                                    0xFF0A6E6F,
                                  ).withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check_circle,
                                  color: const Color(0xFF0A6E6F),
                                  size: iconSize,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: spacing1),

                        // Main thank you message
                        Text(
                          'Thank You for Checking In',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.w700,
                            // color: const Color(0xFF1A2B2C),
                            //colorColor.fromRGBO(145, 208, 108, 1)C),
                            color: Colors.green,
                            height: 1.2,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: spacing2),

                        // Card with information
                        Container(
                          padding: EdgeInsets.all(cardPadding),
                          // decoration: BoxDecoration(
                          //   color: Colors.white,
                          //   borderRadius: BorderRadius.circular(32),
                          //   boxShadow: [
                          //     BoxShadow(
                          //       color: Colors.black.withValues(alpha: 0.05),
                          //       blurRadius: 20,
                          //       offset: const Offset(0, 10),
                          //     ),
                          //   ],
                          //   border: Border.all(
                          //     color: const Color(
                          //       0xFF0A6E6F,
                          //     ).withValues(alpha: 0.2),
                          //   ),
                          // ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Icon(
                              //   Icons.info_outline,
                              //   size: isVerySmallScreen ? 28 : 40,
                              //   color: const Color(0xFF0A6E6F),
                              // ),
                              // SizedBox(height: isVerySmallScreen ? 12 : 16),
                              Text(
                                'We\'ve received your information.\nPlease relax in the waiting area.\nYour Appointment No is $appointmentNo.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: infoFontSize,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF2C3E3F),
                                ),
                              ),
                              // SizedBox(height: isVerySmallScreen ? 8 : 12),
                              Text(
                                '\n\nOur team will shortly bring your printed consent form for signature.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: messageFontSize,
                                  fontWeight: FontWeight.w500,
                                  // color: const Color(0xFF5D7A7B),
                                  color: const Color(0xFF2C3E3F),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: spacing3),

                        // SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Return to welcome page and reset navbar
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/',
                              (route) => false,
                            );
                          },
                          icon: Icon(Icons.arrow_back),
                          label: Text("Back to Home"),
                        ),

                        //// Waiting area indicator
                        // Container(
                        //   padding: EdgeInsets.symmetric(
                        //     horizontal: isVerySmallScreen ? 14 : 20,
                        //     vertical: isVerySmallScreen ? 8 : 12,
                        //   ),
                        //   decoration: BoxDecoration(
                        //     color: const Color(
                        //       0xFF0A6E6F,
                        //     ).withValues(alpha: 0.08),
                        //     borderRadius: BorderRadius.circular(100),
                        //   ),
                        //   child: Row(
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: [
                        //       Container(
                        //         width: isVerySmallScreen ? 8 : 10,
                        //         height: isVerySmallScreen ? 8 : 10,
                        //         decoration: const BoxDecoration(
                        //           color: Color(0xFF0A6E6F),
                        //           shape: BoxShape.circle,
                        //         ),
                        //       ),
                        //       SizedBox(width: isVerySmallScreen ? 8 : 12),
                        //       Text(
                        //         'Waiting Area • Seat Available',
                        //         style: TextStyle(
                        //           fontSize: isVerySmallScreen ? 11 : 14,
                        //           fontWeight: FontWeight.w500,
                        //           color: const Color(0xFF0A6E6F),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        // SizedBox(height: spacing4),

                        //// Estimated wait time
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     Icon(
                        //       Icons.access_time,
                        //       size: isVerySmallScreen ? 14 : 18,
                        //       color: const Color(0xFF8BA7A8),
                        //     ),
                        //     SizedBox(width: isVerySmallScreen ? 6 : 8),
                        //     Text(
                        //       'Est. wait time: 5-10 minutes',
                        //       style: TextStyle(
                        //         fontSize: isVerySmallScreen ? 11 : 14,
                        //         color: const Color(0xFF8BA7A8),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        //  FIXED FOOTER
                        // Padding(
                        //   padding: EdgeInsets.only(bottom: 12),
                        //   child: Text(
                        //     "© ${DateTime.now().year} FusionHealthCare, All Rights Reserved",
                        //     style: TextStyle(
                        //       fontSize: 12,
                        //       color: Colors.black54,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(
            KeyConstant.copyRightInfo,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
