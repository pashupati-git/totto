import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../common/appbar/common_app_bar.dart';

class PrivacyPolicyPage extends StatefulWidget
{
    const PrivacyPolicyPage({super.key});

    @override
    State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage>
{
    late TapGestureRecognizer _emailRecognizer;

    @override
    void initState()
    {
        super.initState();
        _emailRecognizer = TapGestureRecognizer()
            ..onTap = () => print('Open email client...');
    }

    @override
    void dispose()
    {
        _emailRecognizer.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true,
            appBar: CommonAppBar(
                height: 100.0,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                ),
                title: const Text(
                    'Privacy Policy',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                    ),
                ),
                actions: const[SizedBox(width: 60)],
            ),
            body: SingleChildScrollView(
                child: Column(
                    children: [

                        _buildHeaderWithImage(),

                        _buildContentSections(),
                    ],
                ),
            ),
        );
    }

    Widget _buildHeaderWithImage()
    {
        return SizedBox(
            height: 360,
            width: double.infinity,

            child: Stack(
                fit: StackFit.expand,
                children: [
                    Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFe34765),
                        ),
                    ),
                    Image.asset(
                        'assets/documentationbackground.png',
                        fit: BoxFit.cover,
                    ),

                    Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                const SizedBox(height: 125,),
                                const Text(
                                    'Privacy Policy – Totto App',
                                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                    'Effective Date: 2025 March 15\nLast Updated: 2024 March 10',
                                    style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                    'At Totto, your privacy is our priority. This Privacy Policy explains how we collect, use, and protect your information.',
                                    style: TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
                                ),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }

    Widget _buildContentSections()
    {
        return Container(
            color: Colors.white, // Solid white background for the main text
            padding: const EdgeInsets.all(24.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    _buildSectionTitle('1. Information We Collect'),
                    _buildParagraph('We may collect the following types of data:'),
                    _buildBulletedItem('Personal Information: Name, email, phone number, profile picture.'),
                    _buildBulletedItem('Business Information: Vendor name, product listings, transactions.'),
                    _buildBulletedItem('Device Data: IP address, device type, app usage data.'),
                    _buildBulletedItem('Location (Optional): For better vendor matching and delivery.'),

                    _buildSectionTitle('2. How We Use Your Information'),
                    _buildParagraph('We use your data to:'),
                    _buildBulletedItem('Create and manage your account.'),
                    _buildBulletedItem('Match you with vendors or buyers.'),
                    _buildBulletedItem('Process transactions and notifications.'),
                    _buildBulletedItem('Improve app features and user experience.'),
                    _buildBulletedItem('Ensure security and prevent fraud.'),

                    _buildSectionTitle('3. Data Sharing'),
                    _buildParagraph('We do not sell your data to third parties. We may share data with:'),
                    _buildBulletedItem('Service Providers (e.g., payment gateways, cloud services).'),
                    _buildBulletedItem('Legal Authorities, if required by law.'),
                    _buildBulletedItem('Other users (e.g., vendors or buyers) only when necessary to complete a transaction.'),

                    _buildSectionTitle('4. Your Privacy Choices'),
                    _buildParagraph('You can:'),
                    _buildBulletedItem('Edit or delete your profile at any time.'),
                    _buildBulletedItem('Opt out of marketing notifications.'),
                    _buildBulletedItem('Disable location access in device settings.'),

                    _buildSectionTitle('5. Security'),
                    _buildParagraph('We use encryption and secure servers to protect your information. However, no method is 100% secure, so we encourage strong passwords and safe sharing practices.'),

                    _buildSectionTitle('6. Children\'s Privacy'),
                    _buildParagraph('Totto is not intended for users under the age of 18. We do not knowingly collect data from children.'),

                    _buildSectionTitle('7. Changes to This Policy'),
                    _buildParagraph('We may update this Privacy Policy from time to time. We will notify you of significant changes through the app or email.'),

                    _buildSectionTitle('8. Contact Us'),
                    _buildRichTextParagraph(
                        TextSpan(
                            style: const TextStyle(color: Colors.black54, height: 1.5, fontSize: 15),
                            children: [
                                const TextSpan(text: 'If you have questions or requests regarding your data, contact: '),
                                TextSpan(
                                    text: 'privacy@tottoapp.com',
                                    style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                    recognizer: _emailRecognizer,
                                ),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }

    // --- Component-level Helper Widgets ---
    Widget _buildSectionTitle(String title)
    {
        return Padding(padding: const EdgeInsets.only(top: 24.0, bottom: 8.0), child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)));
    }
    Widget _buildParagraph(String text)
    {
        return Text(text, style: const TextStyle(color: Colors.black54, height: 1.5, fontSize: 15));
    }
    Widget _buildRichTextParagraph(TextSpan textSpan)
    {
        return Text.rich(textSpan, style: const TextStyle(color: Colors.black54, height: 1.5, fontSize: 15));
    }
    Widget _buildBulletedItem(String text)
    {
        return Padding(padding: const EdgeInsets.only(top: 8.0), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('•  ', style: TextStyle(color: Colors.black54, fontSize: 15)), Expanded(child: _buildParagraph(text))]));
    }
}
