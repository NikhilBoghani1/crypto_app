import 'dart:async';
import 'dart:convert';

import 'package:crypto_app/models/api_response.dart';
import 'package:crypto_app/models/coin_data.dart';
import 'package:crypto_app/models/tracked_asset.dart';
import 'package:crypto_app/services/http_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssetsController extends GetxController {
  RxList<CoinData> coinData = <CoinData>[].obs;
  RxBool loading = false.obs;
  RxList<TrackedAsset> trackedAsset = <TrackedAsset>[].obs;
  var allCoins = <TrackedAsset>[].obs; // List for all coins
  final HttpService _httpService = HttpService();

  final Dio _dio = Dio();

  @override
  void onInit() {
    super.onInit();
    _getAssets();
    _loadTrackedAssetsFromStorage();
    fetchCoinData(); // Fetch coin data initially
    startFetchingData();
  }

  Future<void> _getAssets() async {
    loading.value = true;
    HttpService httpService = Get.find();

    var responseData = await httpService.get("currencies");

    CurrenciesListAPIResponse currenciesListAPIResponse =
        CurrenciesListAPIResponse.fromJson(responseData);
    coinData.value = currenciesListAPIResponse.data ?? [];

    loading.value = false;
  }

  void addTrackedAsset(String name, double amount) async {
    trackedAsset.add(
      TrackedAsset(
        name: name,
        amount: amount,
      ),
    );
    print(trackedAsset);
    List<String> data = trackedAsset.map((asset) => jsonEncode(asset)).toList();

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setStringList("tracked_assets", data);
  }

  void _loadTrackedAssetsFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? data = prefs.getStringList("tracked_assets");

    if (data != null) {
      trackedAsset.value = data
          .map(
            (e) => TrackedAsset.fromJson(jsonDecode(e)),
          )
          .toList();
    }
  }

  double getPortFolioValue() {
    if (coinData.isEmpty) {
      return 0;
    }

    if (trackedAsset.isEmpty) {
      return 0;
    }
    double value = 0;

    for (TrackedAsset asset in trackedAsset) {
      value += (getAssetPrice(asset.name!)! * asset.amount!);
    }
    return value;
  }

  double? getAssetPrice(String name) {
    CoinData? data = getCoinData(name);
    return data?.values?.uSD?.price?.toDouble() ?? 0;
  }

  CoinData? getCoinData(String name) {
    return coinData.firstWhereOrNull(
      (e) => e.name == name,
    );
  }

  void sellAsset(TrackedAsset assetToSell) {
    trackedAsset.remove(assetToSell); // Removes the asset from the list
    // Add any other logic here (like updating the portfolio value, etc.)
  }

  Future<void> fetchAllCoins() async {
    loading.value = true;
    try {
      final response = await _dio.get(
          'https://api.example.com/all-coins'); // Replace with the actual endpoint
      if (response.statusCode == 200) {
        // Ensure you are parsing the response correctly
        List jsonResponse = response.data; // Use response.data directly
        allCoins.value =
            jsonResponse.map((data) => TrackedAsset.fromJson(data)).toList();
      } else {
        // Handle error
        Get.snackbar("Error", "Failed to fetch coins");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      loading.value = false;
    }
  }

  void startFetchingData() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      fetchCoinData();
    });
  }

  Future<void> fetchCoinData() async {
    var fetchedData = await _httpService.fetchCoins();
    if (fetchedData != null) {
      coinData.value = fetchedData; // Update the coinData observable
    }
  }
}
