import 'package:instagram_clone/service/user_service.dart';
import 'package:instagram_clone/utils/log_utility.dart';

import '../entity/user/user.dart';

class LoginService {
  Future<User?>? checkLogin(String username, String password) async {
    User? user = await UserService().getUserByUsername(username);
    if (user != null && user.password == password) {
      LoggingService.logStatement("User Found : ${user.toMap()}");
      return user;
    } else {
      LoggingService.logStatement("User Not Found");
    }
    return null;
  }

  Future<User?>? upsertUserIfNotExists(
      String username, String email, String password, String fullName) async {
    User? user = await UserService().getUserByUsername(username);
    if (user != null) {
      LoggingService.logStatement("User Exists : ${user.toMap()}");
      return null;
    } else {
      LoggingService.logStatement("new User");
      var user = User(
          id: "",
          userName: username,
          email: email,
          fullName: fullName,
          bio: "",
          followers: [],
          following: [],
          request: [],
          password: password,
          savedPost: [],
          imageUrl:
              "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/240px-Default_pfp.svg.png");
      UserService().addUser(user);
      var fetchUser = UserService().getUserByUsername(username);
      return fetchUser;
    }
  }
}
