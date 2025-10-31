import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class BookDetailScreen extends StatefulWidget {
  final Map book;
  final VoidCallback onBack;

  const BookDetailScreen({
    super.key,
    required this.book,
    required this.onBack,
  });

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late Map book; // mutable copy of the book
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    // Create a copy of the book for safe editing
    book = Map.from(widget.book);
    _descriptionController = TextEditingController(text: book['description'] ?? '');
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _editComment() {
    showDialog(
      context: context,
      builder: (ctx) {
        final TextEditingController editController =
        TextEditingController(text: book['description'] ?? '');
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1C1E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Edit Comment",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: editController,
            maxLines: 5,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Write your thoughts about this book...",
              hintStyle: TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Color(0xFF121212),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () async {
                final box = Hive.box('books');
                // Update the local book map
                setState(() {
                  book['description'] = editController.text;
                  _descriptionController.text = editController.text;
                });

                // Find the key of the book in Hive
                final key = box.keys.firstWhere(
                      (k) => box.get(k) == widget.book,
                  orElse: () => null,
                );

                if (key != null) {
                  await box.put(key, book); // Save the updated book
                }

                Navigator.pop(ctx);
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Color(0xFFB71C1C)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Delete Book",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Are you sure you want to remove this book?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () async {
              final box = Hive.box('books');
              final key = box.keys.firstWhere(
                    (k) => box.get(k) == widget.book,
                orElse: () => null,
              );

              if (key != null) {
                await box.delete(key);
              }

              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Color(0xFFB71C1C)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Back Button + Optional Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFFB71C1C)),
                      onPressed: widget.onBack,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search all books...',
                          filled: true,
                          fillColor: const Color(0xFF1C1C1E),
                          prefixIcon: const Icon(Icons.search, color: Color(0xFFB71C1C)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: const TextStyle(color: Colors.white54),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              Container(height: 2, width: double.infinity, color: const Color(0xFFB71C1C)),
              const SizedBox(height: 12),

              // Book Image + Title + Author
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: book['cover'] != null
                              ? ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Image.file(
                              File(book['cover']),
                              width: 550,
                              height: 260,
                              fit: BoxFit.cover,
                            ),
                          )
                              : Container(
                            width: 550,
                            height: 260,
                            color: const Color(0xFF1C1C1E),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: book['cover'] != null
                              ? Image.file(
                            File(book['cover']),
                            width: 150,
                            height: 220,
                            fit: BoxFit.cover,
                          )
                              : const Icon(Icons.menu_book, size: 100, color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      book['title']?.toString().toUpperCase() ?? "UNTITLED",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    if (book['author'] != null)
                      Text(
                        book['author'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                  ],
                ),
              ),

              // Divider
              const SizedBox(height: 12),
              Container(height: 2, width: double.infinity, color: Color(0xFFB71C1C)),
              const SizedBox(height: 12),

              // Book Info Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Pages
                    Column(
                      children: [
                        const Icon(Icons.menu_book_rounded, color: Color(0xFFB71C1C)),
                        const SizedBox(height: 4),
                        Text('${book['pages'] ?? 0}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        const Text("Pages", style: TextStyle(color: Colors.white70)),
                      ],
                    ),

                    // Rating
                    Column(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < (book['rating'] ?? 0)
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              color: index < (book['rating'] ?? 0)
                                  ? const Color(0xFFB71C1C)
                                  : Colors.white24,
                              size: 24,
                            );
                          }),
                        ),
                        const SizedBox(height: 4),
                        const Text("My Rating", style: TextStyle(color: Colors.white70)),
                      ],
                    ),

                    // Language
                    Column(
                      children: [
                        const Icon(Icons.language, color: Color(0xFFB71C1C)),
                        const SizedBox(height: 4),
                        Text(book['language'] ?? "-",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.white)),
                        const Text("Language", style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ),

              // Divider
              const SizedBox(height: 12),
              Container(height: 2, width: double.infinity, color: Color(0xFFB71C1C)),
              const SizedBox(height: 12),

              // Buttons Row: Edit & Delete
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB71C1C),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                        ),
                        onPressed: _editComment,
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text(
                          "EDIT",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1C1C1E),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                        ),
                        onPressed: () => _confirmDelete(context),
                        icon: const Icon(Icons.delete, color: Colors.white),
                        label: const Text(
                          "DELETE",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              const SizedBox(height: 12),
              Container(height: 2, width: double.infinity, color: Color(0xFFB71C1C)),
              const SizedBox(height: 12),

              // Book Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _descriptionController.text,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
