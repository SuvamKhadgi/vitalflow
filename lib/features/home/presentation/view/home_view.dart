import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:vitalflow/app/di/di.dart';
import 'package:vitalflow/app/my_app.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_bloc.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_state.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const EventChannel _lightChannel = EventChannel('light_sensor');
  late StreamSubscription _lightSubscription;
  late ThemeCubit _themeCubit;

  @override
  void initState() {
    super.initState();
    _themeCubit = context.read<ThemeCubit>();
    _initLightSensor();
  }

  void _initLightSensor() {
    _lightSubscription = _lightChannel.receiveBroadcastStream().listen(
      (dynamic luxValue) {
        double lightLevel = luxValue is int ? luxValue.toDouble() : luxValue as double;
        if (lightLevel < 50 && !_themeCubit.state) {
          print('Low light detected ($lightLevel lux), switching to dark mode');
          _themeCubit.toggleTheme(); // Dark mode
        } else if (lightLevel >= 50 && _themeCubit.state) {
          print('Bright light detected ($lightLevel lux), switching to light mode');
          _themeCubit.toggleTheme(); // Light mode
        }
      },
      onError: (error) {
        print('Error receiving light sensor data: $error');
      },
    );
  }

  @override
  void dispose() {
    _lightSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeBloc>(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          print('HomeView building: selectedIndex=${state.selectedIndex}, views=${state.views.length}');
          if (state.views == null) {
            print('Error: state.views is null');
            return const Scaffold(body: Center(child: Text('Views not initialized')));
          }
          return Scaffold(
            extendBody: true,
            body: SafeArea(
              top: true,
              bottom: false,
              child: state.views[state.selectedIndex],
            ),
            bottomNavigationBar: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart, size: state.selectedIndex == 0 ? 30 : 24),
                    label: 'Cart',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: state.selectedIndex == 1 ? const Color(0xFF6200EE) : Colors.grey[200],
                      ),
                      child: Icon(
                        Icons.home,
                        size: 36,
                        color: state.selectedIndex == 1 ? Colors.white : Colors.grey[600],
                      ),
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person, size: state.selectedIndex == 2 ? 30 : 24),
                    label: 'Profile',
                  ),
                ],
                currentIndex: state.selectedIndex,
                selectedItemColor: const Color(0xFF6200EE),
                unselectedItemColor: Colors.grey[600],
                backgroundColor: Colors.transparent,
                elevation: 0,
                onTap: (index) => context.read<HomeBloc>().add(TabTapped(index)),
                type: BottomNavigationBarType.fixed,
              ),
            ),
          );
        },
      ),
    );
  }
}