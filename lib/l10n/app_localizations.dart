import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ne.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ne'),
  ];

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language and continue'**
  String get chooseLanguage;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @getStartedButton.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStartedButton;

  /// No description provided for @okButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okButton;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @updateButton.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateButton;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Access Rare Products'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover high-demand, hard-to-find goods from trusted vendors.'**
  String get onboarding1Subtitle;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Safe, Verified, and Transparent'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'We prioritize security so your business \n runs smoothly.'**
  String get onboarding2Subtitle;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Ready to Trade Smarter?'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Join Totto and unlock new business \n opportunities.'**
  String get onboarding3Subtitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get navChat;

  /// No description provided for @navOrder.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get navOrder;

  /// No description provided for @navMarketplace.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get navMarketplace;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCode;

  /// No description provided for @enterCodeSentTo.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to {phoneNumber}'**
  String enterCodeSentTo(String phoneNumber);

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @didNotReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code?'**
  String get didNotReceiveCode;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @resendOtpIn.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP in {countdown}s'**
  String resendOtpIn(String countdown);

  /// No description provided for @failedToResendOtp.
  ///
  /// In en, this message translates to:
  /// **'Failed to resend OTP.'**
  String get failedToResendOtp;

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP. Please try again.'**
  String get invalidOtp;

  /// No description provided for @otpVerification.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerification;

  /// No description provided for @enterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Phone Number'**
  String get enterYourPhoneNumber;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @getOtp.
  ///
  /// In en, this message translates to:
  /// **'Get OTP'**
  String get getOtp;

  /// No description provided for @failedToSendOtp.
  ///
  /// In en, this message translates to:
  /// **'Failed to send OTP. Please try again.'**
  String get failedToSendOtp;

  /// No description provided for @enterValid10DigitNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 10-digit number.'**
  String get enterValid10DigitNumber;

  /// No description provided for @byLoggingInYouAgree.
  ///
  /// In en, this message translates to:
  /// **'By logging in, you agree to Totto’s\n'**
  String get byLoggingInYouAgree;

  /// No description provided for @homeHeaderTitlePart1.
  ///
  /// In en, this message translates to:
  /// **'Buy and Sell Smarter with '**
  String get homeHeaderTitlePart1;

  /// No description provided for @homeHeaderTitlePart2.
  ///
  /// In en, this message translates to:
  /// **'Totto.'**
  String get homeHeaderTitlePart2;

  /// No description provided for @homeHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Whether you\'re buying essentials or listing your unique inventory, Totto brings the right people together.'**
  String get homeHeaderSubtitle;

  /// No description provided for @startSelling.
  ///
  /// In en, this message translates to:
  /// **'Start Selling'**
  String get startSelling;

  /// No description provided for @buyProducts.
  ///
  /// In en, this message translates to:
  /// **'Buy Products'**
  String get buyProducts;

  /// No description provided for @discoverGroupsTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover & Manage Groups'**
  String get discoverGroupsTitle;

  /// No description provided for @discoverGroupsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quickly jump into your business communities for buying, selling, and networking.'**
  String get discoverGroupsSubtitle;

  /// No description provided for @chatBazaar.
  ///
  /// In en, this message translates to:
  /// **'Chat Bazaar'**
  String get chatBazaar;

  /// No description provided for @essentialTier.
  ///
  /// In en, this message translates to:
  /// **'Essential Tier'**
  String get essentialTier;

  /// No description provided for @standardTier.
  ///
  /// In en, this message translates to:
  /// **'Standard Tier'**
  String get standardTier;

  /// No description provided for @premiumTier.
  ///
  /// In en, this message translates to:
  /// **'Premium Tier'**
  String get premiumTier;

  /// No description provided for @viewButton.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get viewButton;

  /// No description provided for @joinButton.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get joinButton;

  /// No description provided for @activeChats.
  ///
  /// In en, this message translates to:
  /// **'Active Chats'**
  String get activeChats;

  /// No description provided for @noActiveChats.
  ///
  /// In en, this message translates to:
  /// **'Your active group chats will appear here.'**
  String get noActiveChats;

  /// No description provided for @errorCouldNotLoadChatBazaar.
  ///
  /// In en, this message translates to:
  /// **'Could not load Chat Bazaar: {error}'**
  String errorCouldNotLoadChatBazaar(String error);

  /// No description provided for @errorLoadingGroups.
  ///
  /// In en, this message translates to:
  /// **'Error loading groups: {error}'**
  String errorLoadingGroups(String error);

  /// No description provided for @noNewGroupsToJoin.
  ///
  /// In en, this message translates to:
  /// **'No new groups to join in this tier.'**
  String get noNewGroupsToJoin;

  /// No description provided for @createNewChatGroup.
  ///
  /// In en, this message translates to:
  /// **'Create New Chat Group'**
  String get createNewChatGroup;

  /// No description provided for @successfullyJoinedGroup.
  ///
  /// In en, this message translates to:
  /// **'Successfully joined \"{groupName}\"!'**
  String successfullyJoinedGroup(String groupName);

  /// No description provided for @newGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'New Group'**
  String get newGroupTitle;

  /// No description provided for @enterGroupName.
  ///
  /// In en, this message translates to:
  /// **'Enter Group Name'**
  String get enterGroupName;

  /// No description provided for @groupRules.
  ///
  /// In en, this message translates to:
  /// **'Groups Rules / Guidelines'**
  String get groupRules;

  /// No description provided for @groupRulesHint.
  ///
  /// In en, this message translates to:
  /// **'Write any internal rules or notes for this group...'**
  String get groupRulesHint;

  /// No description provided for @selectGroupTier.
  ///
  /// In en, this message translates to:
  /// **'Select Group Tier'**
  String get selectGroupTier;

  /// No description provided for @selectBusinessType.
  ///
  /// In en, this message translates to:
  /// **'Select Business Type'**
  String get selectBusinessType;

  /// No description provided for @uploadIcon.
  ///
  /// In en, this message translates to:
  /// **'Upload or choose icon'**
  String get uploadIcon;

  /// No description provided for @createGroup.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get createGroup;

  /// No description provided for @creatingGroup.
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get creatingGroup;

  /// No description provided for @groupCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Group created successfully!'**
  String get groupCreatedSuccess;

  /// No description provided for @groupCreationError.
  ///
  /// In en, this message translates to:
  /// **'Please fill in the group name and select a business type.'**
  String get groupCreationError;

  /// No description provided for @errorCouldNotLoadCategories.
  ///
  /// In en, this message translates to:
  /// **'Could not load categories: {error}'**
  String errorCouldNotLoadCategories(String error);

  /// No description provided for @failedToLoadMessages.
  ///
  /// In en, this message translates to:
  /// **'Failed to load messages: {error}'**
  String failedToLoadMessages(String error);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @messageHint.
  ///
  /// In en, this message translates to:
  /// **'message..'**
  String get messageHint;

  /// No description provided for @chatSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat Settings'**
  String get chatSettingsTitle;

  /// No description provided for @participants.
  ///
  /// In en, this message translates to:
  /// **'{count} participants'**
  String participants(String count);

  /// No description provided for @groupMembers.
  ///
  /// In en, this message translates to:
  /// **'Group Members'**
  String get groupMembers;

  /// No description provided for @editName.
  ///
  /// In en, this message translates to:
  /// **'Edit Name'**
  String get editName;

  /// No description provided for @contactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact info'**
  String get contactInfo;

  /// No description provided for @muteNotifications.
  ///
  /// In en, this message translates to:
  /// **'Mute notifications'**
  String get muteNotifications;

  /// No description provided for @leaveGroup.
  ///
  /// In en, this message translates to:
  /// **'Leave Group'**
  String get leaveGroup;

  /// No description provided for @deleteGroup.
  ///
  /// In en, this message translates to:
  /// **'Delete Group'**
  String get deleteGroup;

  /// No description provided for @editGroupNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Group Name'**
  String get editGroupNameTitle;

  /// No description provided for @newGroupNameHint.
  ///
  /// In en, this message translates to:
  /// **'New group name'**
  String get newGroupNameHint;

  /// No description provided for @leaveGroupDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave Group'**
  String get leaveGroupDialogTitle;

  /// No description provided for @leaveGroupDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave this group?'**
  String get leaveGroupDialogContent;

  /// No description provided for @leaveGroupSuccess.
  ///
  /// In en, this message translates to:
  /// **'You have left the group.'**
  String get leaveGroupSuccess;

  /// No description provided for @leaveGroupError.
  ///
  /// In en, this message translates to:
  /// **'Error: Could not find your membership in this group.'**
  String get leaveGroupError;

  /// No description provided for @couldNotGetUser.
  ///
  /// In en, this message translates to:
  /// **'Could not get user data. Please try again.'**
  String get couldNotGetUser;

  /// No description provided for @deleteGroupDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Group'**
  String get deleteGroupDialogTitle;

  /// No description provided for @deleteGroupDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete this group? This action cannot be undone.'**
  String get deleteGroupDialogContent;

  /// No description provided for @groupDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Group has been deleted.'**
  String get groupDeletedSuccess;

  /// No description provided for @groupNameUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Group name updated!'**
  String get groupNameUpdatedSuccess;

  /// No description provided for @addMembers.
  ///
  /// In en, this message translates to:
  /// **'Add Members'**
  String get addMembers;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @member.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get member;

  /// No description provided for @makeMember.
  ///
  /// In en, this message translates to:
  /// **'Make Member'**
  String get makeMember;

  /// No description provided for @makeAdmin.
  ///
  /// In en, this message translates to:
  /// **'Make Admin'**
  String get makeAdmin;

  /// No description provided for @removeMember.
  ///
  /// In en, this message translates to:
  /// **'Remove Member'**
  String get removeMember;

  /// No description provided for @marketplaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get marketplaceTitle;

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFound;

  /// No description provided for @failedToLoadProducts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load products: {error}'**
  String failedToLoadProducts(String error);

  /// No description provided for @vendorLabel.
  ///
  /// In en, this message translates to:
  /// **'Vendor: {vendorName}'**
  String vendorLabel(String vendorName);

  /// No description provided for @productDetailErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get productDetailErrorTitle;

  /// No description provided for @failedToLoadProduct.
  ///
  /// In en, this message translates to:
  /// **'Failed to load product: {error}'**
  String failedToLoadProduct(String error);

  /// No description provided for @orderNow.
  ///
  /// In en, this message translates to:
  /// **'Order Now'**
  String get orderNow;

  /// No description provided for @chatSeller.
  ///
  /// In en, this message translates to:
  /// **'Chat Seller'**
  String get chatSeller;

  /// No description provided for @productDetailsOf.
  ///
  /// In en, this message translates to:
  /// **'Product details of {productName}'**
  String productDetailsOf(String productName);

  /// No description provided for @addToMarket.
  ///
  /// In en, this message translates to:
  /// **'Add to Market'**
  String get addToMarket;

  /// No description provided for @enterProductName.
  ///
  /// In en, this message translates to:
  /// **'Enter Product Name'**
  String get enterProductName;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get productName;

  /// No description provided for @uploadProductCatalogs.
  ///
  /// In en, this message translates to:
  /// **'Upload Product Catalogs'**
  String get uploadProductCatalogs;

  /// No description provided for @clickToUploadCatalogs.
  ///
  /// In en, this message translates to:
  /// **'Click to upload Catalogs'**
  String get clickToUploadCatalogs;

  /// No description provided for @uploadProductImages.
  ///
  /// In en, this message translates to:
  /// **'Upload Product Images'**
  String get uploadProductImages;

  /// No description provided for @clickToUploadImages.
  ///
  /// In en, this message translates to:
  /// **'Click to upload Images'**
  String get clickToUploadImages;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @priceExample.
  ///
  /// In en, this message translates to:
  /// **'E.g 10.00'**
  String get priceExample;

  /// No description provided for @remarks.
  ///
  /// In en, this message translates to:
  /// **'Remarks (Message)'**
  String get remarks;

  /// No description provided for @writeSomething.
  ///
  /// In en, this message translates to:
  /// **'Write Something...'**
  String get writeSomething;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProduct;

  /// No description provided for @pleaseSelectAUnit.
  ///
  /// In en, this message translates to:
  /// **'Please select a unit.'**
  String get pleaseSelectAUnit;

  /// No description provided for @pleaseSelectACategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category.'**
  String get pleaseSelectACategory;

  /// No description provided for @priceCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Price cannot be empty.'**
  String get priceCannotBeEmpty;

  /// No description provided for @myOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'My Order'**
  String get myOrderTitle;

  /// No description provided for @orderDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Order deleted successfully'**
  String get orderDeletedSuccess;

  /// No description provided for @deleteError.
  ///
  /// In en, this message translates to:
  /// **'Delete Error: {error}'**
  String deleteError(String error);

  /// No description provided for @statusUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Status updated successfully!'**
  String get statusUpdatedSuccess;

  /// No description provided for @updateError.
  ///
  /// In en, this message translates to:
  /// **'Update Error: {error}'**
  String updateError(String error);

  /// No description provided for @tabDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get tabDelivered;

  /// No description provided for @tabReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get tabReceived;

  /// No description provided for @noOrdersFound.
  ///
  /// In en, this message translates to:
  /// **'No orders found.'**
  String get noOrdersFound;

  /// No description provided for @noOrdersMatchFilter.
  ///
  /// In en, this message translates to:
  /// **'There are no orders matching the current filter.'**
  String get noOrdersMatchFilter;

  /// No description provided for @updateOrderStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Order Status'**
  String get updateOrderStatusTitle;

  /// No description provided for @updateOrderStatusContent.
  ///
  /// In en, this message translates to:
  /// **'Choose the new status for this order:'**
  String get updateOrderStatusContent;

  /// No description provided for @markAsShipped.
  ///
  /// In en, this message translates to:
  /// **'Mark as Shipped'**
  String get markAsShipped;

  /// No description provided for @markAsDelivered.
  ///
  /// In en, this message translates to:
  /// **'Mark as Delivered'**
  String get markAsDelivered;

  /// No description provided for @deleteOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Order'**
  String get deleteOrderTitle;

  /// No description provided for @deleteOrderContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this order? This action cannot be undone.'**
  String get deleteOrderContent;

  /// No description provided for @updateStatusButton.
  ///
  /// In en, this message translates to:
  /// **'Update Status'**
  String get updateStatusButton;

  /// No description provided for @buyerLabel.
  ///
  /// In en, this message translates to:
  /// **'Buyer: {name}'**
  String buyerLabel(String name);

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String statusLabel(String status);

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity: {quantity} Units'**
  String quantityLabel(String quantity);

  /// No description provided for @orderNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Order {number}'**
  String orderNumberLabel(String number);

  /// No description provided for @tierLabel.
  ///
  /// In en, this message translates to:
  /// **'Tier: {tier}'**
  String tierLabel(String tier);

  /// No description provided for @urgencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Urgency: {urgency}'**
  String urgencyLabel(String urgency);

  /// No description provided for @orderPlacementTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Placement'**
  String get orderPlacementTitle;

  /// No description provided for @updateOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Order'**
  String get updateOrderTitle;

  /// No description provided for @productNameCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Product name cannot be empty.'**
  String get productNameCannotBeEmpty;

  /// No description provided for @quantityCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Quantity cannot be empty.'**
  String get quantityCannotBeEmpty;

  /// No description provided for @pleaseEnterValidQuantity.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid quantity.'**
  String get pleaseEnterValidQuantity;

  /// No description provided for @orderUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Order updated successfully!'**
  String get orderUpdatedSuccess;

  /// No description provided for @orderPlacedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Order placed successfully!'**
  String get orderPlacedSuccess;

  /// No description provided for @errorUpdatingOrder.
  ///
  /// In en, this message translates to:
  /// **'Error Updating Order'**
  String get errorUpdatingOrder;

  /// No description provided for @errorPlacingOrder.
  ///
  /// In en, this message translates to:
  /// **'Error Placing Order'**
  String get errorPlacingOrder;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred.'**
  String get unknownError;

  /// No description provided for @requestForQuotation.
  ///
  /// In en, this message translates to:
  /// **'Request for Quotation'**
  String get requestForQuotation;

  /// No description provided for @enterQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter Quantity*'**
  String get enterQuantity;

  /// No description provided for @productUrgency.
  ///
  /// In en, this message translates to:
  /// **'Product Urgency*'**
  String get productUrgency;

  /// No description provided for @selectUrgency.
  ///
  /// In en, this message translates to:
  /// **'Select Urgency'**
  String get selectUrgency;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @searchButton.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchButton;

  /// No description provided for @tabAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get tabAll;

  /// No description provided for @tabGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get tabGroup;

  /// No description provided for @tabProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get tabProduct;

  /// No description provided for @tabPeople.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get tabPeople;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @entireNepal.
  ///
  /// In en, this message translates to:
  /// **'Entire Nepal'**
  String get entireNepal;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRange;

  /// No description provided for @priceRangeTo.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get priceRangeTo;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Results ({count})'**
  String results(String count);

  /// Text to display when a search yields no results
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String errorOccurred(String error);

  /// No description provided for @profilePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profilePageTitle;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @myOrdersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track orders'**
  String get myOrdersSubtitle;

  /// No description provided for @profileVisibility.
  ///
  /// In en, this message translates to:
  /// **'Profile visibility'**
  String get profileVisibility;

  /// No description provided for @profileVisibilitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hide Profile'**
  String get profileVisibilitySubtitle;

  /// No description provided for @kycDetails.
  ///
  /// In en, this message translates to:
  /// **'KYC Details'**
  String get kycDetails;

  /// No description provided for @kycDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View and Edit your KYC Details'**
  String get kycDetailsSubtitle;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @appSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Language, App preferences'**
  String get appSettingsSubtitle;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyDot.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy.'**
  String get privacyPolicyDot;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @logoutConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logoutConfirmationTitle;

  /// No description provided for @logoutConfirmationBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmationBody;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @englishLanguage.
  ///
  /// In en, this message translates to:
  /// **'English (US)'**
  String get englishLanguage;

  /// No description provided for @nepaliLanguage.
  ///
  /// In en, this message translates to:
  /// **'Nepali'**
  String get nepaliLanguage;

  /// No description provided for @englishSubtitle.
  ///
  /// In en, this message translates to:
  /// **'(English)'**
  String get englishSubtitle;

  /// No description provided for @nepaliSubtitle.
  ///
  /// In en, this message translates to:
  /// **'(नेपाली)'**
  String get nepaliSubtitle;

  /// No description provided for @englishAndNepali.
  ///
  /// In en, this message translates to:
  /// **'English and नेपाली'**
  String get englishAndNepali;

  /// No description provided for @languageMixedSubtitle.
  ///
  /// In en, this message translates to:
  /// **''**
  String get languageMixedSubtitle;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @mySpecialItemTitle.
  ///
  /// In en, this message translates to:
  /// **'My Products'**
  String get mySpecialItemTitle;

  /// No description provided for @mySpecialItemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get mySpecialItemSubtitle;

  /// No description provided for @usagePolicySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Usage policy'**
  String get usagePolicySubtitle;

  /// No description provided for @dataUseInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Data use info'**
  String get dataUseInfoSubtitle;

  /// No description provided for @tottoPointsTitle.
  ///
  /// In en, this message translates to:
  /// **'Totto Points'**
  String get tottoPointsTitle;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMore;

  /// No description provided for @updateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfile;

  /// No description provided for @changeUserDetails.
  ///
  /// In en, this message translates to:
  /// **'Change User Details'**
  String get changeUserDetails;

  /// No description provided for @changeAvatar.
  ///
  /// In en, this message translates to:
  /// **'Change Avatar'**
  String get changeAvatar;

  /// No description provided for @avatarUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Avatar updated successfully!'**
  String get avatarUpdatedSuccess;

  /// No description provided for @avatarUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Avatar update failed. Please try again.'**
  String get avatarUpdateFailed;

  /// No description provided for @userNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'User not logged in.'**
  String get userNotLoggedIn;

  /// No description provided for @errorFetchingKyc.
  ///
  /// In en, this message translates to:
  /// **'Error fetching KYC status: {error}'**
  String errorFetchingKyc(String error);

  /// No description provided for @errorLoadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error loading profile: {error}'**
  String errorLoadingProfile(String error);

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @orderUpdates.
  ///
  /// In en, this message translates to:
  /// **'Order Updates'**
  String get orderUpdates;

  /// No description provided for @newMessages.
  ///
  /// In en, this message translates to:
  /// **'New Messages'**
  String get newMessages;

  /// No description provided for @groupActivity.
  ///
  /// In en, this message translates to:
  /// **'Group Activity'**
  String get groupActivity;

  /// No description provided for @notificationSound.
  ///
  /// In en, this message translates to:
  /// **'Notification Sound'**
  String get notificationSound;

  /// No description provided for @defaultSound.
  ///
  /// In en, this message translates to:
  /// **'Totto Default Sound'**
  String get defaultSound;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @profileVisibilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Visibility'**
  String get profileVisibilityTitle;

  /// No description provided for @accountVisibility.
  ///
  /// In en, this message translates to:
  /// **'Account Visibility'**
  String get accountVisibility;

  /// No description provided for @privateAccount.
  ///
  /// In en, this message translates to:
  /// **'Private Account'**
  String get privateAccount;

  /// No description provided for @publicAccount.
  ///
  /// In en, this message translates to:
  /// **'Public Account'**
  String get publicAccount;

  /// No description provided for @privateAccountInfo.
  ///
  /// In en, this message translates to:
  /// **'Your Profile is only visible to your connected groups.'**
  String get privateAccountInfo;

  /// No description provided for @privateAccountSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Your profile is currently private. Update your settings to connect with more vendors.'**
  String get privateAccountSuggestion;

  /// No description provided for @publicAccountInfo.
  ///
  /// In en, this message translates to:
  /// **'Your Profile is only visible to :'**
  String get publicAccountInfo;

  /// No description provided for @allUsers.
  ///
  /// In en, this message translates to:
  /// **'All Users'**
  String get allUsers;

  /// No description provided for @verifiedVendorsOnly.
  ///
  /// In en, this message translates to:
  /// **'Verified Vendors Only'**
  String get verifiedVendorsOnly;

  /// No description provided for @myGroupsOnly.
  ///
  /// In en, this message translates to:
  /// **'My Groups Only'**
  String get myGroupsOnly;

  /// No description provided for @kycErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get kycErrorTitle;

  /// No description provided for @kycErrorLoadingStatus.
  ///
  /// In en, this message translates to:
  /// **'Could not load KYC status: {error}'**
  String kycErrorLoadingStatus(String error);

  /// No description provided for @kycRejectedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your previous submission was rejected. Please review your details and submit the form again.'**
  String get kycRejectedMessage;

  /// No description provided for @kycFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Totto KYC Form'**
  String get kycFormTitle;

  /// No description provided for @kycVerifiedTitle.
  ///
  /// In en, this message translates to:
  /// **'KYC Verified'**
  String get kycVerifiedTitle;

  /// No description provided for @kycVerifiedContent.
  ///
  /// In en, this message translates to:
  /// **'Your KYC has been successfully verified.'**
  String get kycVerifiedContent;

  /// No description provided for @kycAlreadyVerified.
  ///
  /// In en, this message translates to:
  /// **'Your KYC is Already Verified'**
  String get kycAlreadyVerified;

  /// No description provided for @updateKycInformation.
  ///
  /// In en, this message translates to:
  /// **'Update KYC Information'**
  String get updateKycInformation;

  /// No description provided for @kycSubmittedTitle.
  ///
  /// In en, this message translates to:
  /// **'KYC Submitted'**
  String get kycSubmittedTitle;

  /// No description provided for @kycSubmittedContent.
  ///
  /// In en, this message translates to:
  /// **'Your KYC details are currently under review.'**
  String get kycSubmittedContent;

  /// No description provided for @kycPendingReview.
  ///
  /// In en, this message translates to:
  /// **'Your KYC details have been submitted and are currently under review.'**
  String get kycPendingReview;

  /// No description provided for @kycErrorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data: {error}'**
  String kycErrorLoadingData(String error);

  /// No description provided for @kycBasicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get kycBasicInformation;

  /// No description provided for @kycFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get kycFullName;

  /// No description provided for @kycDobHint.
  ///
  /// In en, this message translates to:
  /// **'DD/MM/YYYY'**
  String get kycDobHint;

  /// No description provided for @kycChooseGender.
  ///
  /// In en, this message translates to:
  /// **'Choose Gender'**
  String get kycChooseGender;

  /// No description provided for @kycMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get kycMale;

  /// No description provided for @kycFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get kycFemale;

  /// No description provided for @kycOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get kycOther;

  /// No description provided for @kycAddPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Add Phone Number'**
  String get kycAddPhoneNumber;

  /// No description provided for @kycAddEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Add Email Address'**
  String get kycAddEmailAddress;

  /// No description provided for @kycNextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get kycNextButton;

  /// No description provided for @kycPermanentAddress.
  ///
  /// In en, this message translates to:
  /// **'Permanent Address'**
  String get kycPermanentAddress;

  /// No description provided for @kycProvince.
  ///
  /// In en, this message translates to:
  /// **'Province'**
  String get kycProvince;

  /// No description provided for @kycDistrict.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get kycDistrict;

  /// No description provided for @kycMunicipality.
  ///
  /// In en, this message translates to:
  /// **'Municipality / Rural Municipality'**
  String get kycMunicipality;

  /// No description provided for @kycWardNumber.
  ///
  /// In en, this message translates to:
  /// **'Ward Number'**
  String get kycWardNumber;

  /// No description provided for @kycToleStreetArea.
  ///
  /// In en, this message translates to:
  /// **'Tole / Street / Area Name'**
  String get kycToleStreetArea;

  /// No description provided for @kycCurrentAddress.
  ///
  /// In en, this message translates to:
  /// **'Current Address'**
  String get kycCurrentAddress;

  /// No description provided for @kycSameAsPermanent.
  ///
  /// In en, this message translates to:
  /// **'Same as permanent'**
  String get kycSameAsPermanent;

  /// No description provided for @kycIdentityVerification.
  ///
  /// In en, this message translates to:
  /// **'Identity Verification'**
  String get kycIdentityVerification;

  /// No description provided for @kycChooseDocument.
  ///
  /// In en, this message translates to:
  /// **'Choose Document'**
  String get kycChooseDocument;

  /// No description provided for @kycCitizenship.
  ///
  /// In en, this message translates to:
  /// **'Citizenship'**
  String get kycCitizenship;

  /// No description provided for @kycPassport.
  ///
  /// In en, this message translates to:
  /// **'Passport'**
  String get kycPassport;

  /// No description provided for @kycDriversLicense.
  ///
  /// In en, this message translates to:
  /// **'Driver\'s License'**
  String get kycDriversLicense;

  /// No description provided for @kycDocumentNumber.
  ///
  /// In en, this message translates to:
  /// **'Document Number'**
  String get kycDocumentNumber;

  /// No description provided for @kycUploadDocumentImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Document Image'**
  String get kycUploadDocumentImage;

  /// No description provided for @kycUploadDocFront.
  ///
  /// In en, this message translates to:
  /// **'Upload Document Front'**
  String get kycUploadDocFront;

  /// No description provided for @kycUploadDocBack.
  ///
  /// In en, this message translates to:
  /// **'Upload Document Back'**
  String get kycUploadDocBack;

  /// No description provided for @kycUploadButton.
  ///
  /// In en, this message translates to:
  /// **'Upload Document'**
  String get kycUploadButton;

  /// No description provided for @kycChangeButton.
  ///
  /// In en, this message translates to:
  /// **'Change Document'**
  String get kycChangeButton;

  /// No description provided for @kycUploadVideoButton.
  ///
  /// In en, this message translates to:
  /// **'Upload Video'**
  String get kycUploadVideoButton;

  /// No description provided for @kycChangeVideoButton.
  ///
  /// In en, this message translates to:
  /// **'Change Video'**
  String get kycChangeVideoButton;

  /// No description provided for @kycUploadShopVideo.
  ///
  /// In en, this message translates to:
  /// **'Upload Videos of your shop'**
  String get kycUploadShopVideo;

  /// No description provided for @kycBusinessDetails.
  ///
  /// In en, this message translates to:
  /// **'Business Details'**
  String get kycBusinessDetails;

  /// No description provided for @kycForVendorsOnly.
  ///
  /// In en, this message translates to:
  /// **'(For vendors only - conditional)'**
  String get kycForVendorsOnly;

  /// No description provided for @kycBusinessName.
  ///
  /// In en, this message translates to:
  /// **'Business Name'**
  String get kycBusinessName;

  /// No description provided for @kycPanVatNumber.
  ///
  /// In en, this message translates to:
  /// **'PAN/VAT Number (if applicable)'**
  String get kycPanVatNumber;

  /// No description provided for @kycUploadBusinessLicense.
  ///
  /// In en, this message translates to:
  /// **'Upload Business License (Optional)'**
  String get kycUploadBusinessLicense;

  /// No description provided for @kycAgreement.
  ///
  /// In en, this message translates to:
  /// **'I confirm that the above information is accurate and agree to Totto\'s KYC terms.'**
  String get kycAgreement;

  /// No description provided for @kycSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit KYC'**
  String get kycSubmitButton;

  /// No description provided for @kycSubmittingButton.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get kycSubmittingButton;

  /// No description provided for @kycSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get kycSuccessTitle;

  /// No description provided for @kycSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your KYC details have been submitted.'**
  String get kycSuccessMessage;

  /// No description provided for @kycGoToHome.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get kycGoToHome;

  /// No description provided for @kycSubmissionFailed.
  ///
  /// In en, this message translates to:
  /// **'Submission Failed: {error}'**
  String kycSubmissionFailed(String error);

  /// No description provided for @orderDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetailsTitle;

  /// No description provided for @errorLabel.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorLabel;

  /// Error message when order details fail to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load order details: {error}'**
  String errorLoadingOrderDetails(String error);

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @goChatButton.
  ///
  /// In en, this message translates to:
  /// **'Go Chat'**
  String get goChatButton;

  /// No description provided for @sellerInfoNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Seller information is not available for this order.'**
  String get sellerInfoNotAvailable;

  /// No description provided for @findingGroup.
  ///
  /// In en, this message translates to:
  /// **'Finding relevant group...'**
  String get findingGroup;

  /// No description provided for @noMatchingGroupFound.
  ///
  /// In en, this message translates to:
  /// **'No matching group was found for this product.'**
  String get noMatchingGroupFound;

  /// No description provided for @multipleGroupsFound.
  ///
  /// In en, this message translates to:
  /// **'More than one matching group was found. Cannot proceed.'**
  String get multipleGroupsFound;

  /// No description provided for @errorFindingGroup.
  ///
  /// In en, this message translates to:
  /// **'Error finding group: {error}'**
  String errorFindingGroup(Object error);

  /// No description provided for @myProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Products'**
  String get myProductsTitle;

  /// No description provided for @noProductsYet.
  ///
  /// In en, this message translates to:
  /// **'You have not created any products yet.'**
  String get noProductsYet;

  /// Button text for editing a product
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// Button text for deleting a product
  ///
  /// In en, this message translates to:
  /// **'Delete Product'**
  String get deleteProduct;

  /// Title of the dialog asking for confirmation to delete a product
  ///
  /// In en, this message translates to:
  /// **'Delete Product?'**
  String get deleteProductConfirmationTitle;

  /// The message inside the delete confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete this product? This action cannot be undone.'**
  String get deleteProductConfirmationMessage;

  /// Generic button label to cancel an action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButtonLabel;

  /// Generic button label to confirm a delete action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButtonLabel;

  /// Snackbar message shown after a product is deleted
  ///
  /// In en, this message translates to:
  /// **'Product deleted successfully'**
  String get productDeletedSuccessfully;

  /// Generic error message for snackbars
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get anErrorOccurred;

  /// Checkbox label to indicate if the order price can be negotiated
  ///
  /// In en, this message translates to:
  /// **'Price Is Negotiable'**
  String get priceIsNegotiable;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In failed. Please try again.'**
  String get googleSignInFailed;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet. Say hello!'**
  String get noMessagesYet;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ne'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ne':
      return AppLocalizationsNe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
