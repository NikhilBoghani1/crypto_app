import 'package:crypto_app/const/constants.dart';
import 'package:crypto_app/controller/assets_controller.dart';
import 'package:crypto_app/models/coin_data.dart';
import 'package:crypto_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoinDetailsScreen extends StatelessWidget {
  final CoinData coinData;
  AssetsController assetsController = Get.find();
  Constants myConstants = Constants();

  CoinDetailsScreen({super.key, required this.coinData});

  @override
  Widget build(BuildContext context) {
    // Get the image URL for the coin
    String imageUrl = getCryptoImageURL(coinData.name ?? "") ?? '';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(coinData.name ?? "Coin Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              imageUrl.isNotEmpty
                  ? imageUrl
                  : 'https://example.com/default-image.png',
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://img.freepik.com/free-photo/3d-illustration-wallet-with-coins-credit-cards_107791-16572.jpg?t=st=1724565991~exp=1724569591~hmac=377c1c7fce286bf4665be1713a542bb2db0b6ca7ed9c6f30ec626465f36d0215&w=900', // Fallback default image
                  ),
                );
              },
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      coinData.name ?? "Unknown",
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: myConstants.RobotoR,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "\$ ${coinData.values?.uSD?.price?.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontFamily: myConstants.RobotoM,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Overview',
              style: TextStyle(
                fontFamily: myConstants.RobotoR,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: Get.width,
              height: Get.height * 0.08,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Rank",
                            style: TextStyle(
                              fontFamily: myConstants.RobotoR,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            "${coinData.rank}",
                            style: TextStyle(
                              fontFamily: myConstants.RobotoR,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Name",
                            style: TextStyle(
                              fontFamily: myConstants.RobotoR,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            "${coinData.name}",
                            style: TextStyle(
                              fontFamily: myConstants.RobotoR,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center
                        children: [
                          Text(
                            "Price",
                            style: TextStyle(
                              fontFamily: myConstants.RobotoR,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            "\$${coinData.values?.uSD?.price?.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontFamily: myConstants.RobotoR,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "24h %",
                            style: TextStyle(
                              fontFamily: myConstants.RobotoR,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            "${coinData.values?.uSD?.percentChange24h?.toStringAsFixed(2)}",
                            // Add % sign and handle null
                            style: TextStyle(
                              fontSize: 13,
                              color: coinData.values!.uSD!.percentChange24h! > 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "7d %",
                            style: TextStyle(
                              fontFamily: myConstants.RobotoR,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            "${coinData.values?.uSD?.percentChange7d?.toStringAsFixed(2)}",
                            // Add % sign and handle null
                            style: TextStyle(
                              fontSize: 13,
                              color: coinData.values!.uSD!.percentChange24h! > 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 400,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    "assets/image/trading.jpg",
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
