import 'package:crypto_beam/model/trade.dart';
import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/services/transfer_service.dart';
import 'package:crypto_beam/states/verified_state.dart';
import 'package:crypto_beam/view/stake/stake.dart';
import 'package:crypto_beam/widgets/button.dart';
import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Utility functions from Wallet
String numToCrypto(double value) {
  return value
      .toStringAsFixed(6)
      .replaceAll(RegExp(r'0+$'), '')
      .replaceAll(RegExp(r'\.$'), '');
}

String numToCurrency(double value, String decimals) {
  return '\$${value.toStringAsFixed(int.parse(decimals))}';
}

String readTimestamp(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

class TradeTile extends ConsumerStatefulWidget {
  final Trade trade;
  const TradeTile({required this.trade, super.key});

  @override
  ConsumerState<TradeTile> createState() => _TradeTileState();
}

class _TradeTileState extends ConsumerState<TradeTile> {
  late String krakenPair;
  late String symbol;
  late double leverage;
  bool _isEndingTrade = false;

  @override
  void initState() {
    super.initState();
    _initializeTradeDetails();
  }

  void _initializeTradeDetails() {
    krakenPair = _getKrakenPairFromTrade(widget.trade);
    symbol = _getSymbolFromTrade(widget.trade);
    leverage = widget.trade.leverage ?? 1.0;
  }

  String _getKrakenPairFromTrade(Trade trade) {
    if (trade.BTC != null && trade.BTC != 0) return 'XBTUSD';
    if (trade.ETH != null && trade.ETH != 0) return 'ETHUSD';
    if (trade.DOGE != null && trade.DOGE != 0) return 'XDGUSD';
    if (trade.SOL != null && trade.SOL != 0) return 'SOLUSD';
    if (trade.BNB != null && trade.BNB != 0) return 'BNBUSD';
    throw Exception('Invalid trade: no non-zero crypto amount');
  }

  String _getSymbolFromTrade(Trade trade) {
    if (trade.BTC != null && trade.BTC != 0) return 'BTC';
    if (trade.ETH != null && trade.ETH != 0) return 'ETH';
    if (trade.DOGE != null && trade.DOGE != 0) return 'DOGE';
    if (trade.SOL != null && trade.SOL != 0) return 'SOL';
    if (trade.BNB != null && trade.BNB != 0) return 'BNB';
    throw Exception('Invalid trade: no non-zero crypto amount');
  }

  String _getImageAssetPath() {
    switch (symbol) {
      case 'BTC':
        return 'assets/images/btc.png';
      case 'ETH':
        return 'assets/images/eth.png';
      case 'DOGE':
        return 'assets/images/doge.png';
      case 'SOL':
        return 'assets/images/sol.png';
      case 'BNB':
        return 'assets/images/bnb.png';
      default:
        return 'assets/images/default.png';
    }
  }

  double _getCryptoAmount(Trade trade) {
    if (trade.BTC != null && trade.BTC != 0) return trade.BTC!;
    if (trade.ETH != null && trade.ETH != 0) return trade.ETH!;
    if (trade.DOGE != null && trade.DOGE != 0) return trade.DOGE!;
    if (trade.SOL != null && trade.SOL != 0) return trade.SOL!;
    if (trade.BNB != null && trade.BNB != 0) return trade.BNB!;
    return 0.0;
  }

  double? _getProfit(Trade trade, double currentPrice) {
    final amount = _getCryptoAmount(trade);
    return amount * currentPrice;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final prices = ref.watch(priceProvider);
    final currentPrice = prices[krakenPair] ?? 0.0;

    if (user == null) {
      return const ListTile(
        title: Text('User not authenticated'),
        // semanticsLabel: 'User not authenticated',
      );
    }

    if (currentPrice == 0.0) {
      return ListTile(
        title: Text('Price unavailable for $symbol'),
        subtitle: const Text('Please check your connection'),
        // semanticsLabel: 'Price unavailable for $symbol',
      );
    }

    final amount = _getCryptoAmount(widget.trade);
    final usdValue = amount * currentPrice;
    final status = widget.trade.withdraw == true ? 'Withdrawn' : 'Active';

    return ExpansionTile(
      leading: Image.asset(
        _getImageAssetPath(),
        width: 40,
        height: 40,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.broken_image,
          size: 40,
          color: Colors.grey,
        ),
      ),
      title: Text(
        '$symbol $status: ${numToCurrency(usdValue, '2')}',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        semanticsLabel: '$symbol $status: ${numToCurrency(usdValue, '2')}',
      ),
      subtitle: Text(
        'Leverage: ${leverage.toStringAsFixed(2)}x',
        style: const TextStyle(fontSize: 14),
        semanticsLabel: 'Leverage ${leverage.toStringAsFixed(2)}x',
      ),
      children: [
        const Divider(),
        ListTile(
          tileColor: widget.trade.sell == true
              ? Theme.of(context).colorScheme.error.withOpacity(0.1)
              : Theme.of(context).colorScheme.primary.withOpacity(0.1),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.trade.margin != null)
                Text(
                  'Margin Used: ${numToCurrency(widget.trade.margin!, '2')}',
                  style: const TextStyle(fontSize: 14),
                  semanticsLabel:
                      'Margin Used ${numToCurrency(widget.trade.margin!, '2')}',
                ),
              if (widget.trade.take_profit != null &&
                  widget.trade.take_profit != 0)
                Text(
                  'Take Profit at: ${numToCurrency(widget.trade.take_profit!, '2')}',
                  style: const TextStyle(fontSize: 14),
                  semanticsLabel:
                      'Take Profit at ${numToCurrency(widget.trade.take_profit!, '2')}',
                ),
              if (widget.trade.stop_loss != null && widget.trade.stop_loss != 0)
                Text(
                  'Stop Loss at: ${numToCurrency(widget.trade.stop_loss!, '2')}',
                  style: const TextStyle(fontSize: 14),
                  semanticsLabel:
                      'Stop Loss at ${numToCurrency(widget.trade.stop_loss!, '2')}',
                ),
                Text(
                  widget.trade.sell == true
                  ? 'Trade action: Sell'
                  : 'Trade action: Buy',
                  style: const TextStyle(fontSize: 14),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      color: Theme.of(context).primaryColor,
                      name: 'View Chart',
                      onTap: () {
                        goto(context, Stake.routeName, krakenPair);
                      },
                    ),
                  ),
                  if (widget.trade.withdraw == false) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomButton(
                        color: Theme.of(context).primaryColor,
                        name: _isEndingTrade ? 'Ending...' : 'End Trade',
                        onTap: () async {
                          setState(() {
                            _isEndingTrade = true;
                          });
                          try {
                            await TransferService.endTrade(
                              context,
                              ref,
                              _getProfit(widget.trade, currentPrice),
                              widget.trade.stop_loss,
                              widget.trade.leverage,
                              user.uid,
                              symbol,
                              widget.trade.TradeId,
                              widget.trade.date,
                              widget.trade.force_stop,
                            );
                            showMessage(context, 'Trade ended successfully');
                          } catch (e) {
                            showMessage(context, 'Error ending trade: $e');
                          } finally {
                            setState(() {
                              _isEndingTrade = false;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          subtitle: Text(
            'Trade placed on: ${readTimestamp(widget.trade.date.millisecondsSinceEpoch)}',
            style: const TextStyle(fontSize: 12),
            semanticsLabel:
                'Trade date ${readTimestamp(widget.trade.date.millisecondsSinceEpoch)}',
          ),
        ),
      ],
    );
  }
}
