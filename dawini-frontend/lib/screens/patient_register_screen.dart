import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../core/constants/app_colors.dart';
import 'patient_shell.dart';
import 'auth_service.dart';
import 'location_picker_screen.dart';
import '../core/services/location_service.dart';

class PatientRegisterScreen extends StatefulWidget {
  const PatientRegisterScreen({super.key});

  @override
  State<PatientRegisterScreen> createState() => _PatientRegisterScreenState();
}

class _PatientRegisterScreenState extends State<PatientRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _locationController = TextEditingController();
  final _authService = AuthService();
  final _locationService = LocationService();
  bool _agreeTerms = false;
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isFetchingLocation = false;
  String? _selectedGender;
  double? _selectedLat;
  double? _selectedLng;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _birthDateController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        _birthDateController.text = picked.toIso8601String().split('T').first;
      });
    }
  }

  Future<void> _fillCurrentLocation() async {
    setState(() => _isFetchingLocation = true);
    try {
      final locatedAddress = await _locationService.getCurrentAddress();
      if (!mounted) return;
      setState(() {
        _selectedLat = locatedAddress.latitude;
        _selectedLng = locatedAddress.longitude;
        _locationController.text = locatedAddress.displayName;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location detected successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isFetchingLocation = false);
      }
    }
  }

  Future<void> _openMapPicker() async {
    final result = await Navigator.push<LocationPickerResult>(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerScreen(
          initialLatitude: _selectedLat,
          initialLongitude: _selectedLng,
          initialAddress: _locationController.text.isNotEmpty ? _locationController.text : null,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedLat = result.latitude;
        _selectedLng = result.longitude;
        _locationController.text = result.address;
      });
    }
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must accept the terms of service')),
      );
      return;
    }

    if (!mounted) return;
    final locale = context.locale;
    final navigator = Navigator.of(context);

    setState(() => _isLoading = true);
    try {
      final response = await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _nameController.text.trim(),
        role: 'patient',
        language: locale.languageCode,
      );

      final user = response.user;
      if (user == null) {
        throw Exception('Account created but user session was not returned.');
      }

      await _authService.syncProfile(
        id: user.id,
        email: _emailController.text.trim(),
        fullName: _nameController.text.trim(),
        role: 'patient',
        language: locale.languageCode,
        phone: _phoneController.text.trim(),
      );

      await _authService.createPatientDetails(
        profileId: user.id,
        location: _locationController.text.trim(),
        birthDate: _birthDateController.text.trim(),
        gender: _selectedGender,
      );

      if (mounted) {
        await context.setLocale(locale);
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const PatientShell()),
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
        title: const Text('Dawini', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
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
                  'Patient Registration',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Join Dawini and take control of your healthcare journey with trust and precision.',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
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
                      _inputLabel('Full Name'),
                      TextFormField(
                        controller: _nameController,
                        validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
                        decoration: const InputDecoration(
                          hintText: 'John Doe',
                          prefixIcon: Icon(Icons.person_outline, color: AppColors.textLight, size: 20),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _inputLabel('Email Address'),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => value == null || !value.contains('@') ? 'Invalid email' : null,
                        decoration: const InputDecoration(
                          hintText: 'name@example.com',
                          prefixIcon: Icon(Icons.mail_outline, color: AppColors.textLight, size: 20),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _inputLabel('Phone Number'),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
                        decoration: const InputDecoration(
                          hintText: '+1 (555) 000-0000',
                          prefixIcon: Icon(Icons.phone_outlined, color: AppColors.textLight, size: 20),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _inputLabel('Password'),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        validator: (value) => value == null || value.length < 6 ? 'Too short' : null,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textLight, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: AppColors.textLight,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _inputLabel('Birth Date'),
                      TextFormField(
                        controller: _birthDateController,
                        readOnly: true,
                        onTap: _pickBirthDate,
                        validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
                        decoration: InputDecoration(
                          hintText: 'YYYY-MM-DD',
                          prefixIcon: const Icon(Icons.event_outlined, color: AppColors.textLight, size: 20),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_month_outlined, color: AppColors.primary, size: 20),
                            onPressed: _pickBirthDate,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _inputLabel('Gender'),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedGender,
                        items: const [
                          DropdownMenuItem(value: 'M', child: Text('Male')),
                          DropdownMenuItem(value: 'F', child: Text('Female')),
                        ],
                        onChanged: (value) => setState(() => _selectedGender = value),
                        validator: (value) => value == null ? 'Required field' : null,
                        decoration: const InputDecoration(
                          hintText: 'Select gender',
                          prefixIcon: Icon(Icons.wc_outlined, color: AppColors.textLight, size: 20),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _inputLabel('Location'),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _locationController,
                              readOnly: true,
                              onTap: _openMapPicker,
                              validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
                              decoration: InputDecoration(
                                hintText: 'Select your location',
                                prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.textLight, size: 20),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.open_in_new, color: AppColors.primary, size: 18),
                                  onPressed: _openMapPicker,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: _isFetchingLocation
                                  ? const SizedBox(
                                      width: 18, height: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Icon(Icons.my_location, color: Colors.white, size: 22),
                              onPressed: _isFetchingLocation ? null : _fillCurrentLocation,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _agreeTerms,
                              activeColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              onChanged: (val) {
                                setState(() {
                                  _agreeTerms = val ?? false;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'I agree to the Terms of Service and Privacy Policy.',
                              style: TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.4),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 24),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            elevation: 0,
                          ),
                          onPressed: _handleRegister,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Register', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account? ', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                          GestureDetector(
                            onTap: () {
                              Navigator.popUntil(context, (route) => route.isFirst);
                            },
                            child: const Text('Sign In', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shield_outlined, size: 14, color: AppColors.textLight),
                    SizedBox(width: 4),
                    Text('SECURE DATA', style: TextStyle(fontSize: 11, color: AppColors.textLight, fontWeight: FontWeight.bold)),
                    SizedBox(width: 24),
                    Icon(Icons.health_and_safety_outlined, size: 14, color: AppColors.textLight),
                    SizedBox(width: 4),
                    Text('HIPAA COMPLIANT', style: TextStyle(fontSize: 11, color: AppColors.textLight, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
    );
  }
}
