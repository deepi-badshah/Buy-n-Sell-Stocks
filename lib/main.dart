import 'package:flutter/material.dart';

void main() => runApp(BuySellStockApp());

class BuySellStockApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buy and Sell Stocks',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BuySellStockPage(),
    );
  }
}

class BuySellStockPage extends StatefulWidget {
  @override
  _BuySellStockPageState createState() => _BuySellStockPageState();
}

class _BuySellStockPageState extends State<BuySellStockPage> {
  TextEditingController priceController = TextEditingController();
  TextEditingController kController = TextEditingController();
  TextEditingController feeController = TextEditingController();

  List<int> stockPrices = [];
  int k = 0;
  int fee = 0;

  void addPrice() {
    setState(() {
      int? price = int.tryParse(priceController.text);
      if (price != null) {
        stockPrices.add(price);
        priceController.clear();
      }
    });
  }

  void calculateMaxProfits() {
    List<List<int>> buySellDays = [];

    int profit1 = maxProfitVariation1(stockPrices, buySellDays);
    displayResults(profit1, buySellDays);

    buySellDays.clear();

    int profit2 = maxProfitVariation2(stockPrices, buySellDays);
    displayResults(profit2, buySellDays);

    buySellDays.clear();

    int profit3 = maxProfitVariation3(stockPrices, buySellDays);
    displayResults(profit3, buySellDays);

    buySellDays.clear();

    int profit4 = maxProfitVariation4(k, stockPrices, buySellDays);
    displayResults(profit4, buySellDays);

    buySellDays.clear();

    int profit5 = maxProfitVariation5(stockPrices, buySellDays);
    displayResults(profit5, buySellDays);

    buySellDays.clear();

    int profit6 = maxProfitVariation6(fee, stockPrices, buySellDays);
    displayResults(profit6, buySellDays);
  }

  int maxProfitVariation1(List<int> prices, List<List<int>> buySellDays) {
    int minPrice = 10000000;
    int maxProfit = 0;
    int buyDay = 0;
    int sellDay = 0;

    for (int i = 0; i < prices.length; i++) {
      if (prices[i] < minPrice) {
        minPrice = prices[i];
      } else if (prices[i] - minPrice > maxProfit) {
        maxProfit = prices[i] - minPrice;
        buyDay = prices.indexOf(minPrice) + 1;
        sellDay = i + 1;
      }
    }

    buySellDays.add([buyDay, sellDay]);
    return maxProfit;
  }

  int maxProfitVariation2(List<int> prices, List<List<int>> buySellDays) {
    int maxProfit = 0;
    int buyDay = 0;
    int sellDay = 0;
    int i = 0;

    while (i < prices.length - 1) {
      while (i < prices.length - 1 && prices[i] >= prices[i + 1]) {
        i++;
      }

      if (i == prices.length - 1) {
        break;
      }

      buyDay = i + 1;

      while (i < prices.length - 1 && prices[i] <= prices[i + 1]) {
        i++;
      }

      sellDay = i + 1;
      buySellDays.add([buyDay, sellDay]);
      maxProfit += prices[sellDay - 1] - prices[buyDay - 1];
    }

    return maxProfit;
  }

  int maxProfitVariation3(List<int> prices, List<List<int>> buySellDays) {
    int buy1 = double.negativeInfinity.toInt();
    int sell1 = 0;
    int buy2 = double.negativeInfinity.toInt();
    int sell2 = 0;

    for (int price in prices) {
      buy1 = buy1 > -price ? buy1 : -price;
      sell1 = sell1 > buy1 + price ? sell1 : buy1 + price;
      buy2 = buy2 > sell1 - price ? buy2 : sell1 - price;
      sell2 = sell2 > buy2 + price ? sell2 : buy2 + price;
    }

    buySellDays.add([prices.indexOf(buy1), prices.indexOf(sell1)]);
    buySellDays.add([prices.indexOf(buy2), prices.indexOf(sell2)]);
    return sell2;
  }

  int maxProfitVariation4(
      int k, List<int> prices, List<List<int>> buySellDays) {
    if (k >= prices.length ~/ 2) {
      return maxProfitVariation2(prices, buySellDays);
    }

    List<int> buy = List<int>.filled(k + 1, double.negativeInfinity.toInt());
    List<int> sell = List<int>.filled(k + 1, 0);

    for (int price in prices) {
      for (int i = k; i >= 1; i--) {
        buy[i] = buy[i] > sell[i - 1] - price ? buy[i] : sell[i - 1] - price;
        sell[i] = sell[i] > buy[i] + price ? sell[i] : buy[i] + price;
      }
    }

    for (int i = 1; i <= k; i++) {
      buySellDays.add([prices.indexOf(buy[i]), prices.indexOf(sell[i])]);
    }

    return sell[k];
  }

  int maxProfitVariation5(List<int> prices, List<List<int>> buySellDays) {
    int buy = double.negativeInfinity.toInt();
    int sell = 0;
    int prev_sell = 0;
    int prev_buy;

    for (int price in prices) {
      prev_buy = buy;
      buy = buy > prev_sell - price ? buy : prev_sell - price;
      prev_sell = sell;
      sell = sell > prev_buy + price ? sell : prev_buy + price;
    }

    buySellDays.add([prices.indexOf(buy), prices.indexOf(sell)]);
    return sell;
  }

  int maxProfitVariation6(
      int fee, List<int> prices, List<List<int>> buySellDays) {
    int buy = double.negativeInfinity.toInt();
    int sell = 0;

    for (int price in prices) {
      int prev_buy = buy;
      buy = buy > sell - price ? buy : sell - price;
      sell = sell > prev_buy - fee - price ? sell : prev_buy - fee - price;
    }

    buySellDays.add([prices.indexOf(buy), prices.indexOf(sell)]);
    return sell;
  }

  void displayResults(int maxProfit, List<List<int>> buySellDays) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Maximum Profits'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Maximum Profit: $maxProfit'),
              SizedBox(height: 16),
              Text('Buy and Sell Days:'),
              for (List<int> days in buySellDays)
                Text('Buy on Day ${days[0]} and Sell on Day ${days[1]}'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buy and Sell Stocks'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Stock Price',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: addPrice,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: kController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter k (Variation 4)',
              ),
              onChanged: (value) {
                setState(() {
                  k = int.tryParse(value) ?? 0;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: feeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter fee (Variation 6)',
              ),
              onChanged: (value) {
                setState(() {
                  fee = int.tryParse(value) ?? 0;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: stockPrices.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('Day ${index + 1}: ${stockPrices[index]}'),
                );
              },
            ),
          ),
          TextButton(
            child: Text('Calculate Maximum Profits'),
            onPressed: calculateMaxProfits,
          ),
        ],
      ),
    );
  }
}
