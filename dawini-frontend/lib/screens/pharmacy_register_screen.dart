import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import 'auth_service.dart';
import 'location_picker_screen.dart';
import 'pharmacy_shell.dart';

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
    try {
      final response = await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _ownerNameController.text.trim(),
        role: 'pharmacy',
        language: 'fr',
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
        language: 'fr',
        phone: _phoneController.text.trim(),
      );

      await _authService.createPharmacyDetails(
        ownerId: user.id,
        name: _pharmacyNameController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? _ownerNameController.text.trim()
            : _addressController.text.trim(),
        licenseNumber: _licenseController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const PharmacyShell()),
        (route) => false,
      );
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
          child: Form(
            key: _formKey,
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
                    _inputLabel('Responsible Pharmacist'),
                    TextFormField(
                      controller: _ownerNameController,
                      validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
                      decoration: const InputDecoration(
                        hintText: 'Full Legal Name',
                        prefixIcon: Icon(Icons.person_outline, size: 20, color: AppColors.textLight),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _inputLabel('Pharmacy Name'),
                    TextFormField(
                      controller: _pharmacyNameController,
                      validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
                      decoration: const InputDecoration(hintText: 'e.g. LifeCare Central Pharmacy', prefixIcon: Icon(Icons.storefront_outlined, size: 20, color: AppColors.textLight)),
                    ),
                    const SizedBox(height: 16),
                    _inputLabel('License Number'),
                    TextFormField(
                      controller: _licenseController,
                      validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
                      decoration: const InputDecoration(hintText: 'PH-12345678', prefixIcon: Icon(Icons.card_membership_outlined, size: 20, color: AppColors.textLight)),
                    ),
                    const SizedBox(height: 16),
                    _inputLabel('Phone Number'),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
                      decoration: InputDecoration(hintText: '+1 (555) 000-0000', prefixIcon: Icon(Icons.phone_outlined, size: 20, color: AppColors.textLight)),
                    ),
                    const SizedBox(height: 24),

                    // Section Credentials
                    _sectionTitle('Credentials'),
                    _inputLabel('Professional Email'),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value == null || !value.contains('@') ? 'Invalid email' : null,
                      decoration: InputDecoration(hintText: 'pharmacy@example.com', prefixIcon: Icon(Icons.mail_outline, size: 20, color: AppColors.textLight)),
                    ),
                    const SizedBox(height: 16),
                    _inputLabel('Secure Password'),
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) => value == null || value.length < 6 ? 'Too short' : null,
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
                                      _selectedLat != null ? 'Change Location' : 'Set Pharmacy Location',
                                      style: const TextStyle(fontSize: 11, color: AppColors.textDark, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                                      child: Text(
                                        _selectedLat != null ? 'Edit' : 'Select',
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
                                  child: const Text('REQUIRED', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
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
                      decoration: InputDecoration(
                        hintText: 'Tap to select pharmacy location on map',
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
                            : const Text('Continue Registration', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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
