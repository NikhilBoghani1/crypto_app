import 'package:crypto_app/models/coin_data.dart';
import 'package:crypto_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsPage extends StatelessWidget {
  final CoinData coin;

  const DetailsPage({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _buildUI(context),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(coin.name!),
    );
  }

  Widget _buildUI(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
        child: Column(
          children: [
            _assetPrice(context),
            _assetInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _assetPrice(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.10,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.network(
              getCryptoImageURL(coin.name!),
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "\$ ${coin.values?.uSD?.price?.toStringAsFixed(2)}\n",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                TextSpan(
                  text:
                      "${coin.values?.uSD?.percentChange24h?.toStringAsFixed(2)} %",
                  style: TextStyle(
                    fontSize: 15,
                    color: coin.values!.uSD!.percentChange24h! > 0
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _assetInfo(BuildContext context) {
    return Expanded(
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        children: [
          _infoCard("Circulating Supply", coin.circulatingSupply.toString()),
          _infoCard("Max Supply", coin.maxSupply.toString()),
          _infoCard("Totle Supply", coin.totalSupply.toString()),
        ],
      ),
    );
  }

  Widget _infoCard(String title, String subtitle) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 2.27 125
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
