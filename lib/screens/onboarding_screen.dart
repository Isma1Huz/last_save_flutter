import 'package:flutter/material.dart';
import 'package:last_save/screens/home_screen.dart';
import 'package:last_save/utils/app_theme.dart';
import 'package:last_save/widgets/permission_card.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:last_save/services/permission_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// OnboardingScreen requests necessary permissions from the user
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PermissionService _permissionService = PermissionService();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Find Contacts in Seconds with Smart AI Search',
      'description': 'Effortlessly locate any contact with powerful AI-driven search that understands names, job roles, locations, and even context—helping you stay organized and productive.',
      'image': 'assets/images/onboard1.png',
    },
    {
      'title': 'Visualize Your Network with Contact Relationships',
      'description': 'Explore connections between your contacts through intelligent relationship mapping—whether it\'s colleagues, family, or frequent collaborators, everything is linked.',
      'image': 'assets/images/onboard3.png',
    },
    {
      'title': 'Add Contacts via QR, Save Events & Pin Locations',
      'description': 'Easily add new contacts by scanning QR codes, save important events to profiles, and view contact locations on the map—your contact book just got smarter.',
      'image': 'assets/images/onboard2.png',
    },
  ];

  final List<Map<String, dynamic>> _permissions = [
    {
      'title': 'Contacts',
      'description': 'Allow LastSave to access your contacts',
      'icon': Icons.contacts,
      'granted': false,
    },
    {
      'title': 'Location',
      'description': 'Allow LastSave to access your location',
      'icon': Icons.location_on,
      'granted': false,
    },
    {
      'title': 'Storage',
      'description': 'Allow LastSave to access your storage',
      'icon': Icons.storage,
      'granted': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initPermissionStatus();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _initPermissionStatus() async {
    await _permissionService.init();

    final hasContactsPermission = await _permissionService.hasContactsPermission();
    final hasLocationPermission = await _permissionService.hasLocationPermission();
    final hasStoragePermission = await _permissionService.hasStoragePermission();

    debugPrint('Initial permission status - Contacts: $hasContactsPermission, '
        'Location: $hasLocationPermission, Storage: $hasStoragePermission');

    setState(() {
      _permissions[0]['granted'] = hasContactsPermission;
      _permissions[1]['granted'] = hasLocationPermission;
      _permissions[2]['granted'] = hasStoragePermission;
    });
  }

  void _requestPermission(int index) async {
    bool granted = false;

    switch (_permissions[index]['title']) {
      case 'Contacts':
        granted = await _permissionService.requestContactsPermission(
          context: context,
          showRationale: true,
        );
        break;
      case 'Location':
        granted = await _permissionService.requestLocationPermission(
          context: context,
          showRationale: true,
        );
        break;
      case 'Storage':
        granted = await _permissionService.requestStoragePermission(
          context: context,
          showRationale: true,
        );
        break;
    }

    if (granted) {
      setState(() {
        _permissions[index]['granted'] = true;
      });

      debugPrint('Permission granted for ${_permissions[index]['title']}');
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_permissions[index]['title']} permission denied'),
          ),
        );
      }
    }
  }

  void _continueToHome() async {
    await _permissionService.setOnboardingCompleted();

    final prefs = await SharedPreferences.getInstance();

    final contactsStatus = await Permission.contacts.status;
    await prefs.setBool('contacts_permission_granted', contactsStatus.isGranted);

    final locationStatus = await Permission.location.status;
    await prefs.setBool('location_permission_granted', locationStatus.isGranted);

    final storageStatus = await Permission.storage.status;
    await prefs.setBool('storage_permission_granted', storageStatus.isGranted);

    debugPrint('Final permission status - Contacts: ${contactsStatus.isGranted}, '
        'Location: ${locationStatus.isGranted}, Storage: ${storageStatus.isGranted}');

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          children: [
            ..._onboardingData.map((data) => _buildOnboardingPage(data)),
            _buildPermissionsPage(),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Image.asset(
              data['image'],
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            data['title'],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            data['description'],
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _onboardingData.length + 1,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? AppTheme.primaryColor
                      : Colors.grey.shade300,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          if (_currentPage < _onboardingData.length)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _nextPage,
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPermissionsPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Permissions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'LastSave needs the following permissions to provide you with the best experience:',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: _permissions.length,
              itemBuilder: (context, index) {
                final permission = _permissions[index];
                return PermissionCard(
                  title: permission['title'],
                  description: permission['description'],
                  icon: permission['icon'],
                  granted: permission['granted'],
                  onRequest: () => _requestPermission(index),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _onboardingData.length + 1,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? AppTheme.primaryColor
                      : Colors.grey.shade300,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              child: ElevatedButton(
                onPressed: _permissions.every((p) => p['granted'] == true)
                    ? _continueToHome
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text(
                  'Finish up',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}