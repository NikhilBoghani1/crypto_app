import 'package:crypto_app/consts.dart';
import 'package:crypto_app/models/coin_data.dart';
import 'package:dio/dio.dart';

class HttpService {
  final Dio _dio = Dio();

  HttpService() {
    _configureDio();
  }

  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: "https://api.cryptorank.io/v1/",
      queryParameters: {
        "api_key": CRYPTO_RANK_API_KEY,
      },
    );
  }

  Future<dynamic> get(String path) async {
    try {
      Response response = await _dio.get(path);
      return response.data;
    } catch (e) {
      if (e is DioException) {
        print('Error: ${e.response?.statusCode} ${e.response?.data}');
      } else {
        print('Error: $e');
      }
      return null; // Return null on error
    }
  }

  /* Future<dynamic> get(String path) async {
    try {
      Response response = await _dio.get(path);
      return response.data;
    } catch (e) {
      print(e);
      return null;  // Return null on error
    }
  }*/

  // New method for fetching coin data
  Future<List<CoinData>?> fetchCoins() async {
    final response = await get(
        "currencies"); // Replace "coins" with the appropriate endpoint that returns the coin data
    if (response != null) {
      // Parse the coin data
      return (response['data'] as List)
          .map((coinJson) => CoinData.fromJson(coinJson))
          .toList();
    }
    return null;
  }
}
