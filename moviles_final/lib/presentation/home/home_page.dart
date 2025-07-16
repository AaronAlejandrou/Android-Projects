import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import 'tabs/restaurants_tab.dart';
import 'tabs/favorites_tab.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FoodApp'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.restaurant), text: 'Restaurants'),
            Tab(icon: Icon(Icons.favorite), text: 'Favorites'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RestaurantsTab(token: widget.user.token),
          FavoritesTab(),
        ],
      ),
    );
  }
} 