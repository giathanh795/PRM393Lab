import 'package:flutter/material.dart';
import 'screens/lab9_1_asset_json_screen.dart';
import 'screens/lab9_2_device_storage_screen.dart';
import 'screens/lab9_3_crud_database_screen.dart';

void main() {
  runApp(const Lab9App());
}

class Lab9App extends StatelessWidget {
  const Lab9App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 9 - Local JSON Storage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.light,
        ),
      ),
      home: const Lab9MainNavigation(),
    );
  }
}

class Lab9MainNavigation extends StatefulWidget {
  const Lab9MainNavigation({super.key});

  @override
  State<Lab9MainNavigation> createState() => _Lab9MainNavigationState();
}

class _Lab9MainNavigationState extends State<Lab9MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    Lab91AssetJsonScreen(),
    Lab92DeviceStorageScreen(),
    Lab93CrudDatabaseScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.folder_open_outlined),
            selectedIcon: Icon(Icons.folder_special, color: Colors.deepOrange),
            label: '9.1 Asset JSON',
          ),
          NavigationDestination(
            icon: Icon(Icons.save_outlined),
            selectedIcon: Icon(Icons.save, color: Colors.indigo),
            label: '9.2 Local Storage',
          ),
          NavigationDestination(
            icon: Icon(Icons.dataset_outlined),
            selectedIcon: Icon(Icons.dataset, color: Colors.purple),
            label: '9.3 CRUD DB',
          ),
        ],
      ),
    );
  }
}
