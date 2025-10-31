import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class BookDetailScreen extends StatelessWidget {
  final Map book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1D38),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1D38),
        elevation: 0,
        centerTitle: true,
        title: Text(
          book['library'] ?? "Book",
          style: const TextStyle(
            color: Color(0xFFFFD369),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ===== Book Cover =====
            Container(
              height: 230,
              width: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: book['cover'] != null
                    ? DecorationImage(
                  image: FileImage(File(book['cover'])),
                  fit: BoxFit.cover,
                )
                    : null,
                color: const Color(0xFF162C55),
              ),
              child: book['cover'] == null
                  ? const Center(
                child: Icon(Icons.menu_book,
                    size: 80, color: Colors.white54),
              )
                  : null,
            ),

            const SizedBox(height: 16),

            // ===== Title & Author =====
            Text(
              (book['title'] ?? "UNTITLED").toString().toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (book['author'] != null)
              Text(
                book['author'],
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),

            const SizedBox(height: 24),

            // ===== Description Card =====
            Expanded(
              child: Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: const BoxDecoration(
                  color: Color(0xFF162C55),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "BOOK DETAILS",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      book['description'] ?? "No description available.",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),

                    const Spacer(),

                    // ===== Buttons =====
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F1D38),
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            onPressed: () => _confirmDelete(context),
                            icon: const Icon(Icons.delete, color: Colors.white),
                            label: const Text(
                              "DELETE",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFD369),
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            onPressed: () {
                              // TODO: implement edit logic
                            },
                            icon: const Icon(Icons.edit, color: Colors.black),
                            label: const Text(
                              "EDIT",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F1D38),
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
                    (k) => box.get(k) == book,
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
              style: TextStyle(color: Color(0xFFFFD369)),
            ),
          ),
        ],
      ),
    );
  }
}
