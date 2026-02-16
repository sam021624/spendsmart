class Validators {
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username.';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters.';
    }
    if (value.length > 20) {
      return 'Username must not exceed 20 characters.';
    }

    // Alphanumeric and underscores only, no spaces
    const pattern = r'^[a-zA-Z0-9_]+$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return 'Only letters, numbers, and underscores are allowed.';
    }

    return null;
  }

  static String? validateEmptyField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email or username.';
    }
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      if (!value.contains('@')) {
        return null;
      }
      return 'Enter a valid email address.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name.';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters.';
    }
    const pattern = r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$";
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Name contains invalid characters.';
    }
    return null;
  }

  static String? validateStoreName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your store name.';
    }
    if (value.length < 2) {
      return 'Store Name must be at least 2 characters.';
    }
    const pattern = r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$";
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Store Name contains invalid characters.';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number.';
    }

    final cleanedValue = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanedValue.length < 11) {
      return 'Enter a valid phone number (11 digits).';
    }

    const pattern = r'^\+?[\d\s-]{10,}$';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Invalid phone number format.';
    }

    return null;
  }

  static String? validateStrongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password.';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain an uppercase letter.';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain a number.';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain a special character.';
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    String originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }
    if (value != originalPassword) {
      return 'Passwords do not match.';
    }
    return null;
  }
}
