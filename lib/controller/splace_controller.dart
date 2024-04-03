import 'package:get/get.dart';

import 'package:my_app_car/screens/login_page.dart';


class SplaceController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    
  }

  void pageHander() async {
    Future.delayed(
      const Duration(seconds: 6),
      () {
        
        Get.offAll(LoginPage());
        
      },
    );
  }
}
