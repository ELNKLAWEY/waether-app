import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, provider, child) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Use Metric Units (°C)'),
                subtitle: const Text('Toggle to switch between Celsius and Fahrenheit'),
                value: provider.isMetric,
                onChanged: (value) {
                  provider.toggleUnit();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
