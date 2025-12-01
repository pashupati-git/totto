import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:totto/features/profile/privacy_policy_page.dart';

import '../../common/appbar/common_app_bar.dart';

class TermsAndConditionsPage extends StatefulWidget
{
    const TermsAndConditionsPage({super.key});

    @override
    State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage>
{
    // Recognizers are needed for tappable text spans.
    // They must be disposed to prevent memory leaks, which is why we use a StatefulWidget.
    late TapGestureRecognizer _privacyPolicyRecognizer;
    late TapGestureRecognizer _emailRecognizer;

    @override
    void initState()
    {
        super.initState();
        _privacyPolicyRecognizer = TapGestureRecognizer()
            ..onTap = ()
        {
            print('Navigate to Privacy Policy Page...');
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PrivacyPolicyPage(),
                ),
            );
        };
        _emailRecognizer = TapGestureRecognizer()
            ..onTap = ()
        {
            print('Open email client...');
        };
    }

    @override
    void dispose()
    {
        _privacyPolicyRecognizer.dispose();
        _emailRecognizer.dispose();
        super.dispose();
    }

    // Main Build Method
    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true,
            appBar: CommonAppBar(
                height: 100.0, // You can customize the height here
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                ),
                title: const Text(
                    'Terms And Conditions',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                    ),
                ),
                // This spacer balances the leading IconButton, keeping the title perfectly centered.
                actions: const[SizedBox(width: 56)],
            ),
            body: SingleChildScrollView(
                child: Column(
                    children: [
                        // The Red Header Block
                        _buildHeaderWithImage(),

                        // The Main Content Sections
                        Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    _buildSectionTitle('1. Acceptance of Terms'),
                                    _buildParagraph(
                                        'By creating an account or using Totto, you agree to be bound by these Terms and our Privacy Policy. If you do not agree, please do not use the platform.'),

                                    _buildSectionTitle('2. Eligibility'),
                                    _buildParagraph(
                                        'You must be at least 18 years old to use Totto. By registering, you confirm that all information provided is accurate and complete.'),

                                    _buildSectionTitle('3. Account Responsibilities'),
                                    _buildParagraph('You are responsible for:'),
                                    _buildBulletedItem('Maintaining the confidentiality of your login credentials.'),
                                    _buildBulletedItem('All activities that occur under your account.'),
                                    _buildBulletedItem('Not impersonating others or providing false information.'),

                                    _buildSectionTitle('4. Use of Services'),
                                    _buildParagraph('Totto provides a platform for:'),
                                    _buildBulletedItem('Vendors to list and sell verified, rare goods.'),
                                    _buildBulletedItem('Buyers to discover and request such goods from vendors.'),
                                    _buildSubHeader('Users agree not to:'),
                                    _buildBulletedItem('Use Totto for illegal or unauthorized transactions.'),
                                    _buildBulletedItem('Post misleading, harmful, or prohibited content.'),
                                    _buildBulletedItem('Attempt to interfere with the app\'s functionality or security.'),

                                    _buildSectionTitle('5. Order Terms'),
                                    _buildBulletedItem('All transactions are between buyers and vendors directly.'),
                                    _buildBulletedItem('Totto is not responsible for product quality, delivery delays, or disputes unless stated otherwise.'),
                                    _buildBulletedItem('Each order must meet minimum requirements as set by the vendor.'),

                                    _buildSectionTitle('6. Fees & Payments'),
                                    _buildParagraph(
                                        'Totto may charge service or platform fees in certain cases. All applicable fees will be transparently disclosed during transactions.'),

                                    _buildSectionTitle('7. Privacy & Data'),
                                    _buildRichTextParagraph(
                                        // Using Text.rich for the tappable link
                                        TextSpan(
                                            style: const TextStyle(color: Colors.black54, height: 1.5, fontSize: 15),
                                            children: [
                                                const TextSpan(text: 'Your data is handled according to our '),
                                                TextSpan(
                                                    text: '[Privacy Policy]',
                                                    style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                                    recognizer: _privacyPolicyRecognizer,
                                                ),
                                                const TextSpan(text: '. We collect only what is necessary to operate the platform and connect users meaningfully.'),
                                            ],
                                        ),
                                    ),

                                    _buildSectionTitle('8. Termination'),
                                    _buildParagraph('Totto reserves the right to suspend or terminate accounts that:'),
                                    _buildBulletedItem('Violate these Terms.'),
                                    _buildBulletedItem('Engage in fraudulent or abusive behavior.'),
                                    _buildBulletedItem('Harm the experience or safety of others on the platform.'),

                                    _buildSectionTitle('9. Changes to Terms'),
                                    _buildParagraph(
                                        'Totto may update these Terms occasionally. Continued use of the app after updates constitutes acceptance of the new Terms.'),

                                    _buildSectionTitle('10. Contact Us'),
                                    _buildRichTextParagraph(
                                        TextSpan(
                                            style: const TextStyle(color: Colors.black54, height: 1.5, fontSize: 15),
                                            children: [
                                                const TextSpan(text: 'If you have any questions or concerns about these Terms, contact us at: '),
                                                TextSpan(
                                                    text: 'support@tottoapp.com',
                                                    style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                                    recognizer: _emailRecognizer,
                                                ),
                                            ],
                                        ),
                                    ),
                                ],
                            ),
                        ),
                    ],
                ),
            ),
        );
    }

    // Helper Widgets for Cleaner Code

    Widget _buildHeaderWithImage()
    {
        return SizedBox(
            height: 400,
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
                                const SizedBox(height: 125),
                                const Text(
                                    'Totto - Terms and Conditions',
                                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                    'Effective Date: 2025 March 15\nLast Updated: 2024 March 10',
                                    style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                    'Welcome to Totto. By using our app and services, you agree to the following terms and conditions. Please read them carefully.',
                                    style: TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
                                ),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }

    Widget _buildSectionTitle(String title)
    {
        return Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
            child: Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
        );
    }

    Widget _buildSubHeader(String title)
    {
        return Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
        );
    }

    Widget _buildParagraph(String text)
    {
        return Text(
            text,
            style: const TextStyle(color: Colors.black54, height: 1.5, fontSize: 15),
        );
    }

    Widget _buildRichTextParagraph(TextSpan textSpan)
    {
        return Text.rich(
            textSpan,
            style: const TextStyle(color: Colors.black54, height: 1.5, fontSize: 15),
        );
    }

    Widget _buildBulletedItem(String text)
    {
        return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    const Text('•  ', style: TextStyle(color: Colors.black54, fontSize: 15)),
                    Expanded(child: _buildParagraph(text)),
                ],
            ),
        );
    }
}
