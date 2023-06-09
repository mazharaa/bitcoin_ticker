import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  int selectedCurrency = 0;
  Map<String, String> coinRate = {};

  void getMapCoin() {
    for(String coin in cryptoList) {
      coinRate[coin] = '?';
    }
  }

  void getRate() async {
    var btcRate = await CoinData()
        .getCoinData(currenciesList[selectedCurrency], cryptoList[0]);

    var ethRate = await CoinData()
        .getCoinData(currenciesList[selectedCurrency], cryptoList[1]);

    var ltcRate = await CoinData()
        .getCoinData(currenciesList[selectedCurrency], cryptoList[2]);

    if(mounted) {
      setState(() {
        coinRate[cryptoList[0]] = btcRate['rate'].toInt().toString();
        coinRate[cryptoList[1]] = ethRate['rate'].toInt().toString();
        coinRate[cryptoList[2]] = ltcRate['rate'].toInt().toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getMapCoin();
    getRate();
  }

  DropdownButton<String> androidDropdown() {
    return DropdownButton<String>(
      value: currenciesList[selectedCurrency],
      items: currenciesList.map<DropdownMenuItem<String>>((String value){
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          selectedCurrency = currenciesList.indexOf(value!);
          getMapCoin();
          getRate();
        });
      }
    );
  }

  CupertinoButton _cupertinoButton() {
    return CupertinoButton(
      child: Text(
        currenciesList[selectedCurrency],
        style: const TextStyle(color: Colors.white),
      ),
      onPressed: () => _showDialog(
        CupertinoPicker(
          magnification: 1.22,
          squeeze: 1.2,
          useMagnifier: true,
          itemExtent: 32,
          scrollController: FixedExtentScrollController(
            initialItem: selectedCurrency
          ),
          onSelectedItemChanged: (int value) {
            setState(() {
              selectedCurrency = value;
            });
          },
          children: List<Widget>.generate(
            currenciesList.length, (int index) => Center(
              child: Text(currenciesList[index]),
            )
          )
        )
      )
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 10)),
              for(String coin in cryptoList) (
                CoinCard(
                  coin: coin,
                  rate: coinRate[coin]!,
                  currency: currenciesList[selectedCurrency]
                )
              )
            ]
          ),
          Container(
            height: 100,
            color: Colors.lightBlue,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Currency : '),
                  Platform.isIOS ? _cupertinoButton() : androidDropdown()
                ]
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CoinCard extends StatelessWidget {
  const CoinCard({
    super.key,
    required this.coin,
    required this.rate,
    required this.currency,
  });

  final String coin;
  final String rate;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        child: SizedBox(
          width: 300,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 28),
            child: Text(
              '1 $coin = $rate $currency',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white
              ),
            ),
          ),
        ),
      ),
    );
  }
}
