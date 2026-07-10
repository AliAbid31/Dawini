import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:country_picker/country_picker.dart';
import '../core/constants/app_colors.dart';
import 'auth_service.dart';
import 'location_picker_screen.dart';
import 'pharmacy_shell.dart';
import 'custom_country_picker.dart';

class PharmacyRegisterScreen extends StatefulWidget {
  const PharmacyRegisterScreen({super.key});

  @override
  State<PharmacyRegisterScreen> createState() => _PharmacyRegisterScreenState();
}

class _PharmacyRegisterScreenState extends State<PharmacyRegisterScreen> {
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _pharmacyNameController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  double? _selectedLat;
  double? _selectedLng;
  Country _selectedCountry = CountryService().findByCode('DZ')!;

  @override
  void dispose() {
    _ownerNameController.dispose();
    _pharmacyNameController.dispose();
    _licenseController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _openMapPicker() async {
    final result = await Navigator.push<LocationPickerResult>(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerScreen(
          initialLatitude: _selectedLat,
          initialLongitude: _selectedLng,
          initialAddress: _addressController.text.isNotEmpty ? _addressController.text : null,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedLat = result.latitude;
        _selectedLng = result.longitude;
        _addressController.text = result.address;
      });
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final locale = context.locale.languageCode;
    try {
      final response = await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _ownerNameController.text.trim(),
        role: 'pharmacy',
        language: locale,
      );

      final user = response.user;
      if (user == null) {
        throw Exception('Account created but user session was not returned.');
      }

      await _authService.syncProfile(
        id: user.id,
        email: _emailController.text.trim(),
        fullName: _ownerNameController.text.trim(),
        role: 'pharmacy',
        language: locale,
        phone: '+${_selectedCountry.phoneCode}${_phoneController.text.trim()}',
      );

      await _authService.createPharmacyDetails(
        ownerId: user.id,
        name: _pharmacyNameController.text.trim(),
        address: _addressController.text.trim(),
        licenseNumber: _licenseController.text.trim(),
      );

      if (!mounted) return;
      
      if (response.session == null) {
        // Email confirmation is required
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
              title: Text('registration_successful'.tr()),
              content: Text('check_email_verify_pharmacy'.tr()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.popUntil(context, (route) => route.isFirst); // Go back to login
                },
                child: Text('ok'.tr()),
              ),
            ],
          ),
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const PharmacyShell()),
          (route) => false,
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

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
        title: Text('app_title'.tr(), style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              const SizedBox(height: 16),
              Text(
                'pharmacy_partner'.tr(),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const SizedBox(height: 8),
              Text(
                'pharmacy_partner_desc'.tr(),
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.4),
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
                  Text('1 ' + 'step_of'.tr() + ' 2', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary))
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
                    _sectionTitle('business_details'.tr()),
                    _inputLabel('responsible_pharmacist'.tr()),
                    TextFormField(
                      controller: _ownerNameController,
                      validator: (value) => value == null || value.isEmpty ? 'required_field'.tr() : null,
                      decoration: InputDecoration(
                        hintText: 'full_legal_name'.tr(),
                        prefixIcon: const Icon(Icons.person_outline, size: 20, color: AppColors.textLight),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _inputLabel('pharmacy_name'.tr()),
                    TextFormField(
                      controller: _pharmacyNameController,
                      validator: (value) => value == null || value.isEmpty ? 'required_field'.tr() : null,
                      decoration: InputDecoration(hintText: 'pharmacy_name_hint'.tr(), prefixIcon: const Icon(Icons.storefront_outlined, size: 20, color: AppColors.textLight)),
                    ),
                    const SizedBox(height: 16),
                    _inputLabel('license_number'.tr()),
                    TextFormField(
                      controller: _licenseController,
                      validator: (value) => value == null || value.isEmpty ? 'required_field'.tr() : null,
                      decoration: const InputDecoration(hintText: 'PH-12345678', prefixIcon: Icon(Icons.card_membership_outlined, size: 20, color: AppColors.textLight)),
                    ),
                    const SizedBox(height: 16),
                    _inputLabel('phone_number'.tr()),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showCustomCountryPicker(
                              context: context,
                              onSelect: (country) => setState(() => _selectedCountry = country),
                            );
                          },
                          child: Container(
                            height: 46,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_selectedCountry.flagEmoji, style: const TextStyle(fontSize: 18)),
                                const SizedBox(width: 4),
                                Text('+${_selectedCountry.phoneCode}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                const Icon(Icons.arrow_drop_down, color: AppColors.textLight, size: 18),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value) => value == null || value.isEmpty ? 'required_field'.tr() : null,
                            decoration: const InputDecoration(
                              hintText: '000-0000',
                              prefixIcon: Icon(Icons.phone_outlined, size: 20, color: AppColors.textLight),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Section Credentials
                    _sectionTitle('credentials'.tr()),
                    _inputLabel('professional_email'.tr()),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value == null || !value.contains('@') ? 'enter_valid_email'.tr() : null,
                      decoration: const InputDecoration(hintText: 'pharmacy@example.com', prefixIcon: Icon(Icons.mail_outline, size: 20, color: AppColors.textLight)),
                    ),
                    const SizedBox(height: 16),
                    _inputLabel('secure_password'.tr()),
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) => value == null || value.length < 6 ? 'password_min_length'.tr() : null,
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
                    _sectionTitle('location'.tr()),
                    GestureDetector(
                      onTap: _openMapPicker,
                      child: Container(
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          image: _selectedLat != null && _selectedLng != null
                              ? DecorationImage(
                                  image: NetworkImage(
                                    'https://tile.openstreetmap.org/static/'
                                    '$_selectedLng,$_selectedLat,15/400x160.png',
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          color: const Color(0xFFF1F5F9),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppColors.primary.withValues(alpha: _selectedLat != null ? 1.0 : 0.4),
                              size: 40,
                            ),
                            Positioned(
                              bottom: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10)],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _selectedLat != null ? Icons.edit_location : Icons.map_outlined,
                                      size: 14, color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _selectedLat != null ? 'change_location'.tr() : 'set_pharmacy_location'.tr(),
                                      style: const TextStyle(fontSize: 11, color: AppColors.textDark, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                                      child: Text(
                                        _selectedLat != null ? 'edit'.tr() : 'select'.tr(),
                                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            if (_selectedLat == null)
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text('required'.tr(), style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _addressController,
                      readOnly: true,
                      onTap: _openMapPicker,
                      validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
                      decoration: InputDecoration(
                        hintText: 'select_location_map_hint'.tr(),
                        prefixIcon: const Icon(Icons.location_city_outlined, color: AppColors.textLight, size: 20),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.open_in_new, color: AppColors.primary, size: 18),
                          onPressed: _openMapPicker,
                        ),
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
                        onPressed: _isLoading ? null : _handleRegister,
                        child: _isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Text('continue_registration'.tr(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('already_account'.tr(), style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        GestureDetector(
                          onTap: () {
                            Navigator.popUntil(context, (route) => route.isFirst);
                          },
                          child: Text('log_in'.tr(), style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const SizedBox(height: 24),
              Text(
                'terms_agreement_text'.tr(),
                style: const TextStyle(fontSize: 10, color: AppColors.textLight, height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ],
          ),
        ),
      ),
    ));
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
}
