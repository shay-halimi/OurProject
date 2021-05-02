// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `WhatsApp`
  String get whatsAppBtn {
    return Intl.message(
      'WhatsApp',
      name: 'whatsAppBtn',
      desc: '',
      args: [],
    );
  }

  /// `Call`
  String get phoneBtn {
    return Intl.message(
      'Call',
      name: 'phoneBtn',
      desc: '',
      args: [],
    );
  }

  /// `Navigate`
  String get directionsBtn {
    return Intl.message(
      'Navigate',
      name: 'directionsBtn',
      desc: '',
      args: [],
    );
  }

  /// `Search this area`
  String get searchThisAreaBtn {
    return Intl.message(
      'Search this area',
      name: 'searchThisAreaBtn',
      desc: '',
      args: [],
    );
  }

  /// `& {count} more points`
  String andCountMorePoints(Object count) {
    return Intl.message(
      '& $count more points',
      name: 'andCountMorePoints',
      desc: '',
      args: [count],
    );
  }

  /// `& one more point`
  String get andOneMorePoint {
    return Intl.message(
      '& one more point',
      name: 'andOneMorePoint',
      desc: '',
      args: [],
    );
  }

  /// `Explore`
  String get explore {
    return Intl.message(
      'Explore',
      name: 'explore',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get menuBtn {
    return Intl.message(
      'Menu',
      name: 'menuBtn',
      desc: '',
      args: [],
    );
  }

  /// `Order now`
  String get orderBtn {
    return Intl.message(
      'Order now',
      name: 'orderBtn',
      desc: '',
      args: [],
    );
  }

  /// `{km} km`
  String kmFromYou(Object km) {
    return Intl.message(
      '$km km',
      name: 'kmFromYou',
      desc: '',
      args: [km],
    );
  }

  /// `vegan`
  String get vegan {
    return Intl.message(
      'vegan',
      name: 'vegan',
      desc: '',
      args: [],
    );
  }

  /// `vegetarian`
  String get vegetarian {
    return Intl.message(
      'vegetarian',
      name: 'vegetarian',
      desc: '',
      args: [],
    );
  }

  /// `gluten-free`
  String get glutenFree {
    return Intl.message(
      'gluten-free',
      name: 'glutenFree',
      desc: '',
      args: [],
    );
  }

  /// `kosher`
  String get kosher {
    return Intl.message(
      'kosher',
      name: 'kosher',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contactUsPageTitle {
    return Intl.message(
      'Contact Us',
      name: 'contactUsPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get aboutPageTitle {
    return Intl.message(
      'About',
      name: 'aboutPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Invite Friends`
  String get inviteFriendsBtn {
    return Intl.message(
      'Invite Friends',
      name: 'inviteFriendsBtn',
      desc: '',
      args: [],
    );
  }

  /// `No nearby results`
  String get searchNoPointsFound {
    return Intl.message(
      'No nearby results',
      name: 'searchNoPointsFound',
      desc: '',
      args: [],
    );
  }

  /// `What are we eating?`
  String get searchHintText {
    return Intl.message(
      'What are we eating?',
      name: 'searchHintText',
      desc: '',
      args: [],
    );
  }

  /// `My kitchen`
  String get pointsPageTitle {
    return Intl.message(
      'My kitchen',
      name: 'pointsPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Looks like you haven't posted any points yet.`
  String get looksLikeYouHaveNotPostedAnyPointsYet {
    return Intl.message(
      'Looks like you haven\'t posted any points yet.',
      name: 'looksLikeYouHaveNotPostedAnyPointsYet',
      desc: '',
      args: [],
    );
  }

  /// `Unavailable`
  String get unavailable {
    return Intl.message(
      'Unavailable',
      name: 'unavailable',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get available {
    return Intl.message(
      'Available',
      name: 'available',
      desc: '',
      args: [],
    );
  }

  /// `Available points appear on the map with your name, address and the phone number you registered with.`
  String get availableHelperText {
    return Intl.message(
      'Available points appear on the map with your name, address and the phone number you registered with.',
      name: 'availableHelperText',
      desc: '',
      args: [],
    );
  }

  /// `Tags`
  String get tags {
    return Intl.message(
      'Tags',
      name: 'tags',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Discard Changes?`
  String get discardChangesAlertTitle {
    return Intl.message(
      'Discard Changes?',
      name: 'discardChangesAlertTitle',
      desc: '',
      args: [],
    );
  }

  /// `Update Point`
  String get updatePointPageTitle {
    return Intl.message(
      'Update Point',
      name: 'updatePointPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Successfully updated`
  String get pointUpdatedSuccessfully {
    return Intl.message(
      'Successfully updated',
      name: 'pointUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Create Point`
  String get createPointPageTitle {
    return Intl.message(
      'Create Point',
      name: 'createPointPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Successfully posted`
  String get pointPostedSuccessfully {
    return Intl.message(
      'Successfully posted',
      name: 'pointPostedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Successfully created`
  String get pointCreatedSuccessfully {
    return Intl.message(
      'Successfully created',
      name: 'pointCreatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Select image`
  String get pickImageBtn {
    return Intl.message(
      'Select image',
      name: 'pickImageBtn',
      desc: '',
      args: [],
    );
  }

  /// `Select image source`
  String get imageSourceBtn {
    return Intl.message(
      'Select image source',
      name: 'imageSourceBtn',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get imageSourceGalleryBtn {
    return Intl.message(
      'Gallery',
      name: 'imageSourceGalleryBtn',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get imageSourceCameraBtn {
    return Intl.message(
      'Camera',
      name: 'imageSourceCameraBtn',
      desc: '',
      args: [],
    );
  }

  /// `Affiliate Terms & Privacy Policy`
  String get partnersTermsOfServicePageTitle {
    return Intl.message(
      'Affiliate Terms & Privacy Policy',
      name: 'partnersTermsOfServicePageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Terms & Privacy Policy`
  String get termsOfServicePageTitle {
    return Intl.message(
      'Terms & Privacy Policy',
      name: 'termsOfServicePageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get accountPageTitle {
    return Intl.message(
      'Account',
      name: 'accountPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Update Account`
  String get updateAccountPageTitle {
    return Intl.message(
      'Update Account',
      name: 'updateAccountPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Successfully updated`
  String get accountUpdatedSuccessfully {
    return Intl.message(
      'Successfully updated',
      name: 'accountUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccountPageTitle {
    return Intl.message(
      'Create Account',
      name: 'createAccountPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginPageTitle {
    return Intl.message(
      'Login',
      name: 'loginPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Display name`
  String get displayName {
    return Intl.message(
      'Display name',
      name: 'displayName',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `City, street and house number.`
  String get addressHelperText {
    return Intl.message(
      'City, street and house number.',
      name: 'addressHelperText',
      desc: '',
      args: [],
    );
  }

  /// `Verification Code`
  String get otp {
    return Intl.message(
      'Verification Code',
      name: 'otp',
      desc: '',
      args: [],
    );
  }

  /// `Invalid verification code`
  String get otpError {
    return Intl.message(
      'Invalid verification code',
      name: 'otpError',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Digits only, no hyphens or spaces`
  String get phoneNumberError {
    return Intl.message(
      'Digits only, no hyphens or spaces',
      name: 'phoneNumberError',
      desc: '',
      args: [],
    );
  }

  /// `Add food point`
  String get createPointBtnTooltip {
    return Intl.message(
      'Add food point',
      name: 'createPointBtnTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Add point`
  String get createPointBtn {
    return Intl.message(
      'Add point',
      name: 'createPointBtn',
      desc: '',
      args: [],
    );
  }

  /// `I accept the terms of service`
  String get acceptTermsOfServiceBtn {
    return Intl.message(
      'I accept the terms of service',
      name: 'acceptTermsOfServiceBtn',
      desc: '',
      args: [],
    );
  }

  /// `If you have not received an SMS from us, click here.`
  String get sendSMSAgainBtn {
    return Intl.message(
      'If you have not received an SMS from us, click here.',
      name: 'sendSMSAgainBtn',
      desc: '',
      args: [],
    );
  }

  /// `Discard changed`
  String get discardBtn {
    return Intl.message(
      'Discard changed',
      name: 'discardBtn',
      desc: '',
      args: [],
    );
  }

  /// `Post`
  String get postBtn {
    return Intl.message(
      'Post',
      name: 'postBtn',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get saveBtn {
    return Intl.message(
      'Save',
      name: 'saveBtn',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueBtn {
    return Intl.message(
      'Continue',
      name: 'continueBtn',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelBtn {
    return Intl.message(
      'Cancel',
      name: 'cancelBtn',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get tryAgainBtn {
    return Intl.message(
      'Try again',
      name: 'tryAgainBtn',
      desc: '',
      args: [],
    );
  }

  /// `Error! Check your internet connection and try again.`
  String get internetError {
    return Intl.message(
      'Error! Check your internet connection and try again.',
      name: 'internetError',
      desc: '',
      args: [],
    );
  }

  /// `Invalid`
  String get invalid {
    return Intl.message(
      'Invalid',
      name: 'invalid',
      desc: '',
      args: [],
    );
  }

  /// `Error! Check your input and try again.`
  String get error {
    return Intl.message(
      'Error! Check your input and try again.',
      name: 'error',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'he'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}