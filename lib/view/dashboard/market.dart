
import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';



class Market extends StatefulWidget {
  const Market({super.key});
  static const routeName = '/Market';

  @override
  State<Market> createState() => _MarketState();
}

class TradingCoin {
  final String name;
  final String tradingPair;
  final String price;
  final String change24h;
  final bool hasFireIcon;
  final bool hasLaunchpool;
  final String? launchpoolTimeRemaining;

  TradingCoin({
    required this.name,
    required this.tradingPair,
    required this.price,
    required this.change24h,
    this.hasFireIcon = false,
    this.hasLaunchpool = false,
    this.launchpoolTimeRemaining,
  });
}

class _MarketState extends State<Market> {
  List<TradingCoin> tradingCoins = [
    TradingCoin(
        name: "BTC", tradingPair: "/ USDT", price: btcPrice.toString(), change24h: "-0.79%", hasFireIcon: true),
    TradingCoin(
        name: "ETH", tradingPair: "/ USDT", price: ethPrice.toString(), change24h: "+0.10%", hasFireIcon: true),
    TradingCoin(name: "SOL", tradingPair: "/ USDT", price: solPrice.toString(), change24h: "-1.01%", hasFireIcon: true),
    TradingCoin(name: "DOGE", tradingPair: "/ USDT", price: dogePrice.toString(), change24h: "+1.28%"),
    TradingCoin(name: "BNB", tradingPair: "/ USDT", price: bnbPrice.toString(), change24h: "+0.55%", hasFireIcon: true, hasLaunchpool: true,),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 8),
                    const Text("BTC/USDT", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              // Spot/Derivatives and USDT/All
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: () {}, child: const Text("Spot")),
                  TextButton(onPressed: () {}, child: const Text("Derivatives")),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton<String>(
                          value: "USDT",
                          items: const [
                            DropdownMenuItem(value: "USDT", child: Text("USDT")),
                          ],
                          onChanged: (value) {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton<String>(
                          value: "All",
                          items: const [
                            DropdownMenuItem(value: "All", child: Text("All")),
                          ],
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // New Listing
              Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  child: const Text("New listing: BNB/USDT – Grab a share of the 5,500,000…"),
                ),
              ),
        
              // Trading Coin List
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: tradingCoins.length,
                itemBuilder: (context, index) {
                  return _buildTradingCoinTile(tradingCoins[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTradingCoinTile(TradingCoin coin) {
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(coin.name, style: Theme.of(context).textTheme.titleMedium,),
          if (coin.hasFireIcon) const Icon(Icons.local_fire_department, color: Colors.orange),
        ],
      ),
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(coin.tradingPair),
      ),
      subtitle: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(coin.price),
            if (coin.hasLaunchpool)
              Container(
                padding: const EdgeInsets.all(4),
                color: Colors.grey[800],
                child: Text("Launchpool",style: TextStyle(fontSize: 10),),
              ),
            if (coin.launchpoolTimeRemaining != null)
              Text(coin.launchpoolTimeRemaining!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: coin.change24h.startsWith("+") ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          coin.change24h,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
