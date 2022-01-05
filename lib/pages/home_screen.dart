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
            onPressed: () => showDialog<bool>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Signing out'),
                content: const Text('Are you sure you want to sign out ?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.tealAccent)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Yes',
                        style: TextStyle(color: Colors.tealAccent)),
                  ),
                ],
              ),
            ).then((value) => {
                  if (value == true) {_signOut()}
                }),
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: _views[_selectedIndex],
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
