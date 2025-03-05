import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vitalflow/features/home/domain/entity/cart_entity.dart';
import 'package:vitalflow/features/home/domain/entity/item_entity.dart';
import 'package:vitalflow/features/home/presentation/view/cart_view.dart';
import 'package:vitalflow/features/home/presentation/view/dashboard_view.dart';
import 'package:vitalflow/features/home/presentation/view/profile_view.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final List<Widget> views;
  final List<ItemEntity>? dashboardItems;
  final CartEntity? cart;
  final bool isLoading;
  final String? error;
  final String? userId;

  const HomeState({
    required this.selectedIndex,
    required this.views,
    this.dashboardItems,
    this.cart,
    this.isLoading = false,
    this.error,
    this.userId,
  });

  static HomeState initial() {
    return const HomeState(
      selectedIndex: 1, // Start on Home (center)
      views: [
        CartView(),      // Index 0: Cart (left)
        DashboardView(), // Index 1: Home (center)
        ProfileView(),   // Index 2: Profile (right)
      ],
    );
  }

  HomeState copyWith({
    int? selectedIndex,
    List<Widget>? views,
    List<ItemEntity>? dashboardItems,
    CartEntity? cart,
    bool? isLoading,
    String? error,
    String? userId,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views ?? this.views,
      dashboardItems: dashboardItems ?? this.dashboardItems,
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, views, dashboardItems, cart, isLoading, error, userId];
}