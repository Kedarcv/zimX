import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About Our Online Shopping App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome to our state-of-the-art online shopping application! Our app is designed to provide you with a seamless and enjoyable shopping experience right at your fingertips. With a wide range of products from various categories, user-friendly interface, and secure payment options, we aim to make your online shopping journey convenient and satisfying.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Key Features:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildFeatureItem('Extensive product catalog'),
            _buildFeatureItem('User-friendly search and filter options'),
            _buildFeatureItem('Secure payment gateways'),
            _buildFeatureItem('Order tracking and history'),
            _buildFeatureItem('Customer support'),
            const SizedBox(height: 32),
            const Text(
              'Meet Our Team',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTeamMember(
              'Michael Nkomo',
              'Lead Developer',
              'cvlised360@gmail.com',
              '@kedarcv',
            ),
            _buildTeamMember(
              'Munyaradzi Namailinga',
              'UI/UX Designer',
              '',
              '@namz',
            ),
            _buildTeamMember(
              'Neil Choeni',
              'Backend Developer',
              '',
              '@ndiya',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 8),
          Text(feature, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildTeamMember(
      String name, String role, String email, String social) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(role,
                style:
                    const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.email, size: 16),
                const SizedBox(width: 4),
                Text(email, style: const TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.link, size: 16),
                const SizedBox(width: 4),
                Text(social, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
