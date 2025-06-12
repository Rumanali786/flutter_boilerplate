import 'package:get/get.dart';

import '../../domain/auth_repository/repository.dart';
import '../../presentation/app/controller/app_controller.dart';
import '../cache_client/cache_client.dart';

class StoreBinding implements Bindings {
  StoreBinding({
    required this.authRepository,
    required this.cacheClient,
  });

  final AuthRepository authRepository;
  final CacheClient cacheClient;

// default dependency
  @override
  void dependencies() {
    Get
      ..lazyPut<AuthRepository>(() => authRepository)
      ..lazyPut<CacheClient>(() => cacheClient)
      ..lazyPut<AppController>(
        AppController.new,
      );
  }
}
