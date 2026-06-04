import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const DiagnosticCenterLandingPage());
}

class DiagnosticCenterLandingPage extends StatelessWidget {
  const DiagnosticCenterLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthCheck Diagnostic Center',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final PageController _carouselController = PageController();
  int _currentCarouselIndex = 0;
  late Timer _carouselTimer;
  late Timer _marqueeTimer;
  double _marqueeOffset = 0.0;

  final List<CarouselItem> _carouselItems = [
    CarouselItem(
      title: 'Full Body Checkup',
      description: 'Complete health screening with 70+ tests',
      imageUrl: 'https://cdn-icons-png.flaticon.com/512/2960/2960289.png',
      gradient: const LinearGradient(
        colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
      ),
    ),
    CarouselItem(
      title: 'COVID-19 RT-PCR Test',
      description: 'Results within 24 hours at your doorstep',
      imageUrl: 'https://cdn-icons-png.flaticon.com/512/2917/2917995.png',
      gradient: const LinearGradient(
        colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
      ),
    ),
    CarouselItem(
      title: 'Diabetes Care Package',
      description: 'HbA1c, FBS, PPBS with expert consultation',
      imageUrl: 'https://cdn-icons-png.flaticon.com/512/3064/3064197.png',
      gradient: const LinearGradient(
        colors: [Color(0xFFE65C00), Color(0xFFF9D423)],
      ),
    ),
    CarouselItem(
      title: 'Home Sample Collection',
      description: 'Free sample pickup from home/office',
      imageUrl: 'https://cdn-icons-png.flaticon.com/512/3049/3049472.png',
      gradient: const LinearGradient(
        colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
      ),
    ),
  ];

  final List<FeatureItem> _features = [
    FeatureItem(
      icon: Icons.health_and_safety,
      title: 'NABL Accredited',
      description: 'Internationally recognized lab standards',
      color: Colors.blue,
    ),
    FeatureItem(
      icon: Icons.access_time,
      title: 'Same Day Reports',
      description: 'Get digital reports within 6-24 hours',
      color: Colors.green,
    ),
    FeatureItem(
      icon: Icons.local_hospital,
      title: 'Expert Phlebotomists',
      description: 'Certified professionals for painless collection',
      color: Colors.purple,
    ),
    FeatureItem(
      icon: Icons.discount,
      title: 'Up to 50% OFF',
      description: 'On all preventive health packages',
      color: Colors.orange,
    ),
    FeatureItem(
      icon: Icons.home,
      title: 'Home Collection',
      description: 'Free doorstep sample collection',
      color: Colors.teal,
    ),
    FeatureItem(
      icon: Icons.security,
      title: 'HIPAA Compliant',
      description: 'Your data is safe & encrypted',
      color: Colors.indigo,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Auto-slide carousel every 3 seconds
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_carouselController.hasClients) {
        int nextPage = _currentCarouselIndex + 1;
        if (nextPage >= _carouselItems.length) {
          nextPage = 0;
        }
        _carouselController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    // Animate marquee text
    _marqueeTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _marqueeOffset -= 2.0;
        if (_marqueeOffset <= -MediaQuery.of(context).size.width) {
          _marqueeOffset = MediaQuery.of(context).size.width;
        }
      });
    });
  }

  @override
  void dispose() {
    _carouselController.dispose();
    _carouselTimer.cancel();
    _marqueeTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
        desktop: _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const TopBar(),
          const SizedBox(height: 20),
          MarqueeOfferBar(offset: _marqueeOffset),
          const SizedBox(height: 20),
          CarouselSlider(
            controller: _carouselController,
            items: _carouselItems,
            currentIndex: _currentCarouselIndex,
            onPageChanged: (index) {
              setState(() {
                _currentCarouselIndex = index;
              });
            },
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SectionTitle(title: 'Why Choose Us?'),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: _features.length,
                  itemBuilder: (context, index) {
                    return FeatureCard(feature: _features[index]);
                  },
                ),
                const SizedBox(height: 40),
                const CTASection(),
                const SizedBox(height: 30),
                const Footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const TopBar(),
          const SizedBox(height: 30),
          MarqueeOfferBar(offset: _marqueeOffset),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: CarouselSlider(
              controller: _carouselController,
              items: _carouselItems,
              currentIndex: _currentCarouselIndex,
              onPageChanged: (index) {
                setState(() {
                  _currentCarouselIndex = index;
                });
              },
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SectionTitle(title: 'Why Choose Us?'),
                const SizedBox(height: 30),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: _features.length,
                  itemBuilder: (context, index) {
                    return FeatureCard(feature: _features[index]);
                  },
                ),
                const SizedBox(height: 50),
                const CTASection(),
                const SizedBox(height: 40),
                const Footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const TopBar(),
          const SizedBox(height: 30),
          MarqueeOfferBar(offset: _marqueeOffset),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: CarouselSlider(
              controller: _carouselController,
              items: _carouselItems,
              currentIndex: _currentCarouselIndex,
              onPageChanged: (index) {
                setState(() {
                  _currentCarouselIndex = index;
                });
              },
            ),
          ),
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Column(
              children: [
                const SectionTitle(title: 'Why Choose Us?'),
                const SizedBox(height: 40),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: _features.length,
                  itemBuilder: (context, index) {
                    return FeatureCard(feature: _features[index]);
                  },
                ),
                const SizedBox(height: 60),
                const CTASection(),
                const SizedBox(height: 50),
                const Footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Responsive Layout Helper
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return mobile;
        } else if (constraints.maxWidth < 1200) {
          return tablet;
        } else {
          return desktop;
        }
      },
    );
  }
}

