import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart'; // main app navigation
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  String username = "tinabitch"; // default username
  String email = "tinabi@gmail.com"; // default email
  String description =
      "Certified luka-luka sa books 📚!! Basta may slow-burn, found family, at masakit sa dibdib na love story?? G na g ako dyan 😜.";

  File? _coverImage;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  bool isEditing = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _usernameController.text = username;
    _emailController.text = email;
    _descController.text = description;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isCover) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (isCover) {
          _coverImage = File(picked.path);
        } else {
          _profileImage = File(picked.path);
        }
      });
    }
  }

  void _saveProfile() {
    setState(() {
      username = _usernameController.text;
      email = _emailController.text;
      description = _descController.text;
      isEditing = false;
    });
    _animationController.reverse();
  }

  void _cancelEdit() {
    setState(() {
      _usernameController.text = username;
      _emailController.text = email;
      _descController.text = description;
      isEditing = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      const Text(
                        "PROFILE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // ===== COVER + PROFILE IMAGE STACK =====
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          GestureDetector(
                            onTap: isEditing ? () => _pickImage(true) : null,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(24),
                                bottomRight: Radius.circular(24),
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                height: 230,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    _coverImage != null
                                        ? Image.file(
                                      _coverImage!,
                                      fit: BoxFit.cover,
                                    )
                                        : Container(
                                      color: const Color(0xFF1C1C1E),
                                    ),
                                    if (isEditing)
                                      const Positioned(
                                        right: 12,
                                        bottom: 12,
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.black54,
                                          child: Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -55,
                            child: GestureDetector(
                              onTap: isEditing ? () => _pickImage(false) : null,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 4.5),
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: _profileImage != null
                                          ? Image.file(
                                        _profileImage!,
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      )
                                          : Image.asset(
                                        "assets/profile.jpg",
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  if (isEditing)
                                    const Positioned(
                                      right: 6,
                                      bottom: 6,
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Color(0xFFB71C1C),
                                        child: Icon(Icons.edit,
                                            color: Colors.white, size: 16),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 70),

                      // ===== PROFILE CARD =====
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 22),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C1C1E),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: isEditing
                                    ? TextField(
                                  key: const ValueKey('usernameField'),
                                  controller: _usernameController,
                                  decoration: const InputDecoration(
                                    labelText: "Username",
                                    border: OutlineInputBorder(),
                                    labelStyle:
                                    TextStyle(color: Colors.white70),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white38),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFB71C1C),
                                          width: 2),
                                    ),
                                  ),
                                  style: const TextStyle(
                                      color: Colors.white),
                                )
                                    : Text(
                                  username,
                                  key: const ValueKey('usernameText'),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: isEditing
                                    ? TextField(
                                  key: const ValueKey('emailField'),
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    labelText: "Email",
                                    border: OutlineInputBorder(),
                                    labelStyle:
                                    TextStyle(color: Colors.white70),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white38),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFB71C1C),
                                          width: 2),
                                    ),
                                  ),
                                  style: const TextStyle(
                                      color: Colors.white),
                                )
                                    : Text(
                                  email,
                                  key: const ValueKey('emailText'),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                              const Divider(height: 25, color: Colors.white24),
                              AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                child: isEditing
                                    ? TextField(
                                  key: const ValueKey('descField'),
                                  controller: _descController,
                                  maxLines: 8,
                                  decoration: const InputDecoration(
                                    labelText: "Description",
                                    border: OutlineInputBorder(),
                                    labelStyle:
                                    TextStyle(color: Colors.white70),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white38),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFB71C1C),
                                          width: 2),
                                    ),
                                  ),
                                  style: const TextStyle(
                                      color: Colors.white),
                                )
                                    : Text(
                                  description,
                                  key: const ValueKey('descText'),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),

                              // ===== Buttons =====
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: isEditing
                                    ? Row(
                                  key: const ValueKey('editButtons'),
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: _saveProfile,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          const Color(0xFFB71C1C),
                                          padding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(24),
                                          ),
                                        ),
                                        child: const Text("Save",
                                            style: TextStyle(
                                                color: Colors.white)),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: _cancelEdit,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey,
                                          padding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(24),
                                          ),
                                        ),
                                        child: const Text("Cancel",
                                            style: TextStyle(
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                )
                                    : Row(
                                  key: const ValueKey('viewButtons'),
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            isEditing = true;
                                          });
                                          _animationController.forward();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          const Color(0xFFB71C1C),
                                          padding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(24),
                                          ),
                                        ),
                                        child: const Text("Edit",
                                            style: TextStyle(
                                                color: Colors.white)),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context, '/');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          const Color(0xFFB71C1C),
                                          padding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(24),
                                          ),
                                        ),
                                        child: const Text("Log Out",
                                            style: TextStyle(
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
