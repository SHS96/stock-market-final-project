import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/bottom_nav.dart';

class ProPage extends StatelessWidget {
  const ProPage({super.key});

  Widget _featureItem({
    required String iconPath,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF171A2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF2B2630),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgPicture.asset(
              iconPath,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            'assets/icons/pro_check_gold.svg',
            width: 22,
            height: 22,
          ),
        ],
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF171A2E),
          title: const Text(
            'Payment Successful',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Welcome to Aster Markets Pro. Your premium features are now available.',
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1177FF),
              ),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aster Markets Pro'),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF2B2630),
                  Color(0xFF171A2E),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFFD8B15C).withOpacity(0.45),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.workspace_premium,
                  color: Color(0xFFD8B15C),
                  size: 42,
                ),
                const SizedBox(height: 18),
                const Text(
                  'Unlock institutional-grade data',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Get deeper market insights, advanced analysis and premium tools.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '€9.99 / month',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Cancel anytime',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'What is included',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          _featureItem(
            iconPath: 'assets/icons/pro_feature_1.svg',
            title: 'Advanced Market Data',
            subtitle: 'Access deeper market and company information.',
          ),

          _featureItem(
            iconPath: 'assets/icons/pro_feature_2.svg',
            title: 'Smart Alerts',
            subtitle: 'Receive alerts for price changes and market events.',
          ),

          _featureItem(
            iconPath: 'assets/icons/pro_feature_3.svg',
            title: 'Portfolio Insights',
            subtitle: 'View detailed portfolio performance analysis.',
          ),

          _featureItem(
            iconPath: 'assets/icons/pro_feature_4.svg',
            title: 'Premium News',
            subtitle: 'Read selected market news and investment updates.',
          ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () => _showPurchaseDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1177FF),
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Upgrade to Pro',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Demo payment only — no real payment is processed.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF171A2E),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Project Team',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 18),

                Text(
                  'Haisheng Sun  |  33016756',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Flutter Development & Web Integration',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                SizedBox(height: 14),

                Text(
                  'Xiaowei Li  |  31703926',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Figma Design & UI Assets',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                SizedBox(height: 14),

                Text(
                  'Kritika Chaudhary  |  29418304',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Responsive Web Layout & Testing',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                SizedBox(height: 14),

                Text(
                  'Basir Ahmad Mehrzad  |  74089841',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'API, Search, Currency & Chart Functions',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}