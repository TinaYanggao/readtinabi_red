import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proj1/pages/mainTools.dart';
import 'forgot_password.dart';

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
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // -------------------- Logo --------------------
                const SizedBox(height: 20),
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [Color(0xFFB71C1C), Color(0xFF4A0D0D)],
                      radius: 0.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.menu_book_rounded,
                      size: 65, color: Colors.white),
                ),
                const SizedBox(height: 25),
                Text(
                  "Readn'Reflect",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 40),

                // -------------------- Toggle Buttons --------------------
                Container(
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    children: [
                      _buildToggleButton("LOG IN", true),
                      _buildToggleButton("SIGN UP", false),
                    ],
                  ),
                ),
                const SizedBox(height: 35),

                // -------------------- Forms --------------------
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: showLogin
                      ? _buildLoginForm(size)
                      : _buildSignUpForm(size),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------- Toggle Button --------------------
  Expanded _buildToggleButton(String text, bool login) {
    bool active = (login && showLogin) || (!login && !showLogin);
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => showLogin = login),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFB71C1C) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: active ? Colors.white : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  // -------------------- LOGIN FORM --------------------
  Widget _buildLoginForm(Size size) {
    return Column(
      key: const ValueKey("login"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome back 👋",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Log in to continue your reflection journey.",
          style: GoogleFonts.montserrat(
            color: Colors.white54,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 30),

        _customTextField("Email or Username", Icons.mail_outline),
        const SizedBox(height: 16),
        _customTextField("Password", Icons.lock_outline, obscure: true),

        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  activeColor: const Color(0xFFB71C1C),
                  onChanged: (val) => setState(() => isChecked = val!),
                ),
                const Text(
                  "Remember Me",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ForgotPassword()),
              ),
              child: const Text(
                "Forgot Password?",
                style: TextStyle(color: Color(0xFFB71C1C)),
              ),
            ),
          ],
        ),

        const SizedBox(height: 30),
        _customButton("LOG IN", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainTools()),
          );
        }),
      ],
    );
  }

  // -------------------- SIGN UP FORM --------------------
  Widget _buildSignUpForm(Size size) {
    return Column(
      key: const ValueKey("signup"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Create an Account ✨",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Join Readn’Reflect and begin your mindful journey.",
          style: GoogleFonts.montserrat(
            color: Colors.white54,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 30),

        _customTextField("Email", Icons.mail_outline),
        const SizedBox(height: 16),
        _customTextField("Username", Icons.person_outline),
        const SizedBox(height: 16),
        _customTextField("Password", Icons.lock_outline, obscure: true),
        const SizedBox(height: 16),
        _customTextField("Confirm Password", Icons.lock_outline, obscure: true),

        const SizedBox(height: 20),
        Row(
          children: [
            Checkbox(
              value: isChecked,
              activeColor: const Color(0xFFB71C1C),
              onChanged: (val) => setState(() => isChecked = val!),
            ),
            const Flexible(
              child: Text(
                "I agree to the Terms & Privacy Policy",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        _customButton("SIGN UP", () {}),
      ],
    );
  }

  // -------------------- INPUT FIELD --------------------
  Widget _customTextField(String hint, IconData icon,
      {bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFFB71C1C)),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF1C1C1E),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide:
          const BorderSide(color: Color(0xFFB71C1C), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide:
          const BorderSide(color: Colors.white24, width: 1.2),
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
          backgroundColor: const Color(0xFFB71C1C),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 8,
          shadowColor: Colors.redAccent.withOpacity(0.4),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
