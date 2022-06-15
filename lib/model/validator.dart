class Validator {
  //ne pas permettre de laisser vide
  static String? validateField({required String value}) {
    if (value.isEmpty) {
      //return 'Field can\'t be empty';
      return 'Le champ ne peut pas être vide';
    }

    return null;
  }
  //permettre laisser vide
  static String? nonValidateField({required String value}) {
      return null;
    }

  static String? validateUserID({required String uid}) {
    if (uid.isEmpty) {
      return 'User ID can\'t be empty';
    } else if (uid.length <= 3) {
      return 'User ID should be greater than 3 characters';
    }

    return null;
  }
}