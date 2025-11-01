import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proj1/pages/mainTools.dart';
import 'forgot_password.dart';

// -------------------- COLOR PALETTE --------------------
class AppColors {
  static const Color primary = Color(0xFFB71C1C); // deep red
  static const Color primaryDark = Color(0xFF4A0D0D);
  static const Color background = Color(0xFF121212);
  static const Color card = Color(0xFF1C1C1E);
  static const Color inputFill = Color(0xFF2A2A2C);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color hintText = Colors.white54;
  static const Color buttonShadow = Colors.redAccent;
}

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool showLogin = true;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // -------------------- Logo --------------------
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                      center: Alignment.center,
                      radius: 0.85,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.buttonShadow.withOpacity(0.4),
                        blurRadius: 25,
                        spreadRadius: 3,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.menu_book_rounded,
                      color: Colors.white.withOpacity(0.95),
                      size: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // -------------------- Card Container --------------------
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        showLogin ? "Log In" : "Sign Up",
                        style: GoogleFonts.montserrat(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      // -------------------- Form Fields --------------------
                      if (!showLogin)
                        _customTextField("First Name", Icons.person_outline),
                      if (!showLogin) const SizedBox(height: 16),
                      if (!showLogin)
                        _customTextField("Last Name", Icons.person_outline),
                      if (!showLogin) const SizedBox(height: 16),
                      _customTextField("Email", Icons.mail_outline),
                      const SizedBox(height: 16),
                      _customTextField("Password", Icons.lock_outline,
                          obscure: true),
                      if (!showLogin) const SizedBox(height: 16),
                      if (!showLogin)
                        _customTextField("Confirm Password", Icons.lock_outline,
                            obscure: true),
                      if (showLogin) const SizedBox(height: 10),

                      if (showLogin)
                        Row(
                          children: [
                            Checkbox(
                              value: isChecked,
                              activeColor: AppColors.primary,
                              checkColor: AppColors.textPrimary,
                              onChanged: (val) =>
                                  setState(() => isChecked = val!),
                            ),
                            Text(
                              "Remember me",
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ForgotPasswordFlow()),
                              ),
                              child: Text(
                                "Forgot password?",
                                style: TextStyle(color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 20),

                      // -------------------- Submit Button --------------------
                      _customButton(showLogin ? "Log In" : "Sign Up", () {
                        if (showLogin) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainTools()),
                          );
                        } else {
                          // Sign Up action
                        }
                      }),

                      const SizedBox(height: 10),

                      // -------------------- Toggle Text --------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            showLogin
                                ? "Don't have an account? "
                                : "Already have an account? ",
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() => showLogin = !showLogin);
                            },
                            child: Text(
                              showLogin ? "Sign Up" : "Sign In",
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------- INPUT FIELD --------------------
  Widget _customTextField(String hint, IconData icon,
      {bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      style: TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.primary),
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.hintText),
        filled: true,
        fillColor: AppColors.inputFill,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.transparent, width: 1.2),
        ),
      ),
    );
  }

  // -------------------- BUTTON --------------------
  Widget _customButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          shadowColor: AppColors.buttonShadow.withOpacity(0.4),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
