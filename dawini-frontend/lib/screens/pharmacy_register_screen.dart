import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PharmacyRegisterScreen extends StatefulWidget {
  const PharmacyRegisterScreen({super.key});

  @override
  State<PharmacyRegisterScreen> createState() => _PharmacyRegisterScreenState();
}

class _PharmacyRegisterScreenState extends State<PharmacyRegisterScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Dawini', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.backpack_outlined, color: AppColors.primary),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Pharmacy Partner',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const SizedBox(height: 8),
              const Text(
                'Join our network of certified pharmacies and provide essential care to patients in your area.',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.4),
              ),
              const SizedBox(height: 24),

              // Barre de progression étape 1/2
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: const LinearProgressIndicator(
                        value: 0.5,
                        backgroundColor: Color(0xFFE2E8F0),
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        minHeight: 4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('1 of 2', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary))
                ],
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Section Business Details
                    _sectionTitle('Business Details'),
                    _inputLabel('Pharmacy Name'),
                    const TextField(
                      decoration: InputDecoration(hintText: 'e.g. LifeCare Central Pharmacy', prefixIcon: Icon(Icons.storefront_outlined, size: 20, color: AppColors.textLight)),
                    ),
                    const SizedBox(height: 16),
                    _inputLabel('Responsible Pharmacist'),
                    const TextField(
                      decoration: InputDecoration(hintText: 'Full Legal Name', prefixIcon: Icon(Icons.person_outline, size: 20, color: AppColors.textLight)),
                    ),
                    const SizedBox(height: 16),
                    _inputLabel('License Number'),
                    const TextField(
                      decoration: InputDecoration(hintText: 'PH-12345678', prefixIcon: Icon(Icons.card_membership_outlined, size: 20, color: AppColors.textLight)),
                    ),
                    const SizedBox(height: 16),
                    _inputLabel('Phone Number'),
                    const TextField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(hintText: '+1 (555) 000-0000', prefixIcon: Icon(Icons.phone_outlined, size: 20, color: AppColors.textLight)),
                    ),
                    const SizedBox(height: 24),

                    // Section Credentials
                    _sectionTitle('Credentials'),
                    _inputLabel('Professional Email'),
                    const TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(hintText: 'pharmacy@example.com', prefixIcon: Icon(Icons.mail_outline, size: 20, color: AppColors.textLight)),
                    ),
                    const SizedBox(height: 16),
                    _inputLabel('Secure Password'),
                    TextField(
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        prefixIcon: const Icon(Icons.lock_outline, size: 20, color: AppColors.textLight),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppColors.textLight, size: 20),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Section Map / Location Selector
                    _sectionTitle('Location'),
                    Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        image: const DecorationImage(
                          image: NetworkImage('https://i.imgur.com/39QOskD.png'), // Illustration générique de carte
                          fit: BoxFit.cover,
                          opacity: 0.3,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(Icons.location_on, color: AppColors.primary, size: 40),
                          Positioned(
                            bottom: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
                              child: Row(
                                children: [
                                  const Icon(Icons.my_location, size: 14, color: AppColors.primary),
                                  const SizedBox(width: 6),
                                  const Text('Set Pharmacy Address', style: TextStyle(fontSize: 10, color: AppColors.textDark, fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                                    child: const Text('Select', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Bouton Suivant
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          elevation: 0,
                        ),
                        onPressed: () {},
                        child: const Text('Continue Registration', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? ', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        GestureDetector(
                          onTap: () {
                            Navigator.popUntil(context, (route) => route.isFirst);
                          },
                          child: const Text('Log in', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Certification Footers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _badgeIcon(Icons.shield_outlined, 'HIPAA COMPLIANT'),
                  _badgeIcon(Icons.gpp_good_outlined, '256-BIT AES'),
                  _badgeIcon(Icons.verified_outlined, 'VERIFIED DOCS'),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'By joining Dawini, you agree to our Terms of Service and Privacy Policy.',
                style: TextStyle(fontSize: 10, color: AppColors.textLight, height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
          const Divider(color: Color(0xFFE2E8F0), thickness: 1),
        ],
      ),
    );
  }

  Widget _inputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark)),
    );
  }

  static Widget _badgeIcon(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.textLight),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 9, color: AppColors.textLight, fontWeight: FontWeight.bold)),
      ],
    );
  }
}