import 'package:presensi_mobile/l10n/hr_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:presensi_mobile/core/_core.dart';

class GoogleRegistrationDetails extends StatefulWidget {
  const GoogleRegistrationDetails({super.key});

  @override
  State<GoogleRegistrationDetails> createState() =>
      _GoogleRegistrationDetailsState();
}

class _GoogleRegistrationDetailsState extends State<GoogleRegistrationDetails> {
  final _form = GlobalKey<FormState>();
  final _phone = TextEditingController();
  bool _consent = false;
  bool _showConsentError = false;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HrText(
              'Lengkapi akun Pantoo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const HrText(
              'Nama dan email menggunakan akun Google Anda. Tambahkan nomor telepon untuk melanjutkan.',
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              autofillHints: const [AutofillHints.telephoneNumberNational],
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(15),
              ],
              decoration: InputDecoration(
                labelText: ('Nomor telepon').tr(context),
                hintText: ('08xxxxxxxxxx').tr(context),
              ),
              validator: (value) =>
                  RegExp(r'^\d{8,15}$').hasMatch(value?.trim() ?? '')
                  ? null
                  : 'Masukkan nomor telepon 8–15 digit.',
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: _consent,
              title: const HrText(
                'Saya menyetujui Kebijakan Privasi dan Ketentuan Layanan Pantoo.',
              ),
              onChanged: (value) => setState(() {
                _consent = value ?? false;
                _showConsentError = false;
              }),
            ),
            Wrap(
              children: [
                TextButton(
                  onPressed: () => AppUtility.launchLink(kUrlKebijakanPrivasi),
                  child: const HrText('Kebijakan Privasi'),
                ),
                TextButton(
                  onPressed: () => AppUtility.launchLink(
                    'https://app.pantoo.id/ketentuan-layanan',
                  ),
                  child: const HrText('Ketentuan Layanan'),
                ),
              ],
            ),
            if (_showConsentError)
              HrText(
                'Persetujuan diperlukan untuk membuat akun.',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                final valid = _form.currentState!.validate();
                setState(() => _showConsentError = !_consent);
                if (valid && _consent) {
                  Navigator.pop(context, _phone.text.trim());
                }
              },
              child: const HrText('Buat akun dan lanjutkan'),
            ),
          ],
        ),
      ),
    ),
  );
}
