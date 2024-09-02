import 'package:crypto_app/const/constants.dart';
import 'package:crypto_app/controller/assets_controller.dart';
import 'package:crypto_app/models/tracked_asset.dart';
import 'package:crypto_app/pages/details/details_page.dart';
import 'package:crypto_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewPortfolioPage extends StatelessWidget {
  AssetsController assetsController = Get.find();
  Constants myConstants = Constants();

  ViewPortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _trackedAssetsList(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      centerTitle: true,
      title: Text(
        "Wallet",
        style: TextStyle(
          fontFamily: myConstants.RobotoR,
        ),
      ),
    );
  }

  Widget _trackedAssetsList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Get.height * 0.05,
            child: Text(
              "Portfolio",
              style: TextStyle(
                fontSize: 18,
                fontFamily: myConstants.RobotoR,
              ),
            ),
          ),
          SizedBox(
            height: Get.height,
            width: Get.width,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: assetsController.trackedAsset.length,
              itemBuilder: (context, index) {
                TrackedAsset trackedAsset =
                    assetsController.trackedAsset[index];
                return Obx(
                  () => ListTile(
                    isThreeLine: true,
                    onTap: () {
                      Get.to(
                        DetailsPage(
                          coin:
                              assetsController.getCoinData(trackedAsset.name!)!,
                        ),
                        transition: Transition.downToUp,
                      );
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        getCryptoImageURL(trackedAsset.name!),
                      ),
                    ),
                    title: Text(trackedAsset.name!),
                    subtitle: Text(
                        "USD : ${assetsController.getAssetPrice(trackedAsset.name!)?.toStringAsFixed(2)}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            Text(
                              trackedAsset.amount.toString(),
                            ),
                            Text(
                              "${assetsController.coinData[index].values?.uSD?.percentChange24h?.toStringAsFixed(2) ?? "N/A"}%", // Add % sign and handle null
                              style: TextStyle(
                                fontSize: 13,
                                color: assetsController.coinData[index].values!
                                    .uSD!.percentChange24h! >
                                    0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        /*IconButton(
                          icon: Icon(CupertinoIcons.minus_circle),
                          onPressed: () {
                            _sellAsset(trackedAsset);
                          },
                        ),*/
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _sellAsset(TrackedAsset trackedAsset) {
    Get.defaultDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      title: "Sell Asset",
      titlePadding: EdgeInsets.only(top: 20),
      content: Text("Are you sure you want to sell ${trackedAsset.name}?"),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Text(
          "Yes",
          style: TextStyle(
            color: Colors.green,
          ),
        ),
        onPressed: () {
          assetsController.sellAsset(trackedAsset);
          Get.back(); // Close the dialog
          Get.snackbar("Sold", "${trackedAsset.name} has been sold.");
        },
      ),
      cancel: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Text(
          "No",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        onPressed: () {
          Get.back(); // Close the dialog without action
        },
      ),
    );
  }
}
