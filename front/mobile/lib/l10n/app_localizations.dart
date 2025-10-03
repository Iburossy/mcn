import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString('lib/l10n/app_${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    
    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  // Getters pour les traductions courantes
  String get appName => translate('appName');
  String get appFullName => translate('appFullName');
  String get welcome => translate('welcome');
  String get welcomeTo => translate('welcomeTo');
  String get discoverHeritage => translate('discoverHeritage');
  String get login => translate('login');
  String get register => translate('register');
  String get logout => translate('logout');
  
  String get email => translate('email');
  String get password => translate('password');
  String get phone => translate('phone');
  String get phonePlaceholder => translate('phonePlaceholder');
  String get fullName => translate('fullName');
  String get fullNamePlaceholder => translate('fullNamePlaceholder');
  String get pinCode => translate('pinCode');
  String get pinPlaceholder => translate('pinPlaceholder');
  String get confirmPassword => translate('confirmPassword');
  String get confirmPin => translate('confirmPin');
  String get emailOptional => translate('emailOptional');
  String get emailPlaceholder => translate('emailPlaceholder');
  
  String get loginTitle => translate('loginTitle');
  String get loginSubtitle => translate('loginSubtitle');
  String get registerTitle => translate('registerTitle');
  String get registerSubtitle => translate('registerSubtitle');
  
  String get noAccount => translate('noAccount');
  String get alreadyHaveAccount => translate('alreadyHaveAccount');
  String get createAccount => translate('createAccount');
  String get signIn => translate('signIn');
  String get continueWithoutAccount => translate('continueWithoutAccount');
  String get forgotPin => translate('forgotPin');
  String get featureComingSoon => translate('featureComingSoon');
  String get or => translate('or');
  String get errorLogin => translate('errorLogin');
  String get errorRegister => translate('errorRegister');
  String get acceptTermsPrefix => translate('acceptTermsPrefix');
  String get acceptTermsConnector => translate('acceptTermsConnector');
  String get acceptTermsRequired => translate('acceptTermsRequired');
  
  String get home => translate('home');
  String get artworks => translate('artworks');
  String get events => translate('events');
  String get visit => translate('visit');
  String get profile => translate('profile');
  
  String get sections => translate('sections');
  String get categories => translate('categories');
  String get search => translate('search');
  String get searchArtworks => translate('searchArtworks');
  String get filter => translate('filter');
  String get sort => translate('sort');
  
  String get all => translate('all');
  String get paintings => translate('paintings');
  String get sculptures => translate('sculptures');
  String get photos => translate('photos');
  String get artifacts => translate('artifacts');
  
  String get artworkDetails => translate('artworkDetails');
  String get artist => translate('artist');
  String get year => translate('year');
  String get description => translate('description');
  String get category => translate('category');
  String get dimensions => translate('dimensions');
  String get materials => translate('materials');
  String get origin => translate('origin');
  String get culturalContext => translate('culturalContext');
  String get viewCount => translate('viewCount');
  String get video => translate('video');
  String get model3D => translate('model3D');
  String get audioDescription => translate('audioDescription');
  String get videoGuide => translate('videoGuide');
  
  String get favorites => translate('favorites');
  String get addToFavorites => translate('addToFavorites');
  String get removeFromFavorites => translate('removeFromFavorites');
  String get explore => translate('explore');
  String get rooms => translate('rooms');
  String get virtualTour => translate('virtualTour');
  String get scanner => translate('scanner');
  
  String get settings => translate('settings');
  String get language => translate('language');
  String get selectLanguage => translate('selectLanguage');
  String get french => translate('french');
  String get english => translate('english');
  String get wolof => translate('wolof');
  String get languageChanged => translate('languageChanged');
  
  String get notifications => translate('notifications');
  String get darkMode => translate('darkMode');
  String get about => translate('about');
  String get privacyPolicy => translate('privacyPolicy');
  String get termsOfService => translate('termsOfService');
  
  String get loading => translate('loading');
  String get error => translate('error');
  String get retry => translate('retry');
  String get cancel => translate('cancel');
  String get save => translate('save');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get share => translate('share');
  
  String get noData => translate('noData');
  String get noArtworks => translate('noArtworks');
  String get noEvents => translate('noEvents');
  String get noFavorites => translate('noFavorites');
  
  String get errorLoadingData => translate('errorLoadingData');
  String get errorLoadingArtworks => translate('errorLoadingArtworks');
  
  String get validationRequired => translate('validationRequired');
  String get validationEmail => translate('validationEmail');
  String get validationPhone => translate('validationPhone');
  String get validationPhoneLength => translate('validationPhoneLength');
  String get validationPasswordLength => translate('validationPasswordLength');
  String get validationPasswordMatch => translate('validationPasswordMatch');
  String get validationNameLength => translate('validationNameLength');
  String get validationPinRequired => translate('validationPinRequired');
  String get validationPinLength => translate('validationPinLength');
  String get validationPinDigits => translate('validationPinDigits');
  String get validationPinConfirm => translate('validationPinConfirm');
  String get validationPinMismatch => translate('validationPinMismatch');
  
  String get onboardingTitle1 => translate('onboardingTitle1');
  String get onboardingDesc1 => translate('onboardingDesc1');
  String get onboardingTitle2 => translate('onboardingTitle2');
  String get onboardingDesc2 => translate('onboardingDesc2');
  String get onboardingTitle3 => translate('onboardingTitle3');
  String get onboardingDesc3 => translate('onboardingDesc3');
  
  String get skip => translate('skip');
  String get next => translate('next');
  String get getStarted => translate('getStarted');
  
  String get viewAll => translate('viewAll');
  String get viewDetails => translate('viewDetails');
  
  String get upcomingEvents => translate('upcomingEvents');
  String get pastEvents => translate('pastEvents');
  String get eventDetails => translate('eventDetails');
  String get date => translate('date');
  String get time => translate('time');
  String get location => translate('location');
  String get registerForEvent => translate('registerForEvent');
  
  String get visitInfo => translate('visitInfo');
  String get openingHours => translate('openingHours');
  String get ticketPrices => translate('ticketPrices');
  String get contactUs => translate('contactUs');
  String get address => translate('address');
  
  String get myProfile => translate('myProfile');
  String get editProfile => translate('editProfile');
  String get changePassword => translate('changePassword');
  String get myFavorites => translate('myFavorites');
  String get myTickets => translate('myTickets');
  
  String get version => translate('version');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['fr', 'en', 'wo'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

