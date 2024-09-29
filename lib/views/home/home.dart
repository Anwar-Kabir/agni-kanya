import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:woman_safety/controllers/sos_history_controller.dart';
import 'package:woman_safety/views/history/history.dart';
import 'package:woman_safety/views/mapview_page/map_view_page.dart';
import 'package:woman_safety/views/police_station/police_sation.dart';
import 'package:woman_safety/views/profile/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const PoliceStationPage(),
    const HistoryPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    if(index==2){
      final data=Get.put(SosHistoryController());
      data.getHitory();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: _widgetOptions,
          ),
          Positioned(
            left: 20, // Horizontal position of the navigation bar
            right: 20,
            bottom: 30, // Vertical position of the navigation bar
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BottomNavigationBar(
                backgroundColor: Colors.black.withOpacity(0.8),
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Column(
                      children: [
                        Icon(
                          Icons.home,
                          color:
                              _selectedIndex == 0 ? Colors.yellow : Colors.grey,
                        ),
                        if (_selectedIndex == 0)
                          Container(
                            width: 5,
                            height: 5,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow,
                            ),
                          ),
                      ],
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Column(
                      children: [
                        Icon(
                          Icons.local_police,
                          color:
                              _selectedIndex == 1 ? Colors.yellow : Colors.grey,
                        ),
                        if (_selectedIndex == 1)
                          Container(
                            width: 5,
                            height: 5,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow,
                            ),
                          ),
                      ],
                    ),
                    label: 'P. Station',
                  ),
                  BottomNavigationBarItem(
                    icon: Column(
                      children: [
                        Icon(
                          Icons.history,
                          color:
                              _selectedIndex == 2 ? Colors.yellow : Colors.grey,
                        ),
                        if (_selectedIndex == 2)
                          Container(
                            width: 5,
                            height: 5,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow,
                            ),
                          ),
                      ],
                    ),
                    label: 'History',
                  ),
                  BottomNavigationBarItem(
                    icon: Column(
                      children: [
                        Icon(
                          Icons.person,
                          color:
                              _selectedIndex == 3 ? Colors.yellow : Colors.grey,
                        ),
                        if (_selectedIndex == 3)
                          Container(
                            width: 5,
                            height: 5,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow,
                            ),
                          ),
                      ],
                    ),
                    label: 'Profile',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.yellow,
                unselectedItemColor: Colors.grey,
                onTap: _onItemTapped,
                showSelectedLabels: true,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}




