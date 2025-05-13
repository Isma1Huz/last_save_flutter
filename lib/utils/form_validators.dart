/// A utility class for form validation functions
class FormValidators {
  static String? required(String? value, [String message = 'This field is required']) {
    if (value == null || value.isEmpty) {
      return message;
    }
    return null;
  }

  /// Validates that the input is a valid email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }


  /// Validates that the password meets minimum requirements
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validates that the confirmation password matches the original password
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}