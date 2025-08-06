import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/auth_repository/repository.dart';
import '../../../utils/extensions/sized_box_extension.dart';
import '../../../utils/utils_export.dart';

class App extends StatefulWidget {
  const App({super.key});

  static final APIClient apiClient = Get.put(
    APIClient(
      authInterceptor: AuthInterceptor(),
    ),
  );

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  static final cacheClient = HiveCacheClient();
  static final authRepo = AuthRepositoryImpl(
    client: App.apiClient,
    cacheClient: cacheClient,
  );


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: genericUnFocus,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: ScaleSize.textScaler(context),
        ),
        child: GetMaterialApp(
          title: 'Flutter BoilerPlate',
          debugShowCheckedModeBanner: false,
          theme: lightTheme(),
          initialBinding: StoreBinding(
            authRepository: authRepo,
            cacheClient: cacheClient,
          ),
          // home: SplashView(),
          // home: AyatVideoView(),
        ),
      ),
    );
  }
}
