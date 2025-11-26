import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _pageIndex = 0;

  final List<_OnboardingData> pages = [
    _OnboardingData(
      title: "Never Forget What's in Your Fridge",
      description:
      "Track everything inside your fridge with ease — stay organized and reduce waste.",
      icon: Icons.kitchen_outlined,
    ),
    _OnboardingData(
      title: "Scan or Add Items Instantly",
      description:
      "Use QR/Barcode scanning or manual input to add items quickly and accurately.",
      icon: Icons.qr_code_scanner,
    ),
    _OnboardingData(
      title: "Smart Expiry Reminders",
      description:
      "Get reminders before items expire — choose when and how often to be notified.",
      icon: Icons.notifications_active_outlined,
    ),
    _OnboardingData(
      title: "Share Your Fridge with Your Household",
      description:
      "Create or join a household to manage the same fridge together.",
      icon: Icons.group_outlined,
    ),
  ];

  void next() {
    if (_pageIndex < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (_pageIndex < pages.length - 1)
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text("Skip"),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) => setState(() => _pageIndex = index),
              itemCount: pages.length,
              itemBuilder: (context, index) {
                final page = pages[index];

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            page.icon,
                            size: 120,
                            color:
                            isDark ? Colors.white70 : Colors.blue,
                          ),
                          const SizedBox(height: 40),
                          Text(
                            page.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            page.description,
                            textAlign: TextAlign.center,
                            style:
                            Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // DOTS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pages.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin:
                const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                width: _pageIndex == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _pageIndex == index
                      ? (isDark ? Colors.white : Colors.blue)
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // BUTTON
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ElevatedButton(
                onPressed: next,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  _pageIndex == pages.length - 1 ? "Get Started" : "Next",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingData {
  final String title;
  final String description;
  final IconData icon;

  const _OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
  });
}
