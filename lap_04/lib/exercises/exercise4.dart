import 'package:flutter/material.dart';

// Exercise 4: App Structure with Scaffold, AppBar, FAB & Theme
// Goal: Practice building a complete screen structure with Dark Mode toggle.
class Exercise4Scaffold extends StatefulWidget {
  const Exercise4Scaffold({super.key});

  @override
  State<Exercise4Scaffold> createState() => _Exercise4ScaffoldState();
}

class _Exercise4ScaffoldState extends State<Exercise4Scaffold> {
  // Toggle Dark Mode
  bool _isDarkMode = false;

  // FAB counter
  int _fabCount = 0;

  // SnackBar message khi nhấn FAB
  void _onFabPressed(BuildContext context) {
    setState(() {
      _fabCount++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('FAB đã nhấn $_fabCount lần!'),
        duration: const Duration(seconds: 1),
        backgroundColor: _isDarkMode ? Colors.deepPurple[300] : Colors.deepPurple,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tạo ThemeData theo trạng thái Dark Mode
    final ThemeData theme = _isDarkMode
        ? ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
          )
        : ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
          );

    return Theme(
      data: theme,
      child: Scaffold(
        // AppBar
        appBar: AppBar(
          title: const Text('Exercise 4 - Scaffold & Theme'),
          backgroundColor: _isDarkMode ? Colors.deepPurple[900] : Colors.deepPurple,
          foregroundColor: Colors.white,
          actions: [
            // Dark mode toggle trong AppBar actions
            Row(
              children: [
                Icon(
                  _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: Colors.white,
                ),
                Switch(
                  value: _isDarkMode,
                  onChanged: (val) => setState(() => _isDarkMode = val),
                  activeThumbColor: Colors.white,
                  activeTrackColor: Colors.deepPurple[300],
                ),
              ],
            ),
          ],
        ),

        // Drawer (navigation drawer)
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: _isDarkMode ? Colors.deepPurple[900] : Colors.deepPurple,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 28,
                      child: Icon(Icons.person, color: Colors.deepPurple, size: 32),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'PRM393 Student',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Lab 4 - Scaffold Demo',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Trang chủ'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Cài đặt'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Về ứng dụng'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),

        // Body
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ThemeData đang dùng:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isDarkMode ? Colors.white : Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('🎨 Chế độ: ${_isDarkMode ? "Tối (Dark)" : "Sáng (Light)"}'),
                      Text('🔘 FAB đã nhấn: $_fabCount lần'),
                      Text('🎯 Seed Color: DeepPurple'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Theme toggle card
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                            color: _isDarkMode ? Colors.amber : Colors.orange,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _isDarkMode ? 'Dark Mode' : 'Light Mode',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Switch(
                        value: _isDarkMode,
                        onChanged: (val) => setState(() => _isDarkMode = val),
                        activeThumbColor: Colors.deepPurple,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Explanation text
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.widgets, size: 64, color: Colors.deepPurple),
                      SizedBox(height: 16),
                      Text(
                        'Scaffold bao gồm:\nAppBar + Drawer + Body + FAB',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Nhấn nút ☰ để mở Drawer\nNhấn nút + để tăng đếm FAB',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // FloatingActionButton
        floatingActionButton: Builder(
          builder: (ctx) => FloatingActionButton.extended(
            onPressed: () => _onFabPressed(ctx),
            icon: const Icon(Icons.add),
            label: const Text('Nhấn FAB'),
            tooltip: 'FloatingActionButton',
          ),
        ),
      ),
    );
  }
}
