import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/note_model.dart';
import 'newNote.dart';
import 'package:share_plus/share_plus.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String query = "";

  void _openNoteDetail(Note note, int index) async {
    final editedNote = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NoteEditor(note: note)),
    );

    if (editedNote != null) {
      note.title = editedNote.title;
      note.content = editedNote.content;
      note.date = editedNote.date;
      note.save();
      setState(() {});
    }
  }

  void _addNewNote() async {
    final newNote = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteEditor(
          note: Note(
            title: "UNTITLED",
            content: "",
            date: DateTime.now(),
          ),
          isNew: true,
        ),
      ),
    );
    if (newNote != null) {
      Hive.box<Note>('notes').add(newNote);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final notesBox = Hive.box<Note>('notes');

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: ValueListenableBuilder(
        valueListenable: notesBox.listenable(),
        builder: (context, Box<Note> box, _) {
          final allNotes = box.values.toList();

          final notes = allNotes.where((note) {
            final lowerQuery = query.toLowerCase();
            return note.title.toLowerCase().contains(lowerQuery) ||
                note.content.toLowerCase().contains(lowerQuery);
          }).toList()
            ..sort((a, b) {
              if (a.isPinned && !b.isPinned) return -1;
              if (!a.isPinned && b.isPinned) return 1;
              return b.date.compareTo(a.date);
            });

          return SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),

                // --- Aesthetic Header: Divider + Red "Journal" + Divider ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    children: [
                      Container(height: 1.5, color: Colors.white24),
                      const SizedBox(height: 12),
                      const Center(
                        child: Text(
                          "Journal",
                          style: TextStyle(
                            color: Color(0xFFE5203A), // red font
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(height: 1.5, color: Colors.white24),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        query = val;
                      });
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search notes...",
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      filled: true,
                      fillColor: const Color(0xFF1C1C1E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Notes Grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      itemCount: notes.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return GestureDetector(
                          onTap: () => _openNoteDetail(note, index),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C1C1E),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.redAccent.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    note.content.length > 80
                                        ? "${note.content.substring(0, 80)}..."
                                        : note.content,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${note.date.toLocal().toString().split(' ')[0]}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFE5203A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),

      floatingActionButton: GestureDetector(
        onTap: _addNewNote,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFE5203A),
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
