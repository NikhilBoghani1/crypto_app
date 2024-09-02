import 'package:crypto_app/const/constants.dart';
import 'package:crypto_app/controller/assets_controller.dart';
import 'package:crypto_app/models/tracked_asset.dart';
import 'package:crypto_app/pages/details/details_page.dart';
import 'package:crypto_app/pages/view_portfolio/view_portfolio_page.dart';
import 'package:crypto_app/utils/utils.dart';
import 'package:crypto_app/widgets/add_asset_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class WalletPage extends StatelessWidget {
  AssetsController assetsController = Get.find();
  Constants myConstants = Constants();
  bool _showAll = false;

  WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _portfolioValue(context),
            _buysellAsset(),
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

  Widget _portfolioValue(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: Get.width,
      height: Get.height * 0.3 - 60,
      margin: EdgeInsets.symmetric(
        vertical: Get.height * 0.03,
        horizontal: Get.width * 0.07,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Get.width * 0.08,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: CupertinoColors.systemIndigo.withOpacity(0.6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Current Balance",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: myConstants.RobotoR,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 120),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: CupertinoColors.systemIndigo.withOpacity(0.3),
                    ),
                    child: Text(
                      'USD',
                      style: TextStyle(
                        fontFamily: myConstants.RobotoR,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    CupertinoIcons.money_dollar,
                    color: Colors.white,
                  ),
                  Text(
                    "${assetsController.getPortFolioValue().toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 39,
                      color: Colors.white,
                      fontFamily: myConstants.RobotoM,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: CupertinoColors.systemIndigo.withOpacity(0.3),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: CupertinoColors.systemIndigo.withOpacity(0.3),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: CupertinoColors.systemIndigo.withOpacity(0.3),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: CupertinoColors.systemIndigo.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
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
            height: Get.height * 0.35,
            width: Get.width,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: assetsController.trackedAsset.length,
              itemBuilder: (context, index) {
                TrackedAsset trackedAsset =
                    assetsController.trackedAsset[index];
                return Obx(
                  () => ListTile(
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
                        Text(
                          trackedAsset.amount.toString(),
                        ),
                        IconButton(
                          icon: Icon(CupertinoIcons.minus_circle),
                          onPressed: () {
                            _sellAsset(trackedAsset);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Container(
            child: GestureDetector(
              onTap: () {
                Get.to(ViewPortfolioPage(),
                    transition: Transition.downToUp,
                    duration: Duration(milliseconds: 500));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'View all',
                    style: TextStyle(
                      fontFamily: myConstants.RobotoR,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.next_plan),
                ],
              ),
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

  Widget _buysellAsset() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: CupertinoColors.link,
              ),
              onPressed: () {
                Get.dialog(
                  AddAssetDialog(),
                );
              },
              child: Text(
                "Buy",
                style: TextStyle(
                    fontFamily: myConstants.RobotoR, color: Colors.white),
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: CupertinoColors.systemRed,
              ),
              onPressed: () {},
              child: Text(
                "Sell",
                style: TextStyle(
                    fontFamily: myConstants.RobotoR, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
