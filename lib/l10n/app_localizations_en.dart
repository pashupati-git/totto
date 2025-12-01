// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'Language';

  @override
  String get chooseLanguage => 'Choose your preferred language and continue';

  @override
  String get continueButton => 'Continue';

  @override
  String get nextButton => 'Next';

  @override
  String get getStartedButton => 'Get Started';

  @override
  String get okButton => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get deleteButton => 'Delete';

  @override
  String get updateButton => 'Update';

  @override
  String get and => ' and ';

  @override
  String get select => 'Select';

  @override
  String get unit => 'Unit';

  @override
  String get onboarding1Title => 'Access Rare Products';

  @override
  String get onboarding1Subtitle =>
      'Discover high-demand, hard-to-find goods from trusted vendors.';

  @override
  String get onboarding2Title => 'Safe, Verified, and Transparent';

  @override
  String get onboarding2Subtitle =>
      'We prioritize security so your business \n runs smoothly.';

  @override
  String get onboarding3Title => 'Ready to Trade Smarter?';

  @override
  String get onboarding3Subtitle =>
      'Join Totto and unlock new business \n opportunities.';

  @override
  String get navHome => 'Home';

  @override
  String get navChat => 'Chat';

  @override
  String get navOrder => 'Order';

  @override
  String get navMarketplace => 'Marketplace';

  @override
  String get navProfile => 'Profile';

  @override
  String get verificationCode => 'Verification Code';

  @override
  String enterCodeSentTo(String phoneNumber) {
    return 'Enter the code sent to $phoneNumber';
  }

  @override
  String get verify => 'Verify';

  @override
  String get didNotReceiveCode => 'Didn\'t receive code?';

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String resendOtpIn(String countdown) {
    return 'Resend OTP in ${countdown}s';
  }

  @override
  String get failedToResendOtp => 'Failed to resend OTP.';

  @override
  String get invalidOtp => 'Invalid OTP. Please try again.';

  @override
  String get otpVerification => 'OTP Verification';

  @override
  String get enterYourPhoneNumber => 'Enter Your Phone Number';

  @override
  String get mobileNumber => 'Mobile Number';

  @override
  String get getOtp => 'Get OTP';

  @override
  String get failedToSendOtp => 'Failed to send OTP. Please try again.';

  @override
  String get enterValid10DigitNumber => 'Please enter a valid 10-digit number.';

  @override
  String get byLoggingInYouAgree => 'By logging in, you agree to Totto’s\n';

  @override
  String get homeHeaderTitlePart1 => 'Buy and Sell Smarter with ';

  @override
  String get homeHeaderTitlePart2 => 'Totto.';

  @override
  String get homeHeaderSubtitle =>
      'Whether you\'re buying essentials or listing your unique inventory, Totto brings the right people together.';

  @override
  String get startSelling => 'Start Selling';

  @override
  String get buyProducts => 'Buy Products';

  @override
  String get discoverGroupsTitle => 'Discover & Manage Groups';

  @override
  String get discoverGroupsSubtitle =>
      'Quickly jump into your business communities for buying, selling, and networking.';

  @override
  String get chatBazaar => 'Chat Bazaar';

  @override
  String get essentialTier => 'Essential Tier';

  @override
  String get standardTier => 'Standard Tier';

  @override
  String get premiumTier => 'Premium Tier';

  @override
  String get viewButton => 'View';

  @override
  String get joinButton => 'Join';

  @override
  String get activeChats => 'Active Chats';

  @override
  String get noActiveChats => 'Your active group chats will appear here.';

  @override
  String errorCouldNotLoadChatBazaar(String error) {
    return 'Could not load Chat Bazaar: $error';
  }

  @override
  String errorLoadingGroups(String error) {
    return 'Error loading groups: $error';
  }

  @override
  String get noNewGroupsToJoin => 'No new groups to join in this tier.';

  @override
  String get createNewChatGroup => 'Create New Chat Group';

  @override
  String successfullyJoinedGroup(String groupName) {
    return 'Successfully joined \"$groupName\"!';
  }

  @override
  String get newGroupTitle => 'New Group';

  @override
  String get enterGroupName => 'Enter Group Name';

  @override
  String get groupRules => 'Groups Rules / Guidelines';

  @override
  String get groupRulesHint =>
      'Write any internal rules or notes for this group...';

  @override
  String get selectGroupTier => 'Select Group Tier';

  @override
  String get selectBusinessType => 'Select Business Type';

  @override
  String get uploadIcon => 'Upload or choose icon';

  @override
  String get createGroup => 'Create Group';

  @override
  String get creatingGroup => 'Creating...';

  @override
  String get groupCreatedSuccess => 'Group created successfully!';

  @override
  String get groupCreationError =>
      'Please fill in the group name and select a business type.';

  @override
  String errorCouldNotLoadCategories(String error) {
    return 'Could not load categories: $error';
  }

  @override
  String failedToLoadMessages(String error) {
    return 'Failed to load messages: $error';
  }

  @override
  String get today => 'Today';

  @override
  String get messageHint => 'message..';

  @override
  String get chatSettingsTitle => 'Chat Settings';

  @override
  String participants(String count) {
    return '$count participants';
  }

  @override
  String get groupMembers => 'Group Members';

  @override
  String get editName => 'Edit Name';

  @override
  String get contactInfo => 'Contact info';

  @override
  String get muteNotifications => 'Mute notifications';

  @override
  String get leaveGroup => 'Leave Group';

  @override
  String get deleteGroup => 'Delete Group';

  @override
  String get editGroupNameTitle => 'Edit Group Name';

  @override
  String get newGroupNameHint => 'New group name';

  @override
  String get leaveGroupDialogTitle => 'Leave Group';

  @override
  String get leaveGroupDialogContent =>
      'Are you sure you want to leave this group?';

  @override
  String get leaveGroupSuccess => 'You have left the group.';

  @override
  String get leaveGroupError =>
      'Error: Could not find your membership in this group.';

  @override
  String get couldNotGetUser => 'Could not get user data. Please try again.';

  @override
  String get deleteGroupDialogTitle => 'Delete Group';

  @override
  String get deleteGroupDialogContent =>
      'Are you sure you want to permanently delete this group? This action cannot be undone.';

  @override
  String get groupDeletedSuccess => 'Group has been deleted.';

  @override
  String get groupNameUpdatedSuccess => 'Group name updated!';

  @override
  String get addMembers => 'Add Members';

  @override
  String get admin => 'Admin';

  @override
  String get member => 'Member';

  @override
  String get makeMember => 'Make Member';

  @override
  String get makeAdmin => 'Make Admin';

  @override
  String get removeMember => 'Remove Member';

  @override
  String get marketplaceTitle => 'Marketplace';

  @override
  String get noProductsFound => 'No products found';

  @override
  String failedToLoadProducts(String error) {
    return 'Failed to load products: $error';
  }

  @override
  String vendorLabel(String vendorName) {
    return 'Vendor: $vendorName';
  }

  @override
  String get productDetailErrorTitle => 'Error';

  @override
  String failedToLoadProduct(String error) {
    return 'Failed to load product: $error';
  }

  @override
  String get orderNow => 'Order Now';

  @override
  String get chatSeller => 'Chat Seller';

  @override
  String productDetailsOf(String productName) {
    return 'Product details of $productName';
  }

  @override
  String get addToMarket => 'Add to Market';

  @override
  String get enterProductName => 'Enter Product Name';

  @override
  String get productName => 'Product name';

  @override
  String get uploadProductCatalogs => 'Upload Product Catalogs';

  @override
  String get clickToUploadCatalogs => 'Click to upload Catalogs';

  @override
  String get uploadProductImages => 'Upload Product Images';

  @override
  String get clickToUploadImages => 'Click to upload Images';

  @override
  String get price => 'Price';

  @override
  String get priceExample => 'E.g 10.00';

  @override
  String get remarks => 'Remarks (Message)';

  @override
  String get writeSomething => 'Write Something...';

  @override
  String get addProduct => 'Add Product';

  @override
  String get pleaseSelectAUnit => 'Please select a unit.';

  @override
  String get pleaseSelectACategory => 'Please select a category.';

  @override
  String get priceCannotBeEmpty => 'Price cannot be empty.';

  @override
  String get myOrderTitle => 'My Order';

  @override
  String get orderDeletedSuccess => 'Order deleted successfully';

  @override
  String deleteError(String error) {
    return 'Delete Error: $error';
  }

  @override
  String get statusUpdatedSuccess => 'Status updated successfully!';

  @override
  String updateError(String error) {
    return 'Update Error: $error';
  }

  @override
  String get tabDelivered => 'Delivered';

  @override
  String get tabReceived => 'Received';

  @override
  String get noOrdersFound => 'No orders found.';

  @override
  String get noOrdersMatchFilter =>
      'There are no orders matching the current filter.';

  @override
  String get updateOrderStatusTitle => 'Update Order Status';

  @override
  String get updateOrderStatusContent =>
      'Choose the new status for this order:';

  @override
  String get markAsShipped => 'Mark as Shipped';

  @override
  String get markAsDelivered => 'Mark as Delivered';

  @override
  String get deleteOrderTitle => 'Delete Order';

  @override
  String get deleteOrderContent =>
      'Are you sure you want to delete this order? This action cannot be undone.';

  @override
  String get updateStatusButton => 'Update Status';

  @override
  String buyerLabel(String name) {
    return 'Buyer: $name';
  }

  @override
  String statusLabel(String status) {
    return 'Status: $status';
  }

  @override
  String quantityLabel(String quantity) {
    return 'Quantity: $quantity Units';
  }

  @override
  String orderNumberLabel(String number) {
    return 'Order $number';
  }

  @override
  String tierLabel(String tier) {
    return 'Tier: $tier';
  }

  @override
  String urgencyLabel(String urgency) {
    return 'Urgency: $urgency';
  }

  @override
  String get orderPlacementTitle => 'Order Placement';

  @override
  String get updateOrderTitle => 'Update Order';

  @override
  String get productNameCannotBeEmpty => 'Product name cannot be empty.';

  @override
  String get quantityCannotBeEmpty => 'Quantity cannot be empty.';

  @override
  String get pleaseEnterValidQuantity => 'Please enter a valid quantity.';

  @override
  String get orderUpdatedSuccess => 'Order updated successfully!';

  @override
  String get orderPlacedSuccess => 'Order placed successfully!';

  @override
  String get errorUpdatingOrder => 'Error Updating Order';

  @override
  String get errorPlacingOrder => 'Error Placing Order';

  @override
  String get unknownError => 'An unknown error occurred.';

  @override
  String get requestForQuotation => 'Request for Quotation';

  @override
  String get enterQuantity => 'Enter Quantity*';

  @override
  String get productUrgency => 'Product Urgency*';

  @override
  String get selectUrgency => 'Select Urgency';

  @override
  String get searchTitle => 'Search';

  @override
  String get searchButton => 'Search';

  @override
  String get tabAll => 'All';

  @override
  String get tabGroup => 'Group';

  @override
  String get tabProduct => 'Product';

  @override
  String get tabPeople => 'People';

  @override
  String get location => 'Location';

  @override
  String get entireNepal => 'Entire Nepal';

  @override
  String get priceRange => 'Price Range';

  @override
  String get priceRangeTo => 'to';

  @override
  String get category => 'Category';

  @override
  String results(String count) {
    return 'Results ($count)';
  }

  @override
  String get noResultsFound => 'No results found';

  @override
  String errorOccurred(String error) {
    return 'An error occurred: $error';
  }

  @override
  String get profilePageTitle => 'Profile';

  @override
  String get myOrders => 'My Orders';

  @override
  String get myOrdersSubtitle => 'Track orders';

  @override
  String get profileVisibility => 'Profile visibility';

  @override
  String get profileVisibilitySubtitle => 'Hide Profile';

  @override
  String get kycDetails => 'KYC Details';

  @override
  String get kycDetailsSubtitle => 'View and Edit your KYC Details';

  @override
  String get appSettings => 'App Settings';

  @override
  String get appSettingsSubtitle => 'Language, App preferences';

  @override
  String get termsAndConditions => 'Terms & Conditions';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyDot => 'Privacy Policy.';

  @override
  String get logout => 'Log Out';

  @override
  String get logoutConfirmationTitle => 'Log Out';

  @override
  String get logoutConfirmationBody => 'Are you sure you want to log out?';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get englishLanguage => 'English (US)';

  @override
  String get nepaliLanguage => 'Nepali';

  @override
  String get englishSubtitle => '(English)';

  @override
  String get nepaliSubtitle => '(नेपाली)';

  @override
  String get englishAndNepali => 'English and नेपाली';

  @override
  String get languageMixedSubtitle => '';

  @override
  String get order => 'Order';

  @override
  String get mySpecialItemTitle => 'My Products';

  @override
  String get mySpecialItemSubtitle => 'Products';

  @override
  String get usagePolicySubtitle => 'Usage policy';

  @override
  String get dataUseInfoSubtitle => 'Data use info';

  @override
  String get tottoPointsTitle => 'Totto Points';

  @override
  String get learnMore => 'Learn More';

  @override
  String get updateProfile => 'Update Profile';

  @override
  String get changeUserDetails => 'Change User Details';

  @override
  String get changeAvatar => 'Change Avatar';

  @override
  String get avatarUpdatedSuccess => 'Avatar updated successfully!';

  @override
  String get avatarUpdateFailed => 'Avatar update failed. Please try again.';

  @override
  String get userNotLoggedIn => 'User not logged in.';

  @override
  String errorFetchingKyc(String error) {
    return 'Error fetching KYC status: $error';
  }

  @override
  String errorLoadingProfile(String error) {
    return 'Error loading profile: $error';
  }

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get orderUpdates => 'Order Updates';

  @override
  String get newMessages => 'New Messages';

  @override
  String get groupActivity => 'Group Activity';

  @override
  String get notificationSound => 'Notification Sound';

  @override
  String get defaultSound => 'Totto Default Sound';

  @override
  String get appearance => 'Appearance';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get profileVisibilityTitle => 'Profile Visibility';

  @override
  String get accountVisibility => 'Account Visibility';

  @override
  String get privateAccount => 'Private Account';

  @override
  String get publicAccount => 'Public Account';

  @override
  String get privateAccountInfo =>
      'Your Profile is only visible to your connected groups.';

  @override
  String get privateAccountSuggestion =>
      'Your profile is currently private. Update your settings to connect with more vendors.';

  @override
  String get publicAccountInfo => 'Your Profile is only visible to :';

  @override
  String get allUsers => 'All Users';

  @override
  String get verifiedVendorsOnly => 'Verified Vendors Only';

  @override
  String get myGroupsOnly => 'My Groups Only';

  @override
  String get kycErrorTitle => 'Error';

  @override
  String kycErrorLoadingStatus(String error) {
    return 'Could not load KYC status: $error';
  }

  @override
  String get kycRejectedMessage =>
      'Your previous submission was rejected. Please review your details and submit the form again.';

  @override
  String get kycFormTitle => 'Totto KYC Form';

  @override
  String get kycVerifiedTitle => 'KYC Verified';

  @override
  String get kycVerifiedContent => 'Your KYC has been successfully verified.';

  @override
  String get kycAlreadyVerified => 'Your KYC is Already Verified';

  @override
  String get updateKycInformation => 'Update KYC Information';

  @override
  String get kycSubmittedTitle => 'KYC Submitted';

  @override
  String get kycSubmittedContent =>
      'Your KYC details are currently under review.';

  @override
  String get kycPendingReview =>
      'Your KYC details have been submitted and are currently under review.';

  @override
  String kycErrorLoadingData(String error) {
    return 'Error loading data: $error';
  }

  @override
  String get kycBasicInformation => 'Basic Information';

  @override
  String get kycFullName => 'Full Name';

  @override
  String get kycDobHint => 'DD/MM/YYYY';

  @override
  String get kycChooseGender => 'Choose Gender';

  @override
  String get kycMale => 'Male';

  @override
  String get kycFemale => 'Female';

  @override
  String get kycOther => 'Other';

  @override
  String get kycAddPhoneNumber => 'Add Phone Number';

  @override
  String get kycAddEmailAddress => 'Add Email Address';

  @override
  String get kycNextButton => 'Next';

  @override
  String get kycPermanentAddress => 'Permanent Address';

  @override
  String get kycProvince => 'Province';

  @override
  String get kycDistrict => 'District';

  @override
  String get kycMunicipality => 'Municipality / Rural Municipality';

  @override
  String get kycWardNumber => 'Ward Number';

  @override
  String get kycToleStreetArea => 'Tole / Street / Area Name';

  @override
  String get kycCurrentAddress => 'Current Address';

  @override
  String get kycSameAsPermanent => 'Same as permanent';

  @override
  String get kycIdentityVerification => 'Identity Verification';

  @override
  String get kycChooseDocument => 'Choose Document';

  @override
  String get kycCitizenship => 'Citizenship';

  @override
  String get kycPassport => 'Passport';

  @override
  String get kycDriversLicense => 'Driver\'s License';

  @override
  String get kycDocumentNumber => 'Document Number';

  @override
  String get kycUploadDocumentImage => 'Upload Document Image';

  @override
  String get kycUploadDocFront => 'Upload Document Front';

  @override
  String get kycUploadDocBack => 'Upload Document Back';

  @override
  String get kycUploadButton => 'Upload Document';

  @override
  String get kycChangeButton => 'Change Document';

  @override
  String get kycUploadVideoButton => 'Upload Video';

  @override
  String get kycChangeVideoButton => 'Change Video';

  @override
  String get kycUploadShopVideo => 'Upload Videos of your shop';

  @override
  String get kycBusinessDetails => 'Business Details';

  @override
  String get kycForVendorsOnly => '(For vendors only - conditional)';

  @override
  String get kycBusinessName => 'Business Name';

  @override
  String get kycPanVatNumber => 'PAN/VAT Number (if applicable)';

  @override
  String get kycUploadBusinessLicense => 'Upload Business License (Optional)';

  @override
  String get kycAgreement =>
      'I confirm that the above information is accurate and agree to Totto\'s KYC terms.';

  @override
  String get kycSubmitButton => 'Submit KYC';

  @override
  String get kycSubmittingButton => 'Submitting...';

  @override
  String get kycSuccessTitle => 'Success';

  @override
  String get kycSuccessMessage => 'Your KYC details have been submitted.';

  @override
  String get kycGoToHome => 'Go to Home';

  @override
  String kycSubmissionFailed(String error) {
    return 'Submission Failed: $error';
  }

  @override
  String get orderDetailsTitle => 'Order Details';

  @override
  String get errorLabel => 'Error';

  @override
  String errorLoadingOrderDetails(String error) {
    return 'Failed to load order details: $error';
  }

  @override
  String get dateLabel => 'Date';

  @override
  String get goChatButton => 'Go Chat';

  @override
  String get sellerInfoNotAvailable =>
      'Seller information is not available for this order.';

  @override
  String get findingGroup => 'Finding relevant group...';

  @override
  String get noMatchingGroupFound =>
      'No matching group was found for this product.';

  @override
  String get multipleGroupsFound =>
      'More than one matching group was found. Cannot proceed.';

  @override
  String errorFindingGroup(Object error) {
    return 'Error finding group: $error';
  }

  @override
  String get myProductsTitle => 'My Products';

  @override
  String get noProductsYet => 'You have not created any products yet.';

  @override
  String get editProduct => 'Edit Product';

  @override
  String get deleteProduct => 'Delete Product';

  @override
  String get deleteProductConfirmationTitle => 'Delete Product?';

  @override
  String get deleteProductConfirmationMessage =>
      'Are you sure you want to permanently delete this product? This action cannot be undone.';

  @override
  String get cancelButtonLabel => 'Cancel';

  @override
  String get deleteButtonLabel => 'Delete';

  @override
  String get productDeletedSuccessfully => 'Product deleted successfully';

  @override
  String get anErrorOccurred => 'An error occurred. Please try again.';

  @override
  String get priceIsNegotiable => 'Price Is Negotiable';

  @override
  String get or => 'OR';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get googleSignInFailed => 'Google Sign-In failed. Please try again.';

  @override
  String get noMessagesYet => 'No messages yet. Say hello!';
}
