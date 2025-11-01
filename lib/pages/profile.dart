import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  String username = "Tinabitch";
  String email = "yanggaochristinalyn@gmail.com";
  String description =
      "Certified luka-luka sa books 📚!! Basta may slow-burn, found family, at masakit sa dibdib na love story?? G na g ako dyan 😜.\n\n"
      "Team #NoSleep pag may magandang plot twist 🚄💫\n\n"
      "Team #SanaAll pag loyal si ML kahit after 1892 years 👀\n\n"
      "Team #TigilMundo pag may confession scene 🥹💖\n\n"
      "Reading is life, charot pero totoo 😎 every book = bagong life, bagong kilig, bagong trauma 😅";

  File? _coverImage;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  bool isEditing = false;
  late AnimationController _animationController;
  late Box _profileBox;

  @override
  void initState() {
    super.initState();
    _initializeHive();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _initializeHive() async {
    _profileBox = await Hive.openBox('profileBox');

    // Load saved data if available
    setState(() {
      username = _profileBox.get('username', defaultValue: username);
      description = _profileBox.get('description', defaultValue: description);
      String? profilePath = _profileBox.get('profileImage');
      String? coverPath = _profileBox.get('coverImage');
      if (profilePath != null && File(profilePath).existsSync()) {
        _profileImage = File(profilePath);
      }
      if (coverPath != null && File(coverPath).existsSync()) {
        _coverImage = File(coverPath);
      }
      _usernameController.text = username;
      _descController.text = description;
    });
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
      description = _descController.text;
      isEditing = false;
    });

    // Save to Hive
    _profileBox.put('username', username);
    _profileBox.put('description', description);
    if (_profileImage != null) _profileBox.put('profileImage', _profileImage!.path);
    if (_coverImage != null) _profileBox.put('coverImage', _coverImage!.path);

    _animationController.reverse();
  }

  void _cancelEdit() {
    setState(() {
      _usernameController.text = username;
      _descController.text = description;
      isEditing = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1C1C1E),
              Color(0xFF121212),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
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

                  // ===== COVER + PROFILE =====
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
                                ImageFiltered(
                                  imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                  child: _coverImage != null
                                      ? Image.file(
                                    _coverImage!,
                                    fit: BoxFit.cover,
                                  )
                                      : Container(color: const Color(0xFF1C1C1E)),
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

                      // 👤 Profile Image
                      Positioned(
                        bottom: -55,
                        child: GestureDetector(
                          onTap: isEditing ? () => _pickImage(false) : null,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 4.5),
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
                                      : Container(
                                    width: 120,
                                    height: 120,
                                    color: const Color(0xFFB71C1C),
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
                                    child: Icon(Icons.edit, color: Colors.white, size: 16),
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
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
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
                              ),
                            )
                                : Text(
                              username,
                              key: const ValueKey('usernameText'),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB71C1C),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFB71C1C),
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
                              ),
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
                                      backgroundColor: const Color(0xFFB71C1C),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    child: const Text("Save",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _cancelEdit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    child: const Text("Cancel",
                                        style: TextStyle(color: Colors.white)),
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
                                      backgroundColor: const Color(0xFFB71C1C),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    child: const Text("Edit",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(context, '/');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFB71C1C),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    child: const Text("Log Out",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
