import 'package:flutter/material.dart';
import 'package:last_save/screens/add_categories_contacts.dart';
import 'package:last_save/widgets/home/categories_section.dart';
import 'package:last_save/widgets/home/last_saved.dart';
import 'package:last_save/widgets/home/relations.dart';
import 'package:last_save/widgets/home/search_bar.dart';
import 'package:last_save/widgets/home/bottom_navigation.dart';
import 'package:last_save/screens/create_contact_screen.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void onCategoryTap(category){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddContactsToCategoryScreen(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8ECF4),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              const SizedBox(height: 12),
              SearchInput(
                controller: searchController,
                onChanged: (value) {},
                onClear: () {
                  searchController.clear();
                },
                onMoreTap: () {},
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        CategoriesSection(
                          onCategoryTap: onCategoryTap
                        ),
                        const SizedBox(height: 16),
                        const PlacesRelationsSection(),
                        const SizedBox(height: 8),
                        const LastSavedSection(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateContactScreen(),
            ),
          );
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
