class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre email';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email invalide';
    }
    
    return null;
  }

  static String? pin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un code PIN';
    }
    
    if (value.length != 4) {
      return 'Le code PIN doit contenir exactement 4 chiffres';
    }
    
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Le code PIN doit contenir uniquement des chiffres';
    }
    
    return null;
  }

  static String? confirmPin(String? value, String pin) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer votre code PIN';
    }
    
    if (value != pin) {
      return 'Les codes PIN ne correspondent pas';
    }
    
    return null;
  }

  static String? required(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer $fieldName';
    }
    
    return null;
  }

  static String? minLength(String? value, int min, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer $fieldName';
    }
    
    if (value.length < min) {
      return '$fieldName doit contenir au moins $min caractères';
    }
    
    return null;
  }

  static String? phone(String? value, {bool required = true}) {
    if (value == null || value.isEmpty) {
      return required ? 'Veuillez entrer votre numéro de téléphone' : null;
    }
    
    // Retirer les espaces et le préfixe +221
    final cleanPhone = value.replaceAll(RegExp(r'[\s+]'), '').replaceAll('221', '');
    
    // Backend attend 5-10 chiffres
    if (!RegExp(r'^[0-9]{5,10}$').hasMatch(cleanPhone)) {
      return 'Le numéro doit contenir entre 5 et 10 chiffres';
    }
    
    return null;
  }
}
