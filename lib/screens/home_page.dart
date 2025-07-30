import 'package:flutter/material.dart';
import 'package:meal_app_planner/screens/auth/login_screen.dart';
import 'package:meal_app_planner/screens/ingredients_page.dart';
import 'package:meal_app_planner/screens/profile_screen.dart';
import 'package:meal_app_planner/screens/profile_summary_widget.dart';
import 'package:meal_app_planner/screens/fridge_screen.dart';
import 'package:meal_app_planner/screens/disliked_ingredients_screen.dart';
import 'package:meal_app_planner/screens/meal_screen.dart';
import 'package:meal_app_planner/screens/meal_request_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 250, 240),
      appBar: AppBar(
        title: const Text(
          'Meal management',
          style: TextStyle(fontSize: 24, color: Colors.orange),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.orange),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ProfileSummaryWidget(),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Smart kitchen',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            const Text(
              '    You do not have any ingredients registered ',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const IngredientsScreen(),
                  ),
                );
              },
              child: const Text(
                'Add new ingredients',
                style: TextStyle(color: Colors.orange),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.kitchen, color: Colors.orange),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FridgeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.orange,
                side: const BorderSide(color: Colors.orange),
              ),
              label: const Text('Open Fridge'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.block, color: Colors.red),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DislikedIngredientsScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
              label: const Text('Disliked Ingredients'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.restaurant_menu, color: Colors.green),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MealScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green,
                side: const BorderSide(color: Colors.green),
              ),
              label: const Text('Meals'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.send, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MealRequestScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue),
              ),
              label: const Text('Request Meal'),
            ),
          ],
        ),
      ),
    );
  }
}
