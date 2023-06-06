import 'package:bitcoin_ticker/configure.dart'; //Used for storing coinapi.io API key
import 'package:http/http.dart' as http;
import 'dart:convert';

const coinApi = 'https://rest.coinapi.io/v1/exchangerate/';
const apiKey = api; //Get API key from coinapi.io

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future getCoinData(String currency, String crypto) async {
    String url = 'https://rest.coinapi.io/v1/exchangerate/$crypto/$currency/?apikey=$apiKey';
    http.Response response = await http.get(Uri.parse(url));

    if(response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}
