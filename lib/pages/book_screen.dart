import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'newBook.dart';
import 'book_detail_screen.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  Box? bookBox;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    if (!Hive.isBoxOpen('books')) {
      await Hive.openBox('books');
    }
    setState(() {
      bookBox = Hive.box('books');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (bookBox == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D0D0D),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFE5203A)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),

      // 🔴 Floating Add Button (red glow aesthetic)
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE5203A), // pure red glow
              blurRadius: 18,
              spreadRadius: 3,
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFE5203A), // pure red
          elevation: 6,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NewBookScreen()),
            );
          },
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),

      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: bookBox!.listenable(),
          builder: (context, Box box, _) {
            if (box.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.menu_book, color: Colors.white30, size: 60),
                    const SizedBox(height: 12),
                    Text(
                      "No books yet — add one below!",
                      style: GoogleFonts.montserrat(
                        color: Colors.white54,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              );
            }

            // Group books by library
            Map<String, List> groupedBooks = {};
            for (int i = 0; i < box.length; i++) {
              final book = box.getAt(i);
              String library = book['library'] ?? "BEST RATED";
              groupedBooks.putIfAbsent(library, () => []);
              groupedBooks[library]!.add(book);
            }

            return ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 25),

                // Header Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Your Personal Library",
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Dive into stories that move you.",
                    style: GoogleFonts.montserrat(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Library Sections
                ...groupedBooks.entries.map((entry) {
                  String libraryName = entry.key;
                  List libraryBooks = entry.value;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section Header
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                libraryName.toUpperCase(),
                                style: GoogleFonts.playfairDisplay(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "See all",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white60,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Horizontal list of books
                        SizedBox(
                          height: 240,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: libraryBooks.length,
                            itemBuilder: (context, index) {
                              final book = libraryBooks[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          BookDetailScreen(book: book),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 150,
                                  margin: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF141414),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFE5203A)
                                            .withOpacity(0.15),
                                        blurRadius: 10,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Cover
                                      Container(
                                        height: 190,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(16),
                                          ),
                                          image: DecorationImage(
                                            image: (book['cover'] != null &&
                                                File(book['cover']).existsSync())
                                                ? FileImage(File(book['cover']))
                                                : const AssetImage(
                                              "assets/placeholder.jpg",
                                            ) as ImageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),

                                      // Title
                                      Expanded(
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 6),
                                            child: Text(
                                              book['title'] ?? "Untitled",
                                              style: GoogleFonts.montserrat(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }
}
