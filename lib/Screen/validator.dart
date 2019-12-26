abstract class StringValidator {
  bool isValid(String value);
}

class NonEmptystringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidators {
  final StringValidator emailValidator = NonEmptystringValidator();
  final StringValidator nameValidator = NonEmptystringValidator();
  final StringValidator panValidator = NonEmptystringValidator();
  final StringValidator phoneNumberValidator = NonEmptystringValidator();
  final StringValidator addressValidator = NonEmptystringValidator();
  final StringValidator detailsValidator = NonEmptystringValidator();
  final StringValidator gstinOrtinValidator = NonEmptystringValidator();

  final String invalidEmailError = "Fill the empty Box With Your Email";
  final String invalidNameError = "Fill the empty Box With Your Name";
  final String invalidPanlError = "Fill the empty Box With Your Pan Number";
  final String invalidAddressError = "Fill the empty Box With Your Address";
  final String invalidDetailsError = "Fill the empty Box With Your Details";
  final String invalidPhoneNumberError =
      "Fill the empty Box With Your Phone Number";
  final String invalidGstinOrTinError =
      "Fill the empty Box With Your Gstin Or Tin";
}
