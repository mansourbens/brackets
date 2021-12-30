import 'package:brackets/components/icons.dart';
import 'package:brackets/components/views/tournament_view.dart';
import 'package:brackets/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _views = [
    const TournamentView(),
    const Text('view 2'),
    const Text('view 3'),
    const Text('view 4'),
  ];
  void _signOut() {
    supabase.auth.signOut().then((value) => Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (route) => false));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brackets'),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: _views[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
      bottomNavigationBar: SizedBox(
        height: 76.0,
        child: BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          elevation: 4.0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(CustomIcons.trophy),
              label: 'Tournaments',
              backgroundColor: Colors.blueGrey.shade900,
            ),
            BottomNavigationBarItem(
              icon: const Icon(CustomIcons.users),
              label: 'Teams',
              backgroundColor: Colors.blueGrey.shade900,
            ),
            BottomNavigationBarItem(
              icon: const Icon(CustomIcons.id_card_alt),
              label: 'Players',
              backgroundColor: Colors.blueGrey.shade900,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.date_range),
              label: 'Matches',
              backgroundColor: Colors.blueGrey.shade900,
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.tealAccent,
        ),
      ),
    );
  }
}