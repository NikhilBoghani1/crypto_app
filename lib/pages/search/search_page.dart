import 'package:crypto_app/const/constants.dart';
import 'package:crypto_app/controller/assets_controller.dart';
import 'package:crypto_app/models/coin_data.dart';
import 'package:crypto_app/pages/coin_details/coin_details_page.dart';
import 'package:crypto_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatelessWidget {
  final AssetsController assetsController = Get.find();
  final Constants myConstants = Constants();
  final TextEditingController searchController = TextEditingController();

  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Column(
        children: [
          _searchField(),
          Expanded(child: _searchResults()),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      centerTitle: true,
      title: Text(
        "Search Coin",
        style: TextStyle(
          fontFamily: myConstants.RobotoR,
        ),
      ),
    );
  }

  Widget _searchField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          labelText: 'Search for a coin',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _searchResults() {
    return Obx(() {
      // Assuming assetsController has a list of coins
      final coins =
          assetsController.coinData; // Replace with your actual coin list
      final query = searchController.text.toLowerCase();

      // Filter coins based on the search query
      final filteredCoins = coins.where((coin) {
        return coin.name!.toLowerCase().contains(query) ||
            coin.symbol!.toLowerCase().contains(query);
      }).toList();

      return ListView.builder(
        itemCount: filteredCoins.length,
        itemBuilder: (context, index) {
          CoinData coinData = assetsController.coinData[index];
          final coin = filteredCoins[index];

          return ListTile(
            onTap: () {
              Get.to(
                CoinDetailsScreen(coinData: coinData),
                transition: Transition.downToUp,
              );
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                getCryptoImageURL(coin.name!).isNotEmpty
                    ? getCryptoImageURL(coin.name!)
                    : 'https://example.com/default-image.png', // Default image if URL is empty
              ),
              /* onBackgroundImageError: (error, stackTrace) {
                // Fallback image in case of error loading the network image
                return CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://img.freepik.com/free-photo/3d-illustration-wallet-with-coins-credit-cards_107791-16572.jpg?t=st=1724565991~exp=1724569591~hmac=377c1c7fce286bf4665be1713a542bb2db0b6ca7ed9c6f30ec626465f36d0215&w=900',
                  ),
                );
              },*/
            ),
            title: Text(coin.name!),
            subtitle: Text(coin.symbol!),
          );
        },
      );
    });
  }
}
