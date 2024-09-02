import 'package:crypto_app/controller/assets_controller.dart';
import 'package:crypto_app/models/api_response.dart';
import 'package:crypto_app/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAssetDialogController extends GetxController {
  RxBool loading = false.obs;
  RxList<String> assets = <String>[].obs;
  RxString selectedAssets = "".obs;
  RxDouble assetValue = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _getAssets();
  }

  Future<void> _getAssets() async {
    loading.value = true;

    HttpService httpService = Get.find<HttpService>();
    var responseData = await httpService.get("currencies");
    CurrenciesListAPIResponse currenciesListAPIResponse =
        CurrenciesListAPIResponse.fromJson(responseData);
    currenciesListAPIResponse.data?.forEach((coin) {
      assets.add(coin.name!);
    });
    selectedAssets.value = assets.first;
    loading.value = false;
  }
}

class AddAssetDialog extends StatelessWidget {
  final controller = Get.put(AddAssetDialogController());

  AddAssetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            child: Container(
              height: Get.height * 0.40,
              width: Get.width * 0.80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: _buildUI(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    if (controller.loading.isTrue) {
      return Center(
        child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButton(
              value: controller.selectedAssets.value,
              items: controller.assets.map(
                (asset) {
                  return DropdownMenuItem(
                    value: asset,
                    child: Text(asset),
                  );
                },
              ).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.selectedAssets.value = value;
                }
              },
            ),
            TextFormField(
              onChanged: (value) {
                controller.assetValue.value = double.parse(value);
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            /*ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 41, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                AssetsController assetsController = Get.find();
                assetsController.addTrackedAsset(
                  controller.selectedAssets.value,
                  controller.assetValue.value,
                );
                Get.back(closeOverlays: true);
              },
              child: Text(
                "Add Asset",
                style: TextStyle(
                  color: Colors.black,
                  // fontSize: 18,
                ),
              ),
            ),*/
            MaterialButton(
                onPressed: () {
                  AssetsController assetsController = Get.find();
                  assetsController.addTrackedAsset(
                    controller.selectedAssets.value,
                    controller.assetValue.value,
                  );
                  Get.back(closeOverlays: true);
                },
                child: Text("Add Asset",
                    style: TextStyle(
                      color: Colors.black,
                      // fontSize: 18,
                    ))),
          ],
        ),
      );
    }
  }
}
