import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @continueAsCustomer.
  ///
  /// In en, this message translates to:
  /// **'Continue as Customer'**
  String get continueAsCustomer;

  /// No description provided for @continueAsPractitioner.
  ///
  /// In en, this message translates to:
  /// **'Continue as Practitioner'**
  String get continueAsPractitioner;

  /// No description provided for @continueAsOrganization.
  ///
  /// In en, this message translates to:
  /// **'Continue as Organization'**
  String get continueAsOrganization;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @signupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started'**
  String get signupSubtitle;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @enterEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter email and password'**
  String get enterEmailPassword;

  /// No description provided for @accessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access Denied'**
  String get accessDenied;

  /// No description provided for @unknownRole.
  ///
  /// In en, this message translates to:
  /// **'Unknown role or incomplete profile for role:'**
  String get unknownRole;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login Failed'**
  String get loginFailed;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'No user found for that email.'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password provided.'**
  String get wrongPassword;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'The email address is invalid.'**
  String get invalidEmail;

  /// No description provided for @undefinedError.
  ///
  /// In en, this message translates to:
  /// **'An undefined error occurred.'**
  String get undefinedError;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedError;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @loginToContinue.
  ///
  /// In en, this message translates to:
  /// **'Login to continue'**
  String get loginToContinue;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello {name}!'**
  String helloUser(Object name);

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'We’re glad to have you here'**
  String get welcomeMessage;

  /// No description provided for @helpNow.
  ///
  /// In en, this message translates to:
  /// **'HELP NOW'**
  String get helpNow;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'CHECK IN'**
  String get checkIn;

  /// No description provided for @training.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get training;

  /// No description provided for @toolsResources.
  ///
  /// In en, this message translates to:
  /// **'TOOLS AND RESOURCES'**
  String get toolsResources;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @inbox.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get inbox;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @accessRestricted.
  ///
  /// In en, this message translates to:
  /// **'Access Restricted'**
  String get accessRestricted;

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'You must login to access this feature.'**
  String get loginRequired;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// No description provided for @activities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get activities;

  /// No description provided for @quiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quiz;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @signInToAccess.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access all features'**
  String get signInToAccess;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmMessage;

  /// No description provided for @toolsAndResources.
  ///
  /// In en, this message translates to:
  /// **'Tools and Resources'**
  String get toolsAndResources;

  /// No description provided for @loginRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'You must login to access this feature.'**
  String get loginRequiredMessage;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// No description provided for @signInToAccessAllFeatures.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access all features'**
  String get signInToAccessAllFeatures;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'MindAssist'**
  String get appName;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @howAreYouToday.
  ///
  /// In en, this message translates to:
  /// **'How are you doing today?'**
  String get howAreYouToday;

  /// No description provided for @pressAgainToExit.
  ///
  /// In en, this message translates to:
  /// **'Press again to exit'**
  String get pressAgainToExit;

  /// No description provided for @translate.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translate;

  /// No description provided for @trainingScreen.
  ///
  /// In en, this message translates to:
  /// **'Training Screen'**
  String get trainingScreen;

  /// No description provided for @welcomeBackEmoji.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back 👋'**
  String get welcomeBackEmoji;

  /// No description provided for @processingPayment.
  ///
  /// In en, this message translates to:
  /// **'Processing your payment...'**
  String get processingPayment;

  /// No description provided for @paymentCompleted.
  ///
  /// In en, this message translates to:
  /// **'Payment Completed!'**
  String get paymentCompleted;

  /// No description provided for @updatingAccess.
  ///
  /// In en, this message translates to:
  /// **'Updating your training access...'**
  String get updatingAccess;

  /// No description provided for @trainingUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Training unlocked successfully!'**
  String get trainingUnlocked;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get paymentFailed;

  /// No description provided for @completePaymentToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Please complete payment to unlock training'**
  String get completePaymentToUnlock;

  /// No description provided for @startTraining.
  ///
  /// In en, this message translates to:
  /// **'Start Training'**
  String get startTraining;

  /// No description provided for @unlockTraining.
  ///
  /// In en, this message translates to:
  /// **'Unlock Training'**
  String get unlockTraining;

  /// No description provided for @module1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Introduction to Mental Health First Aid'**
  String get module1Title;

  /// No description provided for @module1Description.
  ///
  /// In en, this message translates to:
  /// **'Overview and public health importance of mental health'**
  String get module1Description;

  /// No description provided for @module2Title.
  ///
  /// In en, this message translates to:
  /// **'2. Understanding Common Mental Health Disorders'**
  String get module2Title;

  /// No description provided for @module2Description.
  ///
  /// In en, this message translates to:
  /// **'Understanding mental disorders and psychological problems'**
  String get module2Description;

  /// No description provided for @module3Title.
  ///
  /// In en, this message translates to:
  /// **'3. The ALGEE Action Plan'**
  String get module3Title;

  /// No description provided for @module3Description.
  ///
  /// In en, this message translates to:
  /// **'Assess for Risk of Suicide or Harm'**
  String get module3Description;

  /// No description provided for @module4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Workplace-Specific MHFA'**
  String get module4Title;

  /// No description provided for @module4Description.
  ///
  /// In en, this message translates to:
  /// **'Recognizing workplace challenges and legal considerations'**
  String get module4Description;

  /// No description provided for @module5Title.
  ///
  /// In en, this message translates to:
  /// **'5. Cultural Humility & Equity'**
  String get module5Title;

  /// No description provided for @module5Description.
  ///
  /// In en, this message translates to:
  /// **'Ask: “Is there anything culturally important I should be aware of to better support you?'**
  String get module5Description;

  /// No description provided for @module6Title.
  ///
  /// In en, this message translates to:
  /// **'6. Recognizing Crisis Situations'**
  String get module6Title;

  /// No description provided for @module6Description.
  ///
  /// In en, this message translates to:
  /// **'De-escalation techniques'**
  String get module6Description;

  /// No description provided for @module7Title.
  ///
  /// In en, this message translates to:
  /// **'7. Ongoing Support'**
  String get module7Title;

  /// No description provided for @module7Description.
  ///
  /// In en, this message translates to:
  /// **'I’m here to support you, but I’m not a clinician. Let’s involve someone who can provide more specialized care.'**
  String get module7Description;

  /// No description provided for @module8Title.
  ///
  /// In en, this message translates to:
  /// **'8. Practical Skills Training'**
  String get module8Title;

  /// No description provided for @module8Description.
  ///
  /// In en, this message translates to:
  /// **'Practical skill for leads to better mental health'**
  String get module8Description;

  /// No description provided for @module9Title.
  ///
  /// In en, this message translates to:
  /// **'9. Self-Care for MHFA Helpers'**
  String get module9Title;

  /// No description provided for @module9Description.
  ///
  /// In en, this message translates to:
  /// **'The role of self-care in Mental Health First Aid'**
  String get module9Description;

  /// No description provided for @profileLocked.
  ///
  /// In en, this message translates to:
  /// **'Profile Locked'**
  String get profileLocked;

  /// No description provided for @profileLockedDesc.
  ///
  /// In en, this message translates to:
  /// **'You must login to view and edit your profile.'**
  String get profileLockedDesc;

  /// No description provided for @loginNow.
  ///
  /// In en, this message translates to:
  /// **'Login Now'**
  String get loginNow;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @userId.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userId;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @currentTier.
  ///
  /// In en, this message translates to:
  /// **'Current Tier'**
  String get currentTier;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @preferredPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Preferred Payment Method'**
  String get preferredPaymentMethod;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @insurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get insurance;

  /// No description provided for @both.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get both;

  /// No description provided for @findPractitioner.
  ///
  /// In en, this message translates to:
  /// **'Find Practitioner'**
  String get findPractitioner;

  /// No description provided for @upgradePremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium 9.99 USD'**
  String get upgradePremium;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @notAssigned.
  ///
  /// In en, this message translates to:
  /// **'Not assigned'**
  String get notAssigned;

  /// No description provided for @noRecordFound.
  ///
  /// In en, this message translates to:
  /// **'No record found.'**
  String get noRecordFound;

  /// No description provided for @loginToViewProfile.
  ///
  /// In en, this message translates to:
  /// **'Please login to view profile.'**
  String get loginToViewProfile;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Profile update failed.'**
  String get profileUpdateFailed;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// No description provided for @updateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfile;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @callFailed.
  ///
  /// In en, this message translates to:
  /// **'Call Failed'**
  String get callFailed;

  /// No description provided for @callNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Unable to dial {phone}. This device may not support phone calls.'**
  String callNotSupported(Object phone);

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @couldNotOpenMessaging.
  ///
  /// In en, this message translates to:
  /// **'Could not open messaging app'**
  String get couldNotOpenMessaging;

  /// No description provided for @suggestResource.
  ///
  /// In en, this message translates to:
  /// **'Suggest a Resource'**
  String get suggestResource;

  /// No description provided for @suggestResourceDesc.
  ///
  /// In en, this message translates to:
  /// **'Know a helpful hotline, website, or organization? Let us know!'**
  String get suggestResourceDesc;

  /// No description provided for @enterResourceDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter resource details...'**
  String get enterResourceDetails;

  /// No description provided for @submitSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Submit Suggestion'**
  String get submitSuggestion;

  /// No description provided for @thankYouSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Thank you! We will review your suggestion.'**
  String get thankYouSuggestion;

  /// No description provided for @dailyQuote.
  ///
  /// In en, this message translates to:
  /// **'Daily Quote'**
  String get dailyQuote;

  /// No description provided for @emergencyCall.
  ///
  /// In en, this message translates to:
  /// **'Emergency Call ({phone})'**
  String emergencyCall(Object phone);

  /// No description provided for @immediateSupport.
  ///
  /// In en, this message translates to:
  /// **'Immediate Support'**
  String get immediateSupport;

  /// No description provided for @suicideCrisis.
  ///
  /// In en, this message translates to:
  /// **'Suicide & Crisis Lifeline'**
  String get suicideCrisis;

  /// No description provided for @suicideCrisisDesc.
  ///
  /// In en, this message translates to:
  /// **'Call 988 for free, confidential support'**
  String get suicideCrisisDesc;

  /// No description provided for @localCrisis.
  ///
  /// In en, this message translates to:
  /// **'Local Crisis Line'**
  String get localCrisis;

  /// No description provided for @localCrisisDesc.
  ///
  /// In en, this message translates to:
  /// **'Available 24/7 for emotional support'**
  String get localCrisisDesc;

  /// No description provided for @textFriend.
  ///
  /// In en, this message translates to:
  /// **'Text a Friend'**
  String get textFriend;

  /// No description provided for @textFriendDesc.
  ///
  /// In en, this message translates to:
  /// **'Reach out to your trusted contacts'**
  String get textFriendDesc;

  /// No description provided for @guidedVoiceCoach.
  ///
  /// In en, this message translates to:
  /// **'Guided Voice Coach'**
  String get guidedVoiceCoach;

  /// No description provided for @guidedVoiceCoachDesc.
  ///
  /// In en, this message translates to:
  /// **'Calming exercises and meditation'**
  String get guidedVoiceCoachDesc;

  /// No description provided for @dailyCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Daily Check-In'**
  String get dailyCheckIn;

  /// No description provided for @howFeelingToday.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling today?'**
  String get howFeelingToday;

  /// No description provided for @happy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get happy;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @okay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get okay;

  /// No description provided for @sad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get sad;

  /// No description provided for @stressed.
  ///
  /// In en, this message translates to:
  /// **'Stressed'**
  String get stressed;

  /// No description provided for @angry.
  ///
  /// In en, this message translates to:
  /// **'Angry'**
  String get angry;

  /// No description provided for @addShortNote.
  ///
  /// In en, this message translates to:
  /// **'Add a short note (optional)'**
  String get addShortNote;

  /// No description provided for @writeFeeling.
  ///
  /// In en, this message translates to:
  /// **'Write how you\'re feeling...'**
  String get writeFeeling;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @submitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get submitting;

  /// No description provided for @mustLoginMood.
  ///
  /// In en, this message translates to:
  /// **'You must login to check in your mood.'**
  String get mustLoginMood;

  /// No description provided for @selectMoodFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a mood first!'**
  String get selectMoodFirst;

  /// No description provided for @checkInSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Check-in submitted!'**
  String get checkInSubmitted;

  /// No description provided for @yourCheckIns.
  ///
  /// In en, this message translates to:
  /// **'Your Check-ins'**
  String get yourCheckIns;

  /// No description provided for @resources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get resources;

  /// No description provided for @resources_header.
  ///
  /// In en, this message translates to:
  /// **'Helpful Resources for Your Well-being'**
  String get resources_header;

  /// No description provided for @mental_health_articles.
  ///
  /// In en, this message translates to:
  /// **'Mental Health Articles'**
  String get mental_health_articles;

  /// No description provided for @mental_health_articles_sub.
  ///
  /// In en, this message translates to:
  /// **'Read verified guides and expert tips'**
  String get mental_health_articles_sub;

  /// No description provided for @nearby_clinics.
  ///
  /// In en, this message translates to:
  /// **'Nearby Clinics & Help Centers'**
  String get nearby_clinics;

  /// No description provided for @nearby_clinics_sub.
  ///
  /// In en, this message translates to:
  /// **'Find professional help around you'**
  String get nearby_clinics_sub;

  /// No description provided for @therapeutic_audios.
  ///
  /// In en, this message translates to:
  /// **'Therapeutic Audios'**
  String get therapeutic_audios;

  /// No description provided for @therapeutic_audios_sub.
  ///
  /// In en, this message translates to:
  /// **'Relax your mind with expert audio sessions'**
  String get therapeutic_audios_sub;

  /// No description provided for @self_care_tools.
  ///
  /// In en, this message translates to:
  /// **'Self-care & Journaling Tools'**
  String get self_care_tools;

  /// No description provided for @self_care_tools_sub.
  ///
  /// In en, this message translates to:
  /// **'Track mood, gratitude, and emotions'**
  String get self_care_tools_sub;

  /// No description provided for @audio_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get audio_error;

  /// No description provided for @now_playing.
  ///
  /// In en, this message translates to:
  /// **'Now Playing'**
  String get now_playing;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @track_cooper_title.
  ///
  /// In en, this message translates to:
  /// **'Cooper Creek Meditation'**
  String get track_cooper_title;

  /// No description provided for @track_cooper_author.
  ///
  /// In en, this message translates to:
  /// **'Forest Sounds'**
  String get track_cooper_author;

  /// No description provided for @track_jindalba_title.
  ///
  /// In en, this message translates to:
  /// **'Jindalba River Flute'**
  String get track_jindalba_title;

  /// No description provided for @track_jindalba_author.
  ///
  /// In en, this message translates to:
  /// **'Ancient Flute'**
  String get track_jindalba_author;

  /// No description provided for @track_healing_title.
  ///
  /// In en, this message translates to:
  /// **'Healing Meditation Music'**
  String get track_healing_title;

  /// No description provided for @track_healing_author.
  ///
  /// In en, this message translates to:
  /// **'Spiritual Healing'**
  String get track_healing_author;

  /// No description provided for @track_focus_title.
  ///
  /// In en, this message translates to:
  /// **'Mental Health Focus'**
  String get track_focus_title;

  /// No description provided for @track_focus_author.
  ///
  /// In en, this message translates to:
  /// **'Focus Music'**
  String get track_focus_author;

  /// No description provided for @track_clinic_title.
  ///
  /// In en, this message translates to:
  /// **'Clinic Relaxation'**
  String get track_clinic_title;

  /// No description provided for @track_clinic_author.
  ///
  /// In en, this message translates to:
  /// **'Healthcare Music'**
  String get track_clinic_author;

  /// No description provided for @track_zen_title.
  ///
  /// In en, this message translates to:
  /// **'Ancient Voices Zen'**
  String get track_zen_title;

  /// No description provided for @track_zen_author.
  ///
  /// In en, this message translates to:
  /// **'Yoga Meditation'**
  String get track_zen_author;

  /// No description provided for @track_world_title.
  ///
  /// In en, this message translates to:
  /// **'World Mental Health Day'**
  String get track_world_title;

  /// No description provided for @track_world_author.
  ///
  /// In en, this message translates to:
  /// **'Awareness'**
  String get track_world_author;

  /// No description provided for @settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings ⚙️'**
  String get settings_title;

  /// No description provided for @settings_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settings_account;

  /// No description provided for @settings_edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get settings_edit_profile;

  /// No description provided for @settings_edit_profile_sub.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get settings_edit_profile_sub;

  /// No description provided for @settings_security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settings_security;

  /// No description provided for @settings_security_sub.
  ///
  /// In en, this message translates to:
  /// **'Update your account security'**
  String get settings_security_sub;

  /// No description provided for @settings_manage_subscription.
  ///
  /// In en, this message translates to:
  /// **'Manage Subscription'**
  String get settings_manage_subscription;

  /// No description provided for @settings_manage_subscription_sub.
  ///
  /// In en, this message translates to:
  /// **'Upgrade or cancel your plan'**
  String get settings_manage_subscription_sub;

  /// No description provided for @settings_privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settings_privacy;

  /// No description provided for @settings_privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settings_privacy_policy;

  /// No description provided for @settings_privacy_policy_sub.
  ///
  /// In en, this message translates to:
  /// **'View app privacy details'**
  String get settings_privacy_policy_sub;

  /// No description provided for @settings_help_support.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get settings_help_support;

  /// No description provided for @settings_faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get settings_faq;

  /// No description provided for @settings_faq_sub.
  ///
  /// In en, this message translates to:
  /// **'Common questions and answers'**
  String get settings_faq_sub;

  /// No description provided for @settings_contact_support.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get settings_contact_support;

  /// No description provided for @settings_contact_support_sub.
  ///
  /// In en, this message translates to:
  /// **'Get in touch with our support team'**
  String get settings_contact_support_sub;

  /// No description provided for @security_title.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security_title;

  /// No description provided for @email_verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get email_verified;

  /// No description provided for @email_not_verified.
  ///
  /// In en, this message translates to:
  /// **'Not Verified'**
  String get email_not_verified;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @change_password_button.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password_button;

  /// No description provided for @password_min_length.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get password_min_length;

  /// No description provided for @passwords_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwords_do_not_match;

  /// No description provided for @password_changed_success.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get password_changed_success;

  /// No description provided for @verification_email_sent.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent'**
  String get verification_email_sent;

  /// No description provided for @verification_email_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send verification email'**
  String get verification_email_failed;

  /// No description provided for @two_factor_auth.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get two_factor_auth;

  /// No description provided for @coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get coming_soon;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyPolicyHeader.
  ///
  /// In en, this message translates to:
  /// **'MindAssist Privacy Policy'**
  String get privacyPolicyHeader;

  /// No description provided for @privacyPolicyIntro.
  ///
  /// In en, this message translates to:
  /// **'We value your privacy. This Privacy Policy explains how MindAssist collects, uses, and protects your personal information when you use our services.'**
  String get privacyPolicyIntro;

  /// No description provided for @informationWeCollect.
  ///
  /// In en, this message translates to:
  /// **'1. Information We Collect'**
  String get informationWeCollect;

  /// No description provided for @informationDetails.
  ///
  /// In en, this message translates to:
  /// **'- Name, email, and account information\n- App usage data to improve user experience\n- Messages exchanged with mental health practitioners (encrypted)'**
  String get informationDetails;

  /// No description provided for @howWeUseInfo.
  ///
  /// In en, this message translates to:
  /// **'2. How We Use Your Information'**
  String get howWeUseInfo;

  /// No description provided for @howWeUseInfoDetails.
  ///
  /// In en, this message translates to:
  /// **'- To provide mental health support\n- To improve app features and performance\n- To ensure user safety and compliance with policies'**
  String get howWeUseInfoDetails;

  /// No description provided for @dataProtection.
  ///
  /// In en, this message translates to:
  /// **'3. Data Protection'**
  String get dataProtection;

  /// No description provided for @dataProtectionDetails.
  ///
  /// In en, this message translates to:
  /// **'We use modern encryption and security protocols to protect user data. Your conversations and personal details are kept confidential and never shared with third parties without your consent.'**
  String get dataProtectionDetails;

  /// No description provided for @yourRights.
  ///
  /// In en, this message translates to:
  /// **'4. Your Rights'**
  String get yourRights;

  /// No description provided for @yourRightsDetails.
  ///
  /// In en, this message translates to:
  /// **'- You can request deletion of your data\n- You may update your profile anytime\n- You can opt out of data collection features'**
  String get yourRightsDetails;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'5. Contact Us'**
  String get contactUs;

  /// No description provided for @contactDetails.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions regarding this Privacy Policy, you may contact our support team at: support@mindassist.app'**
  String get contactDetails;

  /// No description provided for @otherPractitioner.
  ///
  /// In en, this message translates to:
  /// **'Other Practitioner'**
  String get otherPractitioner;

  /// No description provided for @premiumClientsTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium Clients 👑'**
  String get premiumClientsTitle;

  /// No description provided for @premiumClientsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Registered users with completed payments.'**
  String get premiumClientsSubtitle;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterMessaged.
  ///
  /// In en, this message translates to:
  /// **'Messaged'**
  String get filterMessaged;

  /// No description provided for @filterNotMessaged.
  ///
  /// In en, this message translates to:
  /// **'Not Messaged'**
  String get filterNotMessaged;

  /// No description provided for @noProfileData.
  ///
  /// In en, this message translates to:
  /// **'No profile data found'**
  String get noProfileData;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// No description provided for @paymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatus;

  /// No description provided for @aboutMe.
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get aboutMe;

  /// No description provided for @contactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Info'**
  String get contactInfo;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @speciality.
  ///
  /// In en, this message translates to:
  /// **'Speciality'**
  String get speciality;

  /// No description provided for @yearsOfExperience.
  ///
  /// In en, this message translates to:
  /// **'Years of Experience'**
  String get yearsOfExperience;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @failedToUpdate.
  ///
  /// In en, this message translates to:
  /// **'Failed to update'**
  String get failedToUpdate;

  /// No description provided for @failedToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get failedToLoadProfile;

  /// No description provided for @imageUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Image upload failed'**
  String get imageUploadFailed;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
