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
  final StringValidator stateValidator = NonEmptystringValidator();
  final StringValidator pinCodeValidator = NonEmptystringValidator();
  final StringValidator acHolderNameinValidator = NonEmptystringValidator();
  final StringValidator acStateValidator = NonEmptystringValidator();
  final StringValidator acCityValidator = NonEmptystringValidator();
  final StringValidator branchValidator = NonEmptystringValidator();
  final StringValidator ifscCodeValidator = NonEmptystringValidator();
  final StringValidator accountNumberValidator = NonEmptystringValidator();
  final StringValidator cityValidator = NonEmptystringValidator();
  final StringValidator bankNameValidator = NonEmptystringValidator();

  final String invalidEmailError = "Fill the empty Box With Your Email";
  final String invalidNameError = "Fill the empty Box With Your Name";
  final String invalidPanlError = "Fill the empty Box With Your Pan Number";
  final String invalidAddressError = "Fill the empty Box With Your Address";
  final String invalidDetailsError = "Fill the empty Box With Your Details";
  final String invalidPhoneNumberError =
      "Fill the empty Box With Your Phone Number";
  final String invalidGstinOrTinError =
      "Fill the empty Box With Your Gstin Or Tin";
  final String pinCodeError = "Fill the empty Box With Your Your Area PinCode";
  final String stateError = "Fill the empty Box With Your State Name";
  final String cityError = "Fill the empty Box With Your City Name";
  final String acCityError = "Fill the empty Box With Your Bank City Name";
  final String acStateError = "Fill the empty Box With Your Bank State Name";
  final String accountNumberError =
      "Fill the empty Box With Your Bank Account Number";
  final String acHolderNameError =
      "Fill the empty Box With Your Bank Account Holder Name";
  final String acBankNameError = "Fill the empty Box With Your Bank Name";
  final String ifscError = "Fill the empty Box With Your IFSC Code";
  final String branchError = "Fill the empty Box With Your Area Branch Name";
}
