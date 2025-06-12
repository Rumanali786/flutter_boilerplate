import 'dart:async';
import 'dart:io';

 import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

 import '../../../utils/generated_assets/assets.dart';
import '../../../utils/utils_export.dart';
import 'internet_checker_service.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initConfig() async {
    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 7),
          minimumFetchInterval: const Duration(
            seconds: 10,
          ),
        ),
      );

      bool result = await InternetCheckerClass.checkInternetStatus();

      if (result) {
        await _fetchConfig();
      }
    } on SocketException catch (e) {
      debugPrint("Error in setting Remote Config settings: $e");
    } on TimeoutException catch (e) {
      debugPrint("Error in setting Remote Config settings: $e");
    } catch (e) {
      debugPrint("Error in setting Remote Config settings: $e");
    }
  }

  Future<void> _fetchConfig() async {
    try {
      await remoteConfig.fetchAndActivate();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _fetchAndroidVersion() async {
    try {
      final uri = Uri.https("play.google.com", "/store/apps/details", {"id": AppStrings.packageNameAndroid, "hl": "en_US"});
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception("Invalid response code: ${response.statusCode}");
      }

      final regexp = RegExp(r'\[\[\["(\d+\.\d+(\.[a-z]+)?(\.([^"]|\\")*)?)"\]\]');
      final storeVersion = regexp.firstMatch(response.body)?.group(1);

      if (storeVersion == null) {
        return "0.0.0";
      }

      return storeVersion;
    } catch (e) {
      return "0.0.0";
    }
  }

  Future<void> getVersions({required BuildContext context}) async {
    String version;
    bool forceUpdate = remoteConfig.getBool("force_update");
    final info = await PackageInfo.fromPlatform();
     double currentVersion = double.parse(info.version.trim().replaceAll('.', ''));
    if (Platform.isAndroid) {
      String storeStringVersion = await _fetchAndroidVersion();
      if (storeStringVersion != "0.0.0") {
        version = storeStringVersion.replaceAll('.', '');
      } else {
        version = remoteConfig.getString('android_version');
      }
    } else {
      version = remoteConfig.getString('ios_version');
    }
    try {
      final newVersion = double.parse(version.trim().replaceAll('.', ''));

      if (newVersion > currentVersion) {
        if (context.mounted) {
          showConfirmationDialogue(
            context,
            forceUpdate,
                () async {
              final appId = Platform.isAndroid ? AppStrings.packageNameAndroid : AppStrings.appIdIos;
              final url = Uri.parse(
                Platform.isAndroid ? 'market://details?id=$appId' : 'https://apps.apple.com/app/id$appId',
              );
              await launchUrl(
                url,
                mode: LaunchMode.externalApplication,
              );
            },
            'New version of the app is available!'.tr,
            'Would you like to update to latest version ?'.tr,
          );
        }
      }
    } catch (exception) {
      debugPrint("Error while checking for version from remote config: $exception");
    }
  }

  void showConfirmationDialogue(
      BuildContext context, bool forceUpdate, VoidCallback positiveClosure, String title, String description) {
    final theme = context.theme;
    showDialog<AlertDialog>(
      barrierDismissible: !forceUpdate,
      barrierLabel: '',
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 25),
          contentPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          content: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: Image.asset(
                      Assets.imagesWarning,
                      height: 60,
                      width: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: context.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: context.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(AppColors.primaryColor),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () {
                          context.pop();
                          positiveClosure.call();
                        },
                        child: Text(
                          "UPDATE".tr,
                          style: context.titleMedium?.copyWith(color: AppColors.whiteColor),
                        ),
                      ),
                      forceUpdate
                          ? const SizedBox.shrink()
                          : TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: Text("CANCEL".tr),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
