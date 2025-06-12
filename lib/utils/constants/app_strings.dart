class AppStrings {
  static const String privacyPolicy = "https://sites.google.com/adzspec.com/denadlakoranen/privacy-policy";
  static const String tC = "https://sites.google.com/d/1QkqKCqYkCxbQ8j1i5LYvgagT_MHNtm0H/p/1tWzfeiwxovXOcYMSZSVF18vtAGo-06lH/edit";
  static const String packageNameAndroid = "com.noble.quran.koran.app";
  static const String appIdIos = "6740514791";
  static const String swishDonationNumber = "6736363610";

  static String swishPaymentUrl(amount) {
    return "https://app.swish.nu/1/p/sw/?sw=$swishDonationNumber&amt=$amount.0&msg=Donation";
  }
}