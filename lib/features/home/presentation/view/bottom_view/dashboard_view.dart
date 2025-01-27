import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  // int _selectedIndex = 0;
  // List<Widget> lstBottomScreen = [
  //   const HomeScreen(),
  //   const WishList(),
  //   const NotificationScreen(),
  //   const ProfileScreen(),
  // ];

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        // body: lstBottomScreen[_selectedIndex],
        // bottomNavigationBar: BottomNavigationBar(
        //     type: BottomNavigationBarType.fixed,
        //     selectedItemColor: Colors.green,
        //     unselectedItemColor: Colors.grey,
        //     items: const [
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.home),
        //         label: 'Home',
        //       ),
        //       BottomNavigationBarItem(
        //           icon: Icon(Icons.bookmark), label: "WishList"),
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.notifications),
        //         label: 'Notifications',
        //       ),
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.account_circle),
        //         label: 'Profile',
        //       ),
        //     ],
        //     currentIndex: _selectedIndex,
        //     onTap: (index) {
        //       setState(() {
        //         _selectedIndex = index;
        //       });
        //     }),
        );
  }
}
