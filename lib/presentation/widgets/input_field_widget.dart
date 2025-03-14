import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final String fieldKey;
  final Map<String, dynamic> formData;
  final bool isNumber;
  final bool isDouble;
  final bool isRequired;

  const InputField({
    Key? key,
    required this.label,
    required this.fieldKey,
    required this.formData,
    this.isNumber = false,
    this.isDouble = false,
    this.isRequired = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔥 Label input
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),

        // 🔥 Input Field
        TextFormField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
          keyboardType: isNumber || isDouble
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,

          // 🔥 Simpan nilai setelah pengguna mengetik
          onSaved: (value) {
            if (isNumber) {
              formData[fieldKey] = int.tryParse(value ?? '') ?? 0; // ✅ Pastikan tidak NaN
            } else if (isDouble) {
              formData[fieldKey] = double.tryParse(value ?? '') ?? 0.0; // ✅ Pastikan tidak NaN
            } else {
              formData[fieldKey] = value ?? "";
            }

            // ✅ Debugging: Lihat nilai sebelum disimpan
            print("📌 Data tersimpan: $fieldKey = ${formData[fieldKey]} (${formData[fieldKey].runtimeType})");
          },

          // 🔥 Validasi input
          validator: (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return '$label wajib diisi';
            }
            if (isNumber && int.tryParse(value ?? '') == null) {
              return '$label harus berupa angka';
            }
            if (isDouble && double.tryParse(value ?? '') == null) {
              return '$label harus berupa angka desimal';
            }
            return null;
          },
        ),
      ],
    );
  }
}
