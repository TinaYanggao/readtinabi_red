import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool rememberMe = false;
  bool obscureNew = true;
  bool obscureConfirm = true;

  final Color bgDark = const Color(0xFF121212);
  final Color surfaceDark = const Color(0xFF1C1C1E);
  final Color accent = const Color(0xFFB71C1C);

  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  Widget _inputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? toggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      obscuringCharacter: "●",
      style: GoogleFonts.montserrat(
        color: Colors.white,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: accent),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.white70,
          ),
          onPressed: toggle,
        )
            : null,
        labelText: label,
        labelStyle: GoogleFonts.montserrat(
          color: Colors.white60,
          fontSize: 15,
        ),
        floatingLabelStyle: TextStyle(
          color: accent,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: surfaceDark.withOpacity(0.6),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: accent, width: 1.8),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1C1C1E), Color(0xFF121212)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(color: Colors.black.withOpacity(0.25)),
          ),
          SafeArea(
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
                    "Reset Password",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "We’ll send you a verification code to reset your password.",
                    style: GoogleFonts.montserrat(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // Reworked Form
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 30),
                    decoration: BoxDecoration(
                      color: surfaceDark.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _inputField(
                          label: "Email Address",
                          icon: Icons.mail_outline,
                          controller: emailController,
                        ),
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            Expanded(
                              child: _inputField(
                                label: "Verification Code",
                                icon: Icons.vpn_key_rounded,
                                controller: codeController,
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 18, horizontal: 18),
                              ),
                              child: Text(
                                "Send",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        _inputField(
                          label: "New Password",
                          icon: Icons.lock_outline,
                          controller: newPassController,
                          isPassword: true,
                          obscureText: obscureNew,
                          toggle: () => setState(() {
                            obscureNew = !obscureNew;
                          }),
                        ),
                        const SizedBox(height: 25),
                        _inputField(
                          label: "Confirm Password",
                          icon: Icons.lock_open_rounded,
                          controller: confirmPassController,
                          isPassword: true,
                          obscureText: obscureConfirm,
                          toggle: () => setState(() {
                            obscureConfirm = !obscureConfirm;
                          }),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (v) =>
                                  setState(() => rememberMe = v!),
                              activeColor: accent,
                              checkColor: Colors.white,
                            ),
                            Text(
                              "Remember me",
                              style: GoogleFonts.montserrat(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  // Reset Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 8,
                        shadowColor: Colors.redAccent.withOpacity(0.5),
                      ),
                      child: Text(
                        "RESET PASSWORD",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Back to Login",
                      style: GoogleFonts.montserrat(
                        color: Colors.white70,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
