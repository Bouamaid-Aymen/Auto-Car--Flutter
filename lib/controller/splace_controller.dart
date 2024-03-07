import 'package:get/get.dart';
import 'package:my_app_car/Adminisrateur/Cars.dart';
import 'package:my_app_car/Adminisrateur/screens/Car.dart';
import 'package:my_app_car/screens/login_page.dart';


class SplaceController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    pageHander();
  }

  void pageHander() async {
    Future.delayed(
      const Duration(seconds: 6),
      () {
        // Get.offAllNamed("/map-page");
        Get.offAll(LoginPage());
        // DropdownScreenState ()
      },
    );
  }
}
