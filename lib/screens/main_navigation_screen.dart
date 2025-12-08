import 'package:flutter/material.dart';
import '../widgets/navigation/bottom_nav_bar.dart';
import 'home_screen.dart';
import 'appointments_screen.dart';
import 'results_screen.dart';
import 'profile_screen.dart';
import 'more_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  NavItem _currentIndex = NavItem.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getCurrentScreen(),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case NavItem.home:
        return const HomeScreen();
      case NavItem.appointments:
        return const AppointmentsScreen();
      case NavItem.results:
        return const ResultsScreen();
      case NavItem.profile:
        return const ProfileScreen();
      case NavItem.more:
        return const MoreScreen();
    }
  }

}


