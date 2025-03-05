import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vitalflow/app/constants/api_endpoints.dart';
import 'package:vitalflow/core/common/snackbar/my_snackbar.dart';
import 'package:vitalflow/features/home/domain/entity/item_entity.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_bloc.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_state.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final TextEditingController _searchController = TextEditingController();
  List<ItemEntity> _filteredItems = [];
  List<ItemEntity> _categoryFilteredItems = [];

  // Carousel images from assets
  final List<String> carouselImages = [
    'assets/images/cour1.png',
    'assets/images/cour3.jpeg',
    'assets/images/cour4.jpeg',
  ];

  // Categories with icons
  final List<Map<String, dynamic>> categories = [
    {'name': 'Baby Care', 'icon': Icons.child_care},
    {'name': 'Men Care', 'icon': Icons.man},
    {'name': 'Woman Care', 'icon': Icons.woman},
    {'name': 'Wellness & Fitness', 'icon': Icons.health_and_safety},
    {'name': 'Devices', 'icon': Icons.medical_services},
    {'name': 'First Aid', 'icon': Icons.local_hospital},
    {'name': 'Body Care', 'icon': Icons.spa},
    {'name': 'Pain Relief', 'icon': Icons.healing},
    {'name': 'Oral Care', 'icon': Icons.brush},
    {'name': 'See More', 'icon': Icons.expand_more},
  ];

  // Track the selected category
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterItemsBySearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItemsBySearch() {
    final query = _searchController.text.toLowerCase();
    final state = context.read<HomeBloc>().state;
    if (state.dashboardItems != null) {
      setState(() {
        _filteredItems = state.dashboardItems!
            .where((item) => item.name.toLowerCase().contains(query))
            .toList();
        _applyCategoryFilter();
      });
    }
  }

  void _applyCategoryFilter() {
    if (selectedCategory == null || selectedCategory == 'See More') {
      _categoryFilteredItems = List.from(_filteredItems);
    } else {
      _categoryFilteredItems = _filteredItems.where((item) {
        // Dynamically match the category name with type or subType
        return item.type.toLowerCase() == selectedCategory!.toLowerCase() ||
            item.subType.toLowerCase() == selectedCategory!.toLowerCase();
      }).toList();
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
      _applyCategoryFilter();
    });
  }

  void _showItemDetails(BuildContext parentContext, ItemEntity item) {
    int quantity = 1;
    final theme = Theme.of(parentContext);
    final screenWidth = MediaQuery.of(parentContext).size.width;
    final screenHeight = MediaQuery.of(parentContext).size.height;
    final isTablet = screenWidth >= 600;
    bool isShaking = false;

    accelerometerEvents.listen((AccelerometerEvent event) {
      double gForce = (event.x.abs() + event.y.abs() + event.z.abs()) / 9.81;
      if (gForce > 2.7 && !isShaking) {
        isShaking = true;
        print('Shake detected, adding to cart: ${item.id}, qty: $quantity');
        parentContext.read<HomeBloc>().add(AddToCart(item.id, quantity));
        Navigator.pop(parentContext);
        showMySnackBar(
          context: parentContext,
          message: "Added ${item.name} to cart!",
          color: Colors.green,
        );
        Future.delayed(
            const Duration(milliseconds: 500), () => isShaking = false);
      }
    });

    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.cardTheme.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          item.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
            fontSize: isTablet ? 24 : 20,
          ),
          textAlign: TextAlign.center,
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(parentContext).size.height * 0.85,
            maxWidth: isTablet ? screenWidth * 0.6 : screenWidth * 0.9,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight:
                        isTablet ? screenHeight * 0.7 : screenHeight * 0.4,
                    maxWidth: isTablet ? screenWidth * 0.5 : screenWidth * 0.8,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: '${ApiEndpoints.itemImageUrl}${item.image}',
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) {
                        print('Image load error: URL=$url, Error=$error');
                        return const Icon(Icons.error, color: Colors.red);
                      },
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? Colors.grey[800]
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description: ${item.description}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Price: Rs.${item.price}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                          fontSize: isTablet ? 18 : 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Available: ${item.quantity}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                StatefulBuilder(
                  builder: (dialogContext, setState) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle,
                          color: theme.primaryColor,
                          size: isTablet ? 36 : 30,
                        ),
                        onPressed: quantity > 1
                            ? () {
                                setState(() => quantity--);
                                print('Decreased quantity to: $quantity');
                              }
                            : null,
                      ),
                      Text(
                        '$quantity',
                        style: TextStyle(
                          fontSize: isTablet ? 22 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle,
                          color: theme.primaryColor,
                          size: isTablet ? 36 : 30,
                        ),
                        onPressed: quantity < item.quantity
                            ? () {
                                setState(() => quantity++);
                                print('Increased quantity to: $quantity');
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              print('Adding to cart: ${item.id}, qty: $quantity');
              parentContext.read<HomeBloc>().add(AddToCart(item.id, quantity));
              Navigator.pop(dialogContext);
              showMySnackBar(
                context: parentContext,
                message: "Added ${item.name} to cart!",
                color: Colors.green,
              );
            },
            child: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final crossAxisCount = (screenWidth / 200).floor().clamp(2, 4);
    final childAspectRatio = screenWidth < 600 ? 0.8 : 1.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.primaryColor, const Color(0xFF03DAC6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.03,
                vertical: screenHeight * 0.01,
              ),
              child: SizedBox(
                width: screenWidth * 0.9,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search items...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    filled: true,
                    fillColor: theme.brightness == Brightness.dark
                        ? Colors.grey[800]
                        : Colors.grey[200],
                    prefixIcon: Icon(Icons.search, color: theme.primaryColor),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                  ),
                  style: TextStyle(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                    fontSize: screenWidth < 600 ? 16 : 18,
                  ),
                ),
              ),
            ),
            // Carousel Slider with Asset Images
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: screenWidth < 600 ? 150 : 200,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  enlargeCenterPage: true,
                  viewportFraction: screenWidth < 600 ? 0.9 : 0.8,
                  aspectRatio: 16 / 9,
                  enableInfiniteScroll: true,
                ),
                items: carouselImages.map((imagePath) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              print('Asset image load error: $error');
                              return const Icon(Icons.error, color: Colors.red);
                            },
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            // Categories Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.015,
                  horizontal: screenWidth * 0.02,
                ),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.brightness == Brightness.dark
                          ? Colors.black26
                          : Colors.black12,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.01),
                      child: Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: screenWidth < 600 ? 18 : 20,
                          fontWeight: FontWeight.bold,
                          color: theme.brightness == Brightness.dark
                              ? Colors.white
                              : theme.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: screenWidth < 600 ? 40 : 48,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index]['name'];
                          final icon = categories[index]['icon'];
                          final isSelected = selectedCategory == category;
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.01),
                            child: ElevatedButton(
                              onPressed: () => _onCategorySelected(category),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .transparent, // Make button transparent to show the gradient
                                foregroundColor: isSelected
                                    ? Colors.white
                                    : (theme.brightness == Brightness.dark
                                        ? Colors.white70
                                        : Colors.black87),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.03,
                                  vertical: screenHeight * 0.01,
                                ),
                                elevation: isSelected ? 4 : 2,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    icon,
                                    size: screenWidth < 600 ? 18 : 22,
                                    color: isSelected
                                        ? Colors.white
                                        : (theme.brightness == Brightness.dark
                                            ? Colors.white70
                                            : Colors.black87),
                                  ),
                                  SizedBox(width: screenWidth * 0.015),
                                  Text(
                                    category,
                                    style: TextStyle(
                                      fontSize: screenWidth < 600 ? 14 : 16,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            // Filtered GridView
            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.error != null) {
                    return Center(
                        child: Text('Error: ${state.error}',
                            style: TextStyle(color: theme.colorScheme.error)));
                  }
                  if (state.dashboardItems == null) {
                    return Center(
                        child: Text('Loading items...',
                            style: theme.textTheme.bodyLarge));
                  }
                  if (state.dashboardItems!.isEmpty) {
                    return Center(
                        child: Text('No items available',
                            style: theme.textTheme.bodyLarge));
                  }

                  _filteredItems = _filteredItems.isEmpty
                      ? state.dashboardItems!
                      : _filteredItems;
                  _applyCategoryFilter();
                  return GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.03,
                      screenWidth * 0.03,
                      screenWidth * 0.03,
                      screenWidth * 0.03 + 70,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: childAspectRatio,
                      crossAxisSpacing: screenWidth * 0.03,
                      mainAxisSpacing: screenWidth * 0.03,
                    ),
                    itemCount: _categoryFilteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _categoryFilteredItems[index];
                      return Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: InkWell(
                          onTap: () => _showItemDetails(context, item),
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '${ApiEndpoints.itemImageUrl}${item.image}',
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error,
                                            color: Colors.red),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(screenWidth * 0.02),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      item.name,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Text(
                                      'Qty: ${item.quantity}',
                                      style: TextStyle(
                                          color: theme.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              screenWidth < 600 ? 14 : 16),
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Text(
                                      'Rs.${item.price}',
                                      style: TextStyle(
                                          color: theme.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              screenWidth < 600 ? 14 : 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
