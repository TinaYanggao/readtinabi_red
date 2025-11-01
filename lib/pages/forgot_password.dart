import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordFlow extends StatefulWidget {
  const ForgotPasswordFlow({super.key});

  @override
  State<ForgotPasswordFlow> createState() => _ForgotPasswordFlowState();
}

class _ForgotPasswordFlowState extends State<ForgotPasswordFlow> {
  int step = 0; // 0: Email, 1: Verification, 2: Reset Password

  final Color bgDark = const Color(0xFF121212);
  final Color surfaceDark = const Color(0xFF1C1C1E);
  final Color accent = const Color(0xFFB71C1C);

  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  bool obscureNew = true;
  bool obscureConfirm = true;

  Widget _inputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? toggle,
    bool centerText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      obscuringCharacter: "●",
      textAlign: centerText ? TextAlign.center : TextAlign.start,
      style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        prefixIcon: isPassword ? Icon(icon, color: accent) : null,
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.white70,
          ),
          onPressed: toggle,
        )
            : null,
        labelText: isPassword ? label : null,
        hintText: !isPassword ? label : null,
        hintStyle: GoogleFonts.montserrat(color: Colors.white60),
        filled: true,
        fillColor: surfaceDark.withOpacity(0.6),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: accent, width: 1.8),
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
      ),
    );
  }

  Widget _actionButton(String text, VoidCallback onPressed, {Color? color}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? accent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          shadowColor: Colors.redAccent.withOpacity(0.5),
        ),
        child: Text(
          text.toUpperCase(),
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (step) {
      case 0: // Email
        return Column(
          children: [
            _inputField(
              label: "Enter your email",
              icon: Icons.mail_outline,
              controller: emailController,
            ),
            const SizedBox(height: 25),
            _actionButton("Recover Password", () => setState(() => step = 1)),
          ],
        );

      case 1: // Verification Code
        return Column(
          children: [
            Text(
              "Check your phone",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "We've sent the code to your email/phone.",
              style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 60,
                  child: _inputField(
                    label: "",
                    icon: Icons.vpn_key_rounded,
                    controller: codeController,
                    centerText: true,
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            _actionButton("Verify", () => setState(() => step = 2)),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: Text(
                "Send again",
                style: GoogleFonts.montserrat(color: Colors.white70),
              ),
            ),
          ],
        );

      case 2: // Reset Password
        return Column(
          children: [
            _inputField(
              label: "New Password",
              icon: Icons.lock_outline,
              controller: newPassController,
              isPassword: true,
              obscureText: obscureNew,
              toggle: () => setState(() => obscureNew = !obscureNew),
            ),
            const SizedBox(height: 20),
            _inputField(
              label: "Confirm Password",
              icon: Icons.lock_open_rounded,
              controller: confirmPassController,
              isPassword: true,
              obscureText: obscureConfirm,
              toggle: () => setState(() => obscureConfirm = !obscureConfirm),
            ),
            const SizedBox(height: 25),
            _actionButton("Done", () => Navigator.pop(context)),
          ],
        );

      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [Color(0xFFB71C1C), Color(0xFF4A0D0D)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.4),
                      blurRadius: 25,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: const Icon(Icons.lock_reset_rounded,
                    color: Colors.white, size: 55),
              ),
              const SizedBox(height: 25),
              Text(
                step == 0
                    ? "Password Recovery"
                    : step == 1
                    ? "Verification Code"
                    : "Reset Password",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              _buildStepContent(),
              const SizedBox(height: 25),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Back to Login",
                  style: GoogleFonts.montserrat(
                    color: Colors.white70,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
