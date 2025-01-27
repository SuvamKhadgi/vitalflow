import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitalflow/core/common/snackbar/my_snackbar.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_cubit.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Logout code
              showMySnackBar(
                context: context,
                message: 'Logging out...',
                color: Colors.red,
              );

              context.read<HomeCubit>().logout(context);
            },
          ),
          // Switch(
          //   value: _isDarkTheme,
          //   onChanged: (value) {
          //     // Change theme
          //     // setState(() {
          //     //   _isDarkTheme = value;
          //     // });
          //   },
          // ),
        ],
      ),
      body:
          // SafeArea(
          //   child: SizedBox(
          //     height: double.infinity,

          //     child: SingleChildScrollView(
          //       child: Padding(
          //         padding: const EdgeInsets.all(16.0),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: <Widget>[
          //             // Search Bar
          //             Padding(
          //               padding: const EdgeInsets.only(bottom: 16.0),
          //               child: TextField(
          //                 controller: _searchController,
          //                 decoration: InputDecoration(
          //                   hintText: 'Search...',
          //                   prefixIcon: const Icon(Icons.search),
          //                   filled: true,
          //                   fillColor: Colors.white,
          //                   border: OutlineInputBorder(
          //                     borderRadius: BorderRadius.circular(30),
          //                     borderSide: BorderSide.none,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             // Welcome Message
          //             const Text(
          //               "Welcome, User!",
          //               style: TextStyle(
          //                 fontSize: 28,
          //                 fontWeight: FontWeight.bold,
          //                 color: Colors.white,
          //               ),
          //             ),
          //             const SizedBox(height: 5),
          //             const Text(
          //               "Here's an overview of your activities:",
          //               style: TextStyle(
          //                 fontSize: 16,
          //                 color: Colors.white70,
          //               ),
          //             ),
          //             const SizedBox(height: 20),

          //             // Card 1 (Full-width)
          //             SizedBox(
          //               width: double.infinity, // Ensures full width of screen
          //               child: Card(
          //                 elevation: 5,
          //                 shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(15),
          //                 ),
          //                 child: const Padding(
          //                   padding: EdgeInsets.all(16.0),
          //                   child: Column(
          //                     children: [
          //                       Text(
          //                         "Card",
          //                         style: TextStyle(
          //                           fontSize: 20,
          //                           fontWeight: FontWeight.bold,
          //                         ),
          //                       ),
          //                       SizedBox(height: 10),
          //                       Text(
          //                         "item 1",
          //                         style: TextStyle(fontSize: 16),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             const SizedBox(height: 20),

          //             // Card 2 (Full-width)
          //             SizedBox(
          //               width: double.infinity, // Ensures full width of screen
          //               child: Card(
          //                 elevation: 5,
          //                 shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(15),
          //                 ),
          //                 child: const Padding(
          //                   padding: EdgeInsets.all(16.0),
          //                   child: Column(
          //                     children: [
          //                       Text(
          //                         "Card",
          //                         style: TextStyle(
          //                           fontSize: 20,
          //                           fontWeight: FontWeight.bold,
          //                         ),
          //                       ),
          //                       SizedBox(height: 10),
          //                       Text(
          //                         "item 2",
          //                         style: TextStyle(fontSize: 16),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             const SizedBox(height: 20),

          //             // Add more cards or widgets as needed
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
        return state.views.elementAt(state.selectedIndex);
      }),
      bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Product',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.heart_broken),
                label: 'Wishlist',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Account',
              ),
            ],
            currentIndex: state.selectedIndex,
            selectedItemColor: Colors.white,
            onTap: (index) {
              context.read<HomeCubit>().onTabTapped(index);
            },
          );
        },
      ),
    );
  }
}
