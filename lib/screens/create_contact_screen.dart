import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:last_save/services/contact_service.dart';
import 'package:last_save/widgets/create/addresses_section.dart';
import 'package:last_save/widgets/create/basic_info.dart';
import 'package:last_save/widgets/create/categories_location.dart';
import 'package:last_save/widgets/create/email_section.dart';
import 'package:last_save/widgets/create/phone_number.dart';
import 'package:last_save/widgets/create/profile_image_picker.dart';
import 'package:last_save/widgets/create/tags_notes.dart';
import 'package:last_save/services/location_service.dart';

class CreateContactScreen extends StatefulWidget {
  const CreateContactScreen({Key? key}) : super(key: key);

  @override
  State<CreateContactScreen> createState() => _CreateContactScreenState();
}

class _CreateContactScreenState extends State<CreateContactScreen> {
  File? _profileImage;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _meetingEventController = TextEditingController();
  final List<PhoneNumberField> _phoneNumbers = [PhoneNumberField()];
  final List<EmailField> _emails = [];
  final List<AddressField> _addresses = [];
  String? _selectedCategory;
  Position? _currentPosition;
  String? _currentAddress;
  bool _isSaving = false;

  final List<String> _categories = [
    'Family',
    'Friends',
    'Work',
    'School',
    'Important',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyController.dispose();
    _notesController.dispose();
    _meetingEventController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    final position = await LocationService.getCurrentPosition(context);
    if (position != null) {
      setState(() {
        _currentPosition = position;
      });
      final address = await LocationService.getAddressFromLatLng(position);
      setState(() {
        _currentAddress = address;
      });
    }
  }

  void _onImagePicked(File image) {
    setState(() {
      _profileImage = image;
    });
  }
  void _removeProfileImage() {
    setState(() {
      _profileImage = null;
    });
  }


  void _addPhoneNumber() {
    setState(() {
      _phoneNumbers.add(PhoneNumberField());
    });
  }

  void _removePhoneNumber(int index) {
    if (_phoneNumbers.length > 1) {
      setState(() {
        _phoneNumbers.removeAt(index);
      });
    }
  }

  void _addEmail() {
    setState(() {
      _emails.add(EmailField());
    });
  }

  void _removeEmail(int index) {
    setState(() {
      _emails.removeAt(index);
    });
  }

  void _addAddress() {
    setState(() {
      _addresses.add(AddressField());
    });
  }

  void _removeAddress(int index) {
    setState(() {
      _addresses.removeAt(index);
    });
  }

  void _onCategoryChanged(String? newValue) {
    setState(() {
      _selectedCategory = newValue;
    });
  }

  Future<void> _saveContact() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });
      
      try {
        final success = await ContactsService.saveContact(
          context: context,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          company: _companyController.text,
          phoneNumbers: _phoneNumbers,
          emails: _emails,
          addresses: _addresses,
          category: _selectedCategory,
          notes: _notesController.text,
          meetingEvent: _meetingEventController.text,
          profileImage: _profileImage,
        );
        
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Contact saved successfully to device!'))
          );
          Navigator.of(context).pop();
        }
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8ECF4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8ECF4),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Center(
          child: Text(
          'Create contact',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        ),
        actions: [
          _isSaving
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF00BCD4),
                      ),
                    ),
                  ),
                )
              : Container(
                margin: const EdgeInsets.only(right: 10),
                child:TextButton(
                  onPressed: _saveContact,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    backgroundColor: const Color(0xFF00BCD4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              )

        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Profile image picker
                ProfileImageWidget(
                  profileImage: _profileImage,
                  onImagePicked: _onImagePicked,
                  onImageRemoved: _removeProfileImage,
                ),
                const SizedBox(height: 12),
                
                // Contact Details Section
                const Text(
                  'Contact details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Info (Name, Company)
                      BasicInfoWidget(
                        firstNameController: _firstNameController,
                        lastNameController: _lastNameController,
                        companyController: _companyController,
                      ),
                      
                      // Phone Numbers
                      const SizedBox(height: 16),
                      PhoneNumbersWidget(
                        phoneNumbers: _phoneNumbers,
                        onAddPhoneNumber: _addPhoneNumber,
                        onRemovePhoneNumber: _removePhoneNumber,
                      ),
                      
                      // Emails
                      const SizedBox(height: 16),
                      EmailsWidget(
                        emails: _emails,
                        onAddEmail: _addEmail,
                        onRemoveEmail: _removeEmail,
                      ),
                      
                      // Addresses
                      const SizedBox(height: 16),
                      AddressesWidget(
                        addresses: _addresses,
                        onAddAddress: _addAddress,
                        onRemoveAddress: _removeAddress,
                      ),
                      
                      // Category
                      const SizedBox(height: 16),
                      CategoryWidget(
                        selectedCategory: _selectedCategory,
                        categories: _categories,
                        onCategoryChanged: _onCategoryChanged,
                      ),
                      
                      // Current Location
                      const SizedBox(height: 16),
                      LocationWidget(
                        currentAddress: _currentAddress,
                      ),
                      
                      // Meeting Event
                      const SizedBox(height: 16),
                      MeetingEventWidget(
                        meetingEventController: _meetingEventController,
                      ),

                      // Notes Section
                      const SizedBox(height: 24),
                      NotesWidget(
                        notesController: _notesController,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}