import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_healthcare/frontend/practioner_interface/prac_homescreen.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class PractionerFee extends StatelessWidget {
  // Assume we pass the organization name (or ID) here for display
  final String organizationName;
  const PractionerFee({super.key, required this.organizationName});

  final double feeAmount = 10.00;
  final String currency = 'USD';

  @override
  Widget build(BuildContext context) {
    // In a real application, you would use form controllers for card details
    // For this example, we use placeholder fields for UI demonstration.

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Complete Membership",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // --- 💳 Payment Summary Card ---
            _buildSummaryCard(context, organizationName, feeAmount, currency),

            const SizedBox(height: 30),

            // --- 🔒 Payment Details Section Title ---
            const Text(
              "Payment Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textColorPrimary,
              ),
            ),
            const SizedBox(height: 15),

            // --- 💳 Card Number Input ---
            _buildTextField(
              label: "Card Number",
              hint: "XXXX XXXX XXXX XXXX",
              icon: Icons.credit_card_outlined,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),

            // --- Expiry Date & CVV (Side-by-Side) ---
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: "Expiry Date (MM/YY)",
                    hint: "01/25",
                    icon: Icons.calendar_today_outlined,
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildTextField(
                    label: "CVV",
                    hint: "123",
                    icon: Icons.lock_outline,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // --- Cardholder Name Input ---
            _buildTextField(
              label: "Cardholder Name",
              hint: "Jane Doe",
              icon: Icons.person_outline,
              keyboardType: TextInputType.text,
            ),

            const SizedBox(height: 50),

            // --- 💰 Pay Button ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement payment gateway integration (Stripe, PayPal, etc.)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PracHomescreen()),
                  );

                  Get.snackbar(
                    // ignore: deprecated_member_use
                    backgroundColor: Colors.white.withOpacity(0.7),
                    "Payment......",
                    "Payment procesing for Practioner",
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.accent, // A strong color for payment
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Pay \$${feeAmount.toStringAsFixed(2)} and Join",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "Secure payment powered by [Payment Provider]",
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textColorSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build the payment summary card
  Widget _buildSummaryCard(
    BuildContext context,
    String orgName,
    double amount,
    String currency,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primary.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Organization Membership Fee",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textColorPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "for: **$orgName**",
            style: TextStyle(fontSize: 14, color: AppColors.textColorSecondary),
          ),
          const Divider(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Amount Due:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColorPrimary,
                ),
              ),
              Text(
                "$currency ${amount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method for clean and consistent text fields
  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return TextField(
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textColorPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: AppColors.primary.withOpacity(0.7)),
        labelStyle: TextStyle(color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.stripedColor,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary, width: 2.0),
        ),
      ),
    );
  }
}

// Example usage of the screen (assuming 'AppColors' is defined elsewhere):
/*
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const PractionerFee(
      organizationName: "TechCorp Global",
    ),
  ),
);
*/
