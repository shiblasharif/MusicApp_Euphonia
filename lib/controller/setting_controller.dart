import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  bool? notify;
  @override
  void onInit() {
    getSwitchValues();
    super.onInit();
  }

  getSwitchValues() async {
    notify = await getSwitchState();
    //setState(() {});
    update();
  }

  Future<bool> getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? notify = prefs.getBool("switchState");
    print(notify);
    return notify ?? true;
  }
}
