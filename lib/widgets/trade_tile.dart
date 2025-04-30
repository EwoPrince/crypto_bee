import 'package:crypto_bee/model/trade.dart';
import 'package:crypto_bee/provider/auth_provider.dart';
import 'package:crypto_bee/services/transfer_service.dart';
import 'package:crypto_bee/view/stake/stake.dart';
import 'package:crypto_bee/widgets/button.dart';
import 'package:crypto_bee/x.dart'; // Assuming this contains utility functions like `goto` and `readTimestamp`
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TradeTile extends ConsumerStatefulWidget {
  final Trade trade;
  const TradeTile({required this.trade, super.key});

  @override
  ConsumerState<TradeTile> createState() => _TradeTileState();
}

class _TradeTileState extends ConsumerState<TradeTile> {
  late String symbol;
  late double currentPrice;
  late int index;
  late double leverage;

  @override
  void initState() {
    super.initState();
    _initializeTradeDetails();
  }

  void _initializeTradeDetails() {
    symbol = _getSymbolFromTrade(widget.trade);
    currentPrice = _getPriceFromSymbol(symbol);
    index = widget.trade.sell == true ? 1 : 0;
    leverage = widget.trade.leverage ?? 1.0;
  }

  String _getSymbolFromTrade(Trade trade) {
    if (trade.BTC != 0) return 'XBTUSD';
    if (trade.ETH != 0) return 'ETH/USD';
    if (trade.DOGE != 0) return 'XDGUSD';
    if (trade.SOL != 0) return 'SOL/USD';
    return 'XBTUSD'; // Default case, can be set to null or throw error based on your requirement
  }

  double _getPriceFromSymbol(String symbol) {
    if (symbol == 'XBTUSD') return btcPrice;
    if (symbol == 'ETH/USD') return ethPrice;
    if (symbol == 'XDGUSD') return dogePrice;
    if (symbol == 'SOL/USD') return solPrice;
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(authProvider).user;

    return ExpansionTile(
      leading: Image.asset(
        _getImageAssetPath(),
        width: 40,
        height: 40,
        fit: BoxFit.contain,
      ),
      title: Text(
        _getTradeTitle(),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        'Levarage: ${leverage.toStringAsFixed(2)} x',
        style: const TextStyle(fontSize: 14),
      ),
      children: [
        const Divider(),
        ListTile(
          tileColor: widget.trade.sell == true ? Colors.red : Colors.green,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.trade.take_profit != null &&
                  widget.trade.take_profit != 0)
                Text(
                  'Take Profit at: \$ ${widget.trade.take_profit!.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 14),
                ),
              if (widget.trade.stop_loss != null && widget.trade.stop_loss != 0)
                Text(
                  'Stop Loss at: \$ ${widget.trade.stop_loss!.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 14),
                ),
              if (widget.trade.margin != null)
                Text(
                  'Margin Used: \$ ${widget.trade.margin!.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 14),
                ),
              Wrap(
                children: [
                  SizedBox(
                    width: 170,
                    child: button(context, 'View Chart', () {
                      goto(
                        context,
                        Stake.routeName,
                        symbol,
                      );
                    }),
                  ),
                  if (widget.trade.withdraw == false)
                    SizedBox(
                      width: 150,
                      child: button(context, 'End Trade', () async {
                        await TransferService.EndTrade(
                          context,
                          _getProfit(widget.trade),
                          widget.trade.stop_loss ?? 0,
                          user,
                          _getSymbolForEndTrade(widget.trade),
                          widget.trade.TradeId,
                          widget.trade.date,
                          widget.trade.force_stop,
                        );
                      }),
                    ),
                ],
              ),
            ],
          ),
          subtitle: Text(
            readTimestamp(widget.trade.date),
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  String _getImageAssetPath() {
    if (widget.trade.BTC != 0) return 'assets/images/btc.png';
    if (widget.trade.ETH != 0) return 'assets/images/eth.png';
    if (widget.trade.DOGE != 0) return 'assets/images/doge.png';
    if (widget.trade.SOL != 0) return 'assets/images/sol.png';
    return '';
  }

  String _getTradeTitle() {
    if (widget.trade.BTC != 0) {
      return widget.trade.withdraw!
          ? 'BTC Withdrew:         \$ ${widget.trade.BTC!.toStringAsFixed(2)}'
          : 'BTC Stake:       \ ${widget.trade.BTC!.toStringAsFixed(2)} %';
    }
    if (widget.trade.ETH != 0) {
      return widget.trade.withdraw!
          ? 'ETH Withdrew:         \$ ${widget.trade.ETH!.toStringAsFixed(2)}'
          : 'ETH Stake:       \ ${widget.trade.ETH!.toStringAsFixed(2)} %';
    }
    if (widget.trade.DOGE != 0) {
      return widget.trade.withdraw!
          ? 'DOGE Withdrew:         \$ ${widget.trade.DOGE!.toStringAsFixed(2)}'
          : 'DOGE Stake:       \ ${widget.trade.DOGE!.toStringAsFixed(2)} %';
    }
    if (widget.trade.SOL != 0) {
      return widget.trade.withdraw!
          ? 'SOL Withdrew:         \$ ${widget.trade.SOL!.toStringAsFixed(2)}'
          : 'SOL Stake:       \ ${widget.trade.SOL!.toStringAsFixed(2)} %';
    }
    return 'Dollar';
  }

  double? _getProfit(Trade trade) {
    if (trade.take_profit != null && trade.take_profit != 0)
      return trade.take_profit;
    if (trade.BTC != 0) return trade.BTC;
    if (trade.ETH != 0) return trade.ETH;
    if (trade.DOGE != 0) return trade.DOGE;
    if (trade.SOL != 0) return trade.SOL;
    return 0.0;
  }

  String _getSymbolForEndTrade(Trade trade) {
    if (trade.BTC != 0) return 'BTC';
    if (trade.ETH != 0) return 'ETH';
    if (trade.DOGE != 0) return 'DOGE';
    if (trade.SOL != 0) return 'SOL';
    return 'BTC';
  }
}
