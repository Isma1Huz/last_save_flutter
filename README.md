# last_save

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.




# LastSave App -  Reusable Components

This project reusable components to improve maintainability and reduce code duplication.

## Reusable Components

### Form Components
- `AppTextField`: A base text field with consistent styling
- `AppPasswordField`: A password field with toggle visibility icon
- `AppEmailField`: An email field with email validation
- `OTPInputField`: A customizable OTP input field

### Button Components
- `AppButton`: A primary button with loading state
- `AppOutlinedButton`: A secondary (outlined) button
- `AppTextButton`: A text button with primary color
- `SocialLoginButton`: A button for social media login options

### Layout Components
- `AppScreen`: A standard screen layout with consistent padding and scroll behavior
- `SectionTitle`: A section title with consistent styling
- `SectionSubtitle`: A section subtitle with consistent styling
- `DividerWithText`: A divider with text in the middle
- `VerticalSpace`: A standard vertical spacing widget

### Utilities
- `FormValidators`: A utility class for form validation functions

## Benefits of Refactoring

1. **Reduced Code Duplication**: Common UI elements are now defined once and reused
2. **Consistent UI**: All screens now have consistent styling and behavior
3. **Easier Maintenance**: Changes to UI elements can be made in one place
4. **Improved Readability**: Screen code is now more focused on business logic
5. **Better Testability**: Components can be tested in isolation

## Usage Example

Before:
```dart
TextFormField(
  controller: _emailController,
  keyboardType: TextInputType.emailAddress,
  decoration: const InputDecoration(
    hintText: 'Enter your email',
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  },
)# last_save_flutter
