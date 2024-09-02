import 'package:crypto_app/const/constants.dart';
import 'package:crypto_app/controller/assets_controller.dart';
import 'package:crypto_app/shimmer/tokens_shimmer.dart';
import 'package:crypto_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllCoinPage extends StatelessWidget {
  AssetsController assetsController = Get.find();
  Constants myConstants = Constants();

  AllCoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              _coinsVertical(context),
            ],
          ),
        ),
      ),
    );
  }
}

PreferredSizeWidget _appBar() {
  return AppBar(
    centerTitle: true,
    automaticallyImplyLeading: false,
    title: Text("Coin's"),
  );
}

Widget _coinsVertical(BuildContext context) {
  AssetsController assetsController = Get.find();
  Constants myConstants = Constants();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: Get.height,
        margin: EdgeInsets.symmetric(
          horizontal: Get.width * 0.03,
          vertical: Get.height * 0.03,
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
                itemCount: assetsController.coinData.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "${assetsController.coinData[index].rank}",
                              style: TextStyle(
                                fontFamily: myConstants.RobotoR,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "${assetsController.coinData[index].name}",
                              style: TextStyle(
                                fontFamily: myConstants.RobotoR,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              "${assetsController.coinData[index].symbol}",
                              style: TextStyle(
                                fontFamily: myConstants.RobotoR,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "\$${assetsController.coinData[index].values?.uSD?.price?.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontFamily: myConstants.RobotoR,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              "${assetsController.coinData[index].values?.uSD?.percentChange24h?.toStringAsFixed(2)}%",
                              style: TextStyle(
                                fontFamily: myConstants.RobotoR,
                                fontSize: 17,
                                color: assetsController.coinData[index].values!
                                            .uSD!.percentChange24h! >
                                        0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            Icon(
                              assetsController.coinData[index].values!.uSD!
                                          .percentChange24h! >
                                      0
                                  ? Icons.arrow_drop_up_outlined
                                  : Icons.arrow_drop_down,
                              color: assetsController.coinData[index].values!
                                          .uSD!.percentChange24h! >
                                      0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ],
                        ),
                      )
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
