// lib/view/screens/user_flow/privacy_policy/privacy_policy_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue.shade700, Colors.blue.shade500],
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.privacy_tip_rounded,
                    size: 60,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your Privacy Matters',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last Updated: December 25, 2024',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Introduction
                  _buildIntroCard(),
                  const SizedBox(height: 20),

                  // Information We Collect
                  _buildSectionCard(
                    icon: Icons.info_outline_rounded,
                    title: 'Information We Collect',
                    color: Colors.blue.shade600,
                    children: [
                      _buildSubSection(
                        'Account Information',
                        'When you create an account, we collect:\n'
                            '• Full name\n'
                            '• Email address\n'
                            '• Gender (optional)\n'
                            '• Date of birth (optional)\n'
                            '• Profile picture (optional)',
                      ),
                      _buildSubSection(
                        'Usage Data',
                        'To improve your experience, we collect:\n'
                            '• Translation history\n'
                            '• Frequently used phrases\n'
                            '• Language preferences\n'
                            '• AI chat conversations\n'
                            '• App usage patterns',
                      ),
                      _buildSubSection(
                        'Device Information',
                        'We automatically collect:\n'
                            '• Device type and model\n'
                            '• Operating system version\n'
                            '• App version\n'
                            '• IP address\n'
                            '• Device identifiers',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // How We Use Your Information
                  _buildSectionCard(
                    icon: Icons.settings_outlined,
                    title: 'How We Use Your Information',
                    color: Colors.green.shade600,
                    children: [
                      _buildBulletPoint('Provide accurate language translations'),
                      _buildBulletPoint('Power AI-based chat translation features'),
                      _buildBulletPoint('Maintain your personal phrasebook'),
                      _buildBulletPoint('Improve translation accuracy and quality'),
                      _buildBulletPoint('Personalize your learning experience'),
                      _buildBulletPoint('Send important updates and notifications'),
                      _buildBulletPoint('Analyze app performance and fix bugs'),
                      _buildBulletPoint('Prevent fraud and ensure security'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Data Sharing
                  _buildSectionCard(
                    icon: Icons.share_outlined,
                    title: 'Data Sharing & Third Parties',
                    color: Colors.orange.shade600,
                    children: [
                      _buildSubSection(
                        'We DO NOT Sell Your Data',
                        'We will never sell your personal information to third parties.',
                      ),
                      _buildSubSection(
                        'Translation Services',
                        'Text submitted for translation may be processed by:\n'
                            '• Google Cloud Translation API\n'
                            '• OpenAI for AI chat features\n'
                            'These services process data according to their privacy policies.',
                      ),
                      _buildSubSection(
                        'Analytics Partners',
                        'We use analytics services to improve app performance:\n'
                            '• Firebase Analytics\n'
                            '• Crashlytics (for bug reports)\n'
                            'No personally identifiable information is shared.',
                      ),
                      _buildSubSection(
                        'Legal Requirements',
                        'We may disclose information when required by law or to:\n'
                            '• Comply with legal obligations\n'
                            '• Protect our rights and safety\n'
                            '• Prevent fraud or security issues',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Data Security
                  _buildSectionCard(
                    icon: Icons.security_rounded,
                    title: 'Data Security',
                    color: Colors.purple.shade600,
                    children: [
                      _buildBulletPoint('End-to-end encryption for sensitive data'),
                      _buildBulletPoint('Secure HTTPS connections'),
                      _buildBulletPoint('Regular security audits'),
                      _buildBulletPoint('Password hashing and protection'),
                      _buildBulletPoint('Secure cloud storage (Firebase)'),
                      _buildBulletPoint('Access controls and authentication'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Your Rights
                  _buildSectionCard(
                    icon: Icons.person_outline_rounded,
                    title: 'Your Rights & Choices',
                    color: Colors.teal.shade600,
                    children: [
                      _buildBulletPoint('Access your personal data anytime'),
                      _buildBulletPoint('Edit or update your profile information'),
                      _buildBulletPoint('Delete your translation history'),
                      _buildBulletPoint('Export your data in readable format'),
                      _buildBulletPoint('Opt-out of non-essential data collection'),
                      _buildBulletPoint('Delete your account permanently'),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.teal.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.email_outlined, color: Colors.teal.shade700, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'To exercise your rights, contact us at:\nsupport@helpmespeak.com',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.teal.shade900,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Data Retention
                  _buildSectionCard(
                    icon: Icons.history_rounded,
                    title: 'Data Retention',
                    color: Colors.indigo.shade600,
                    children: [
                      _buildSubSection(
                        'Account Data',
                        'We retain your account information as long as your account is active. When you delete your account, all personal data is permanently removed within 30 days.',
                      ),
                      _buildSubSection(
                        'Translation History',
                        'Translation history is stored locally on your device and in our secure cloud storage. You can delete this anytime from your profile settings.',
                      ),
                      _buildSubSection(
                        'AI Chat Logs',
                        'AI conversation logs are retained for 90 days to improve service quality, then automatically deleted unless saved by you.',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Children's Privacy
                  _buildSectionCard(
                    icon: Icons.child_care_rounded,
                    title: 'Children\'s Privacy',
                    color: Colors.pink.shade600,
                    children: [
                      _buildSubSection(
                        'Age Restriction',
                        'HelpMeSpeak is intended for users aged 13 and above. We do not knowingly collect data from children under 13. If you believe we have collected such data, please contact us immediately.',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // International Users
                  _buildSectionCard(
                    icon: Icons.public_rounded,
                    title: 'International Users',
                    color: Colors.cyan.shade600,
                    children: [
                      _buildSubSection(
                        'Global Service',
                        'HelpMeSpeak is available worldwide. Your data may be processed in different countries where our service providers operate. We ensure all data transfers comply with applicable privacy laws.',
                      ),
                      _buildSubSection(
                        'GDPR Compliance',
                        'For users in the European Union, we comply with GDPR requirements including data portability, right to be forgotten, and consent management.',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Changes to Policy
                  _buildSectionCard(
                    icon: Icons.update_rounded,
                    title: 'Changes to This Policy',
                    color: Colors.amber.shade700,
                    children: [
                      _buildSubSection(
                        '',
                        'We may update this Privacy Policy from time to time. We will notify you of significant changes via:\n'
                            '• Email notification\n'
                            '• In-app notification\n'
                            '• Update banner on app launch\n\n'
                            'Continued use of HelpMeSpeak after changes constitutes acceptance of the updated policy.',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Contact Section
                  _buildContactCard(),
                  const SizedBox(height: 30),

                  // Footer
                  Center(
                    child: Column(
                      children: [
                        Text(
                          '© 2025 HelpMeSpeak',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your trusted language companion',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.handshake_rounded, color: Colors.blue.shade700, size: 28),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Welcome to HelpMeSpeak',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'At HelpMeSpeak, we are committed to protecting your privacy and ensuring transparency about how we collect, use, and protect your personal information. This Privacy Policy explains our practices regarding data collection and usage for our language translation app.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'By using HelpMeSpeak, you agree to the terms outlined in this policy.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 8),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade800],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade300.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.contact_support_rounded,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(height: 12),
          const Text(
            'Need Help or Have Questions?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'re here to help! Contact us anytime:',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          _buildContactItem(Icons.email_rounded, 'support@helpmespeak.com'),
          const SizedBox(height: 8),
          _buildContactItem(Icons.language_rounded, 'help-me-speak.vercel.app'),
          const SizedBox(height: 8),
          _buildContactItem(Icons.location_on_rounded, 'Paris, France'),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}