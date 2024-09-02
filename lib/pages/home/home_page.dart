import 'package:crypto_app/const/constants.dart';
import 'package:crypto_app/controller/assets_controller.dart';
import 'package:crypto_app/models/coin_data.dart';
import 'package:crypto_app/models/tracked_asset.dart';
import 'package:crypto_app/pages/all_coin/all_coin_page.dart';
import 'package:crypto_app/pages/coin_details/coin_details_page.dart';
import 'package:crypto_app/pages/details/details_page.dart';
import 'package:crypto_app/shimmer/tokens_shimmer.dart';
import 'package:crypto_app/shimmer/top_movers_shimmer.dart';
import 'package:crypto_app/utils/utils.dart';
import 'package:crypto_app/widgets/add_asset_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  AssetsController assetsController = Get.find();
  Constants myConstants = Constants();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.1),
      body: CustomScrollView(
        slivers: [
          _appBar(context),
          SliverToBoxAdapter(
            child: _buildUI(context),
          ),
        ],
      ),
    );
  }

  SliverAppBar _appBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      expandedHeight: 270.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        // titlePadding: EdgeInsets.symmetric(vertical: 100),
        title: const Text('C R Y P T O'),
        background: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            // color: CupertinoColors.white.withOpacity(0.2),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                "assets/image/trading.jpg",
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Get.dialog(
              AddAssetDialog(),
            );
          },
          icon: const Icon(CupertinoIcons.plus),
        ),
      ],
    );
  }

  Widget _buildUI(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Column(
          children: [
            _coinImageDetails(context),
            _coinsVertical(context),
            _portfolioValue(context),
            // _trackedAssetsList(context),
            // _tabs(context),
          ],
        ),
      ),
    );
  }

  Widget _portfolioValue(BuildContext context) {
    return Container(
      width: Get.width,
      margin: EdgeInsets.symmetric(
        vertical: Get.height * 0.03,
        horizontal: Get.width * 0.08,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Balance",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: myConstants.RobotoR,
                  color: Colors.black54,
                ),
              ),
              Row(
                children: [
                  Text(
                    "\$ ",
                    style: TextStyle(
                      fontFamily: myConstants.RobotoB,
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    "${assetsController.getPortFolioValue().toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Icon(CupertinoIcons.right_chevron),
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
            height: Get.height * 0.26,
            width: Get.width,
            child: ListView.builder(
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
                          icon: const Icon(CupertinoIcons.minus_circle),
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
        ],
      ),
    );
  }

  void _sellAsset(TrackedAsset trackedAsset) {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      title: "Sell Asset",
      titlePadding: const EdgeInsets.only(top: 20),
      content: Text("Are you sure you want to sell ${trackedAsset.name}?"),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: const Text(
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
        child: const Text(
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

  /*Widget _tabs(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              indicatorColor: Colors.black54,
              labelColor: Colors.black,
              dividerHeight: 0,
              indicatorSize: TabBarIndicatorSize.label,
              padding: EdgeInsets.symmetric(vertical: 10),
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Text(
                    "24h Change",
                    style: TextStyle(
                      fontFamily: myConstants.RobotoR,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Text(
                    "7d Change",
                    style: TextStyle(
                      fontFamily: myConstants.RobotoR,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Text(
                    "30d Change",
                    style: TextStyle(
                      fontFamily: myConstants.RobotoR,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 390,
              child: TabBarView(
                children: [
                  Change24hPage(),
                  Change7dPage(),
                  Change30dPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }*/

  Widget _coinImageDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            'Top Movers',
            style: TextStyle(
              fontFamily: myConstants.RobotoR,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          // decoration: BoxDecoration(
          //   color: Colors.grey.withOpacity(0.2),
          //   borderRadius: BorderRadius.circular(10),
          // ),
          height: Get.height * 0.18,
          margin: EdgeInsets.symmetric(
            horizontal: Get.width * 0.03,
          ),
          child: Obx(
            () {
              if (assetsController.loading.isTrue) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const TopMoversShimmer();
                  },
                );
              } else {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    CoinData coinData = assetsController.coinData[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(
                          CoinDetailsScreen(coinData: coinData),
                          transition: Transition.downToUp,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 15),
                        margin: const EdgeInsets.only(right: 15),
                        /*width: Get.width * 0.35,
                        height: Get.height * 0.15,*/
                        width: 150,
                        // height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white.withOpacity(0.7),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    width: 40,
                                    height: 40,
                                    getCryptoImageURL(assetsController
                                                .coinData[index]
                                                .name!) // Get image URL
                                            .isNotEmpty
                                        ? getCryptoImageURL(assetsController
                                            .coinData[index].name!)
                                        : 'https://example.com/default-image.png',
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      return CircleAvatar(
                                        child: Image.network(
                                          'https://img.freepik.com/free-photo/3d-illustration-wallet-with-coins-credit-cards_107791-16572.jpg?t=st=1724565991~exp=1724569591~hmac=377c1c7fce286bf4665be1713a542bb2db0b6ca7ed9c6f30ec626465f36d0215&w=900', // Fallback default image
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: assetsController
                                                .coinData[index]
                                                .values!
                                                .uSD!
                                                .percentChange24h! >
                                            0
                                        ? Colors.green.withOpacity(0.2)
                                        : Colors.red.withOpacity(0.2),
                                  ),
                                  child: Text(
                                    "${assetsController.coinData[index].values?.uSD?.percentChange24h?.toStringAsFixed(2)} %",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: assetsController
                                                  .coinData[index]
                                                  .values!
                                                  .uSD!
                                                  .percentChange24h! >
                                              0
                                          ? Colors.green
                                          : Colors.red,
                                      fontFamily: myConstants.RobotoM,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 33),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Text(
                                    "\$ ${assetsController.coinData[index].values?.uSD?.price!.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontFamily: myConstants.RobotoM,
                                      fontSize: 19,
                                    ),
                                  ),
                                ),
                                Text(
                                  'USD',
                                  style: TextStyle(
                                    fontFamily: myConstants.RobotoL,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${assetsController.coinData[index].name}",
                              style: TextStyle(
                                fontFamily: myConstants.RobotoR,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _coinsVertical(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tokens',
                style: TextStyle(
                  fontFamily: myConstants.RobotoR,
                  fontSize: 20,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(
                    AllCoinPage(),
                    transition: Transition.fade,
                  );
                },
                child: Text(
                  'View all',
                  style: TextStyle(
                    fontFamily: myConstants.RobotoR,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Container(
          height: 590,
          margin: EdgeInsets.symmetric(
            horizontal: Get.width * 0.03,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Obx(
            () {
              if (assetsController.loading.isTrue) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    return const TokensShimmer();
                  },
                );
              } else {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          leading: Image.network(
                            width: 40,
                            height: 40,
                            getCryptoImageURL(assetsController
                                        .coinData[index].name!) // Get image URL
                                    .isNotEmpty
                                ? getCryptoImageURL(
                                    assetsController.coinData[index].name!)
                                : 'https://example.com/default-image.png',
                            errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) {
                              return CircleAvatar(
                                child: Image.network(
                                  'https://img.freepik.com/free-photo/3d-illustration-wallet-with-coins-credit-cards_107791-16572.jpg?t=st=1724565991~exp=1724569591~hmac=377c1c7fce286bf4665be1713a542bb2db0b6ca7ed9c6f30ec626465f36d0215&w=900', // Fallback default image
                                ),
                              );
                            },
                          ),
                          title:
                              Text("${assetsController.coinData[index].name!}"),
                          subtitle: Row(
                            children: [
                              Text(
                                "\$ ${assetsController.coinData[index].values?.uSD?.price!.toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: myConstants.RobotoR,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 7),
                              Text(
                                "${assetsController.coinData[index].values?.uSD?.percentChange24h?.toStringAsFixed(2) ?? "N/A"}%", // Add % sign and handle null
                                style: TextStyle(
                                  fontSize: 13,
                                  color: assetsController.coinData[index]
                                              .values!.uSD!.percentChange24h! >
                                          0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          trailing: Text(
                            "${assetsController.coinData[index].category}",
                            style: TextStyle(
                              fontFamily: myConstants.RobotoR,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Divider(
                            height: 2,
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
