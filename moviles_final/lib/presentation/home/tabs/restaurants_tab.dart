import 'package:flutter/material.dart';
import '../../../data/api/restaurant_api.dart';
import '../../../data/models/restaurant_dto.dart';
import '../../restaurants/restaurant_detail_page.dart';

class RestaurantsTab extends StatefulWidget {
  final String token;
  const RestaurantsTab({super.key, required this.token});

  @override
  State<RestaurantsTab> createState() => _RestaurantsTabState();
}

class _RestaurantsTabState extends State<RestaurantsTab> {
  late Future<List<RestaurantDto>> _futureRestaurants;

  @override
  void initState() {
    super.initState();
    _futureRestaurants = RestaurantApi().getRestaurants(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RestaurantDto>>(
      future: _futureRestaurants,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load restaurants'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No restaurants found'));
        }
        final restaurants = snapshot.data!;
        return ListView.builder(
          itemCount: restaurants.length,
          itemBuilder: (context, index) {
            final r = restaurants[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListTile(
                leading: Image.network(r.poster, width: 60, height: 60, fit: BoxFit.cover),
                title: Text(r.title),
                subtitle: Text('Rating: ${r.rating.toStringAsFixed(1)}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RestaurantDetailPage(restaurant: r.toDomain(), token: widget.token),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
} 