import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  final List<OnboardingItem> _pages = [
    OnboardingItem(
      title: 'Online Randevu Sistemi',
      description: 'Dilediğiniz zaman, dilediğiniz yerden kolayca randevu alın',
      image: 'assets/images/appointment.png', // Bu görseli eklemeyi unutmayın
      color: Colors.blue.shade100,
      icon: Icons.calendar_today,
    ),
    OnboardingItem(
      title: 'Uzman Diş Hekimleri',
      description: 'Alanında uzman diş hekimlerimizle kaliteli hizmet',
      image: 'assets/images/dentist.png', // Bu görseli eklemeyi unutmayın
      color: Colors.purple.shade100,
      icon: Icons.medical_services,
    ),
    OnboardingItem(
      title: 'Modern Teknoloji',
      description:
          'En son teknoloji ile donatılmış kliniklerimizde konforlu tedavi',
      image: 'assets/images/technology.png', // Bu görseli eklemeyi unutmayın
      color: Colors.green.shade100,
      icon: Icons.biotech,
    ),
    OnboardingItem(
      title: 'Başlayalım!',
      description: 'Sağlıklı gülüşler için hemen randevu alın',
      image: 'assets/images/start.png', // Bu görseli eklemeyi unutmayın
      color: Colors.orange.shade100,
      icon: Icons.star,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView.builder(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == _pages.length - 1;
            });
          },
          itemCount: _pages.length,
          itemBuilder: (context, index) {
            return OnboardingPageWidget(item: _pages[index]);
          },
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Skip button
            TextButton(
              onPressed: () => _controller.jumpToPage(_pages.length - 1),
              child: const Text('Geç'),
            ),
            // Dot indicators
            Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: _pages.length,
                effect: WormEffect(
                  spacing: 16,
                  dotColor: Colors.black26,
                  activeDotColor: Colors.blue.shade600,
                ),
                onDotClicked: (index) => _controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                ),
              ),
            ),
            // Next or Start button
            TextButton(
              onPressed: () {
                if (isLastPage) {
                  Navigator.pushReplacementNamed(context, '/login');
                } else {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Text(isLastPage ? 'Başla' : 'İleri'),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final String image;
  final Color color;
  final IconData icon;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
    required this.color,
    required this.icon,
  });
}

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPageWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: item.color,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Icon
            Icon(
              item.icon,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            // Image
            Image.asset(
              item.image,
              height: 240,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 40),
            // Title
            Text(
              item.title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                item.description,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