// Top Bar with Logo and Name
class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F2027), Color(0xFF203A43)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.medical_services,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 10),
              if (MediaQuery.of(context).size.width > 400) ...[
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HealthCheck',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F2027),
                      ),
                    ),
                    Text(
                      'Diagnostic Center',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                const Text(
                  'HealthCheck',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F2027),
                  ),
                ),
              ],
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.phone, color: Color(0xFF0F2027)),
                onPressed: () {},
              ),
              if (MediaQuery.of(context).size.width > 500)
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F2027),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text('Book Appointment'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// Moving Marquee Text for Offers
class MarqueeOfferBar extends StatefulWidget {
  final double offset;

  const MarqueeOfferBar({super.key, required this.offset});

  @override
  State<MarqueeOfferBar> createState() => _MarqueeOfferBarState();
}

class _MarqueeOfferBarState extends State<MarqueeOfferBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: const Color(0xFFFFF3E0),
      child: ClipRect(
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 50),
              left: widget.offset,
              // child: Container(
              child: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    _buildOfferItem(
                      '🎉 FLAT 25% OFF on Full Body Checkup',
                      Colors.orange,
                    ),
                    const SizedBox(width: 40),
                    _buildOfferItem(
                      '⭐ FREE Home Sample Collection',
                      Colors.green,
                    ),
                    const SizedBox(width: 40),
                    _buildOfferItem(
                      '💝 Get ₹200 OFF on First Test',
                      Colors.red,
                    ),
                    const SizedBox(width: 40),
                    _buildOfferItem(
                      '🏥 Senior Citizen Discount: 30% OFF',
                      Colors.blue,
                    ),
                    const SizedBox(width: 40),
                    _buildOfferItem('🚗 Free Report Delivery', Colors.purple),
                    const SizedBox(width: 40),
                    _buildOfferItem('🎯 Book 2 Tests Get 1 Free', Colors.pink),
                    const SizedBox(width: 40),
                    _buildOfferItem(
                      '🎉 FLAT 25% OFF on Full Body Checkup',
                      Colors.orange,
                    ),
                    const SizedBox(width: 40),
                    _buildOfferItem(
                      '⭐ FREE Home Sample Collection',
                      Colors.green,
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferItem(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Icon(Icons.local_offer, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// Carousel Item Model
class CarouselItem {
  final String title;
  final String description;
  final String imageUrl;
  final Gradient gradient;

  CarouselItem({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.gradient,
  });
}

// Carousel Slider Widget
class CarouselSlider extends StatelessWidget {
  final PageController controller;
  final List<CarouselItem> items;
  final int currentIndex;
  final Function(int) onPageChanged;

  const CarouselSlider({
    super.key,
    required this.controller,
    required this.items,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.width > 1200
              ? 400
              : MediaQuery.of(context).size.width > 600
              ? 350
              : 250,
          child: PageView.builder(
            controller: controller,
            onPageChanged: onPageChanged,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  gradient: items[index].gradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              items[index].title,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width > 600
                                    ? 28
                                    : 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              items[index].description,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width > 600
                                    ? 16
                                    : 12,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text('Book Test →'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Image.network(
                        items[index].imageUrl,
                        height: MediaQuery.of(context).size.width > 600
                            ? 150
                            : 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            items.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentIndex == index
                    ? const Color(0xFF0F2027)
                    : Colors.grey.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Section Title
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F2027),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

// Feature Item Model
class FeatureItem {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

// Feature Card
class FeatureCard extends StatelessWidget {
  final FeatureItem feature;

  const FeatureCard({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: feature.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(feature.icon, color: feature.color, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            feature.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F2027),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            feature.description,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Call to Action (CTA Section)
class CTASection extends StatelessWidget {
  const CTASection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            'Ready for a Healthier You?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Book your test today and get reports within 24 hours',
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0F2027),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Book Appointment Now →',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// Footer
class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 10,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.email, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    'care@healthcheck.com',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.phone, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text('1800-123-4567', style: TextStyle(color: Colors.grey)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.location_on, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    'Serving Pan India',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            '© 2024 HealthCheck Diagnostic Center. All rights reserved.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
