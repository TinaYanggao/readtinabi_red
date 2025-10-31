import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class NewBookScreen extends StatefulWidget {
  const NewBookScreen({super.key});

  @override
  State<NewBookScreen> createState() => _NewBookScreenState();
}

class _NewBookScreenState extends State<NewBookScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController pagesController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  int rating = 0;
  File? _cover;

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _cover = File(pickedFile.path);
      });
    }
  }

  void _saveBook() {
    final bookBox = Hive.box('books');

    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title cannot be empty")),
      );
      return;
    }

    bookBox.add({
      'title': titleController.text.trim(),
      'author': authorController.text.trim(),
      'genre': genreController.text.trim(),
      'language': languageController.text.trim(),
      'pages': pagesController.text.trim(),
      'description': descriptionController.text.trim(),
      'rating': rating,
      'cover': _cover?.path,
    });

    Navigator.pop(context);
  }

  void _deleteInputs() {
    setState(() {
      titleController.clear();
      authorController.clear();
      genreController.clear();
      languageController.clear();
      pagesController.clear();
      descriptionController.clear();
      rating = 0;
      _cover = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon:
                    const Icon(Icons.arrow_back_ios, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    "NEW BOOK",
                    style: GoogleFonts.playfairDisplay(
                      color: const Color(0xFFB71C1C),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 25),

              // --- COVER IMAGE PICKER ---
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 210,
                    width: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFB71C1C),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFB71C1C).withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: _cover == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_photo_alternate_outlined,
                            size: 45, color: Colors.white54),
                        const SizedBox(height: 8),
                        Text(
                          "Add Cover",
                          style: GoogleFonts.montserrat(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(
                        _cover!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // --- FORM BOX ---
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFB71C1C).withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTextField(
                      controller: titleController,
                      label: "Title",
                      icon: Icons.title,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: authorController,
                      label: "Author",
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: genreController,
                      label: "Genre",
                      icon: Icons.category_outlined,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: languageController,
                      label: "Language",
                      icon: Icons.language,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: pagesController,
                      label: "Pages",
                      icon: Icons.menu_book_rounded,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),

                    // --- RATE IT ---
                    Row(
                      children: [
                        Text(
                          "Rate it:",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Row(
                          children: List.generate(5, (index) {
                            return IconButton(
                              onPressed: () {
                                setState(() {
                                  rating = index + 1;
                                });
                              },
                              icon: Icon(
                                Icons.star_rounded,
                                color: index < rating
                                    ? const Color(0xFFB71C1C)
                                    : Colors.white24,
                                size: 30,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // --- COMMENT / DESCRIPTION ---
                    TextField(
                      controller: descriptionController,
                      maxLines: 5,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Write your thoughts about this book...",
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.black26,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFB71C1C),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- SAVE & DELETE BUTTONS ---
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveBook,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB71C1C),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "SAVE",
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _deleteInputs,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "DELETE",
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFFB71C1C)),
        labelText: label,
        labelStyle: GoogleFonts.montserrat(color: Colors.white70),
        filled: true,
        fillColor: Colors.black26,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFB71C1C)),
          borderRadius: BorderRadius.circular(12),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
