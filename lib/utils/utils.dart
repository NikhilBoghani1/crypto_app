import 'package:crypto_app/controller/assets_controller.dart';
import 'package:crypto_app/services/http_service.dart';
import 'package:get/get.dart';

Future<void> registerServices() async {
  Get.put(
    HttpService(),
  );
}

Future<void> registerController() async {
  Get.put(
    AssetsController(),
  );
}

String getCryptoImageURL(String name) {
  return "https://raw.githubusercontent.com/ErikThiart/cryptocurrency-icons/master/128/${name.toLowerCase()}.png";
}
