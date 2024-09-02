import 'package:crypto_app/const/constants.dart';
import 'package:crypto_app/controller/assets_controller.dart';
import 'package:crypto_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Change30dPage extends StatelessWidget {
  AssetsController assetsController = Get.find();
  Constants myConstants = Constants();

  Change30dPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _allCoins(context),
    );
  }

  Widget _allCoins(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* SizedBox(
              height: Get.height * 0.05,
              child: Text(
                "All Coins",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: myConstants.RobotoR,
                ),
              ),
            ),*/
            SizedBox(
              height: Get.height * 0.65, // Set height as 65% of screen height
              width: Get.width, // Set width to full screen width
              child: Obx(() {
                // Check if the loading state is true
                if (assetsController.loading.isTrue) {
                  return Center(
                    child:
                        CircularProgressIndicator(), // Show loader while fetching data
                  );
                } else {
                  // Return ListView when data is available
                  return ListView.builder(
                    // itemCount: assetsController.coinData.length,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          // Circular image
                          child: Image.network(
                            getCryptoImageURL(assetsController
                                        .coinData[index].name!) // Get image URL
                                    .isNotEmpty
                                ? getCryptoImageURL(
                                    assetsController.coinData[index].name!)
                                : 'https://example.com/default-image.png',
                            // Default image
                            errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) {
                              return CircleAvatar(
                                child: Image.network(
                                  'https://img.freepik.com/free-photo/3d-illustration-wallet-with-coins-credit-cards_107791-16572.jpg?t=st=1724565991~exp=1724569591~hmac=377c1c7fce286bf4665be1713a542bb2db0b6ca7ed9c6f30ec626465f36d0215&w=900', // Fallback default image
                                ),
                              );
                            },
                          ),
                        ),
                        title: Text("${assetsController.coinData[index].name}"),
                        subtitle: Text(
                          "${assetsController.coinData[index].values?.uSD?.price?.toStringAsFixed(2) ?? "N/A"}", // Handle null price
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "\$ ${assetsController.coinData[index].values?.uSD?.price?.toStringAsFixed(2) ?? "N/A"}",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: Get.height * 0.01, // Small spacing
                            ),
                            Text(
                              "${assetsController.coinData[index].values?.uSD?.percentChange30d?.toStringAsFixed(2) ?? "N/A"}%", // Add % sign and handle null
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
                      );
                    },
                  );
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
