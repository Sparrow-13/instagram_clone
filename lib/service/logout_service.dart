import 'package:instagram_clone/context/cache_service.dart';
import 'package:instagram_clone/context/global_context.dart';
import 'package:instagram_clone/service/auth_service.dart';

class LogoutService {
  void logout() {
    AuthService().logoutUser();
    CacheService().emptyCache();
    GlobalContext().removeUser();
  }
}
