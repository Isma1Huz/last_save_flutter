import 'package:flutter/material.dart';
import 'package:last_save/constants/onboarding_constants.dart';
import 'package:last_save/screens/home_screen.dart';
import 'package:last_save/services/permission_service.dart';
import 'package:last_save/utils/image_precacher.dart';
import 'package:last_save/widgets/onboarding/onboarding_content.dart';
import 'package:last_save/widgets/onboarding/permissions_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PermissionService _permissionService = PermissionService();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _precacheStarted = false;

  late List<Map<String, dynamic>> _permissions;

  @override
  void initState() {
    super.initState();
    _permissions = List<Map<String, dynamic>>.from(
      OnboardingConstants.permissionsData.map((p) => Map<String, dynamic>.from(p))
    );
    _initPermissionStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_precacheStarted) {
      _precacheStarted = true; 
      _precacheImages();
    }
  }

  Future<void> _precacheImages() async {
    try {
      for (final imagePath in OnboardingConstants.onboardingImages) {
        await precacheImage(AssetImage(imagePath), context);
      }
      
      if (mounted) {
        setState(() {
        });
      }
    } catch (e) {
      debugPrint('Error precaching images: $e');
      if (mounted) {
        setState(() {
        });
      }
    }
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

    if (mounted) {
      setState(() {
        _permissions[0]['granted'] = hasContactsPermission;
        _permissions[1]['granted'] = hasLocationPermission;
        _permissions[2]['granted'] = hasStoragePermission;
      });
    }
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
    if (_currentPage < OnboardingConstants.onboardingData.length) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          children: [
            ...OnboardingConstants.onboardingData.map(
              (data) => OnboardingContent(
                data: data,
                currentPage: _currentPage,
                totalPages: OnboardingConstants.onboardingData.length + 1,
                onNext: _nextPage,
              ),
            ),
            PermissionsPage(
              permissions: _permissions,
              currentPage: _currentPage,
              totalPages: OnboardingConstants.onboardingData.length + 1,
              onRequestPermission: _requestPermission,
              onContinue: _continueToHome,
            ),
          ],
        ),
      ),
    );
  }
}
