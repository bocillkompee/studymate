import 'package:flutter/material.dart';

import '../../services/app_state.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/auth_scaffold.dart';
import '../../widgets/demo_banner.dart';

class RegisterResult {
  const RegisterResult({required this.name, required this.email});

  final String name;
  final String email;
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmation = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) {
      return 'Nama lengkap wajib diisi.';
    }
    if (name.length < 2) {
      return 'Nama minimal 2 karakter.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Email wajib diisi.';
    }
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailPattern.hasMatch(email)) {
      return 'Masukkan email yang valid.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kata sandi wajib diisi.';
    }
    if (value.length < 6) {
      return 'Kata sandi minimal 6 karakter.';
    }
    return null;
  }

  String? _validateConfirmation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi kata sandi wajib diisi.';
    }
    if (value != _passwordController.text) {
      return 'Konfirmasi kata sandi tidak cocok.';
    }
    return null;
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    FocusScope.of(context).unfocus();

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    // TODO(API): ganti pencatatan demo dengan AuthService.register.
    AppScope.of(context).rememberDemoAccount(name: name, email: email);

    Navigator.of(context).pop(RegisterResult(name: name, email: email));
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Buat akun StudyMate',
      subtitle:
          'Isi data berikut untuk menyiapkan ruang belajar dan daftar tugasmu.',
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppTextField(
              label: 'Nama lengkap',
              hint: 'Contoh: Rani Prameswari',
              controller: _nameController,
              prefixIcon: Icons.person_outline_rounded,
              textInputAction: TextInputAction.next,
              autofillHints: const <String>[AutofillHints.name],
              textCapitalization: TextCapitalization.words,
              validator: _validateName,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Email',
              hint: 'nama@sekolah.id',
              controller: _emailController,
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const <String>[AutofillHints.email],
              validator: _validateEmail,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Kata sandi',
              hint: 'Minimal 6 karakter',
              controller: _passwordController,
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              autofillHints: const <String>[AutofillHints.newPassword],
              validator: _validatePassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
                tooltip: _obscurePassword
                    ? 'Tampilkan kata sandi'
                    : 'Sembunyikan kata sandi',
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Konfirmasi kata sandi',
              hint: 'Ulangi kata sandi',
              controller: _confirmPasswordController,
              prefixIcon: Icons.lock_reset_rounded,
              obscureText: _obscureConfirmation,
              textInputAction: TextInputAction.done,
              validator: _validateConfirmation,
              onFieldSubmitted: (_) => _submit(),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() => _obscureConfirmation = !_obscureConfirmation);
                },
                tooltip: _obscureConfirmation
                    ? 'Tampilkan konfirmasi kata sandi'
                    : 'Sembunyikan konfirmasi kata sandi',
                icon: Icon(
                  _obscureConfirmation
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submit,
                child: const Text('Buat akun'),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const DemoBanner(
              message:
                  'Mode demo: pendaftaran hanya mengingat nama untuk sesi ini dan belum mengirim data ke server.',
            ),
          ],
        ),
      ),
      footer: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          Text(
            'Sudah punya akun?',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Masuk'),
          ),
        ],
      ),
    );
  }
}
