import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import 'details_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          if (provider.favorites.isEmpty) {
            return const Center(child: Text('No favorites added yet.'));
          }
          return ListView.builder(
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              final city = provider.favorites[index];
              return ListTile(
                title: Text(city),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    provider.removeFavorite(city);
                  },
                ),
                onTap: () async {
                  await provider.fetchWeather(city);
                  if (context.mounted && provider.currentWeather != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DetailsPage(),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
