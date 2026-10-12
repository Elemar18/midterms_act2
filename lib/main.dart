
import 'package:flutter/material.dart';
import 'screens.dart';

void main() {
  runApp(const ApiIntegrationApp());
}

class ApiIntegrationApp extends StatelessWidget {
  const ApiIntegrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Integration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = const [
    OrderScreen(),
    BeltScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedIndex == 0
              ? 'The Order - Countries'
              : 'The Belt - Live Updates',
        ),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.public),
            label: 'The Order',
          ),
          NavigationDestination(
            icon: Icon(Icons.sync),
            label: 'The Belt',
          ),
        ],
      ),
    );
  }
}
