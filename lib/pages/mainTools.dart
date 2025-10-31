import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'book_screen.dart';
import 'watchlist.dart';
import 'profile.dart';
import 'notes.dart';
import 'weather_screen.dart';

class MainTools extends StatefulWidget {
  const MainTools({super.key});

  @override
  State<MainTools> createState() => _MainToolsState();
}

class _MainToolsState extends State<MainTools> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const BookScreen(),
    const WatchlistScreen(),
    const NotesScreen(),
    const WeatherScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeInOut,
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0D0D0D),
              Color(0xFF1A1A1A),
              Color(0xFF0D0D0D),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x66FF3B3B), // red glow
              blurRadius: 10,
              offset: Offset(0, -2),
              spreadRadius: 2,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: Color(0xFFFF3B3B), // red accent
          unselectedItemColor: Colors.white60,
          selectedLabelStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400,
            fontSize: 11,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_added_rounded),
              label: 'Watchlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_note_rounded),
              label: 'Journal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud_outlined),
              label: 'Weather',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
