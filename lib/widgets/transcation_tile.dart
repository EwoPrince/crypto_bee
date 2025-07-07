import 'package:crypto_beam/model/transcation.dart';
import 'package:crypto_beam/states/verified_state.dart';
import 'package:crypto_beam/x.dart' as x;
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
  return '\$ ${value.toStringAsFixed(int.parse(decimals))}';
}

String readTimestamp(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
}

class TransactionTile extends ConsumerWidget {
  const TransactionTile({super.key, required this.transaction});
  final Transaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prices = ref.read(priceProvider);

    // Determine the crypto type and amount
    final cryptoInfo = _getCryptoInfo(transaction, prices);

    return ExpansionTile(
      leading: Image.asset(
        cryptoInfo['asset'] ?? 'assets/images/default.png',
        width: 40,
        height: 40,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      ),
      title: Text(
        cryptoInfo['title'] ?? 'Unknown Transaction',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        '${cryptoInfo['subtitle'] ?? 'No Value'} \n ${x.readTimestamp(transaction.date)}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 18,
          height: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 2.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  transaction.withdraw ?? false
                      ? 'Withdrawal Details'
                      : 'Transaction Details',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 10),
                _buildDetailRow(
                  context,
                  'Network',
                  cryptoInfo['network'] ?? '',
                ),
                if (transaction.withdraw ?? false) ...[
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    context,
                    'Address',
                    transaction.address ?? 'N/A',
                  ),
                ],
                const SizedBox(height: 8),
                _buildDetailRow(
                  context,
                  'Txid',
                  transaction.title ?? 'N/A',
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  context,
                  'Amount',
                  cryptoInfo['amount'] ?? 'N/A',
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  context,
                  'Network fee',
                  '0.00000013',
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  context,
                  'Wallet',
                  'Spot Wallet',
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  context,
                  'Time',
                  readTimestamp(transaction.date.millisecondsSinceEpoch),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Map<String, String?> _getCryptoInfo(
      Transaction transaction, Map<String, double> prices) {
    final bool isWithdraw = transaction.withdraw ?? false;
    final bool isTrade = transaction.trade ?? false;

    if (transaction.BTC != null && transaction.BTC != 0) {
      final amount = transaction.BTC!;
      final price = prices['XBTUSD'] ?? 0.0;
      return {
        'network': 'Bitcoin',
        'asset': 'assets/images/btc.png',
        'title': isTrade
            ? 'BTC Spot Trading: ${numToCrypto(amount)}'
            : isWithdraw
                ? 'BTC Withdrew: ${numToCrypto(amount)}'
                : 'BTC Received: ${numToCrypto(amount)}',
        'subtitle': 'Bitcoin worth: ${numToCurrency(amount * price, '2')}',
        'amount': '${numToCrypto(amount)} BTC',
      };
    } else if (transaction.ETH != null && transaction.ETH != 0) {
      final amount = transaction.ETH!;
      final price = prices['ETHUSD'] ?? 0.0;
      return {
        'network': 'Ethereum',
        'asset': 'assets/images/eth.png',
        'title': isTrade
            ? 'ETH Spot Trading: ${numToCrypto(amount)}'
            : isWithdraw
                ? 'ETH Withdrew: ${numToCrypto(amount)}'
                : 'ETH Received: ${numToCrypto(amount)}',
        'subtitle': 'Ethereum worth: ${numToCurrency(amount * price, '2')}',
        'amount': '${numToCrypto(amount)} ETH',
      };
    } else if (transaction.DOGE != null && transaction.DOGE != 0) {
      final amount = transaction.DOGE!;
      final price = prices['XDGUSD'] ?? 0.0;
      return {
        'network': 'Doge',
        'asset': 'assets/images/doge.png',
        'title': isTrade
            ? 'DOGE Spot Trading: ${numToCrypto(amount)}'
            : isWithdraw
                ? 'DOGE Withdrew: ${numToCrypto(amount)}'
                : 'DOGE Received: ${numToCrypto(amount)}',
        'subtitle': 'Dogecoin worth: ${numToCurrency(amount * price, '2')}',
        'amount': '${numToCrypto(amount)} DOGE',
      };
    } else if (transaction.SOL != null && transaction.SOL != 0) {
      final amount = transaction.SOL!;
      final price = prices['SOLUSD'] ?? 0.0;
      return {
        'network': 'Solana',
        'asset': 'assets/images/sol.png',
        'title': isTrade
            ? 'SOL Spot Trading: ${numToCrypto(amount)}'
            : isWithdraw
                ? 'SOL Withdrew: ${numToCrypto(amount)}'
                : 'SOL Received: ${numToCrypto(amount)}',
        'subtitle': 'Solana worth: ${numToCurrency(amount * price, '2')}',
        'amount': '${numToCrypto(amount)} SOL',
      };
    } else if (transaction.BNB != null && transaction.BNB != 0) {
      final amount = transaction.BNB!;
      final price = prices['BNBUSD'] ?? 0.0;
      return {
        'network': 'Binance coin',
        'asset': 'assets/images/bnb.png',
        'title': isTrade
            ? 'BNB Spot Trading: ${numToCrypto(amount)}'
            : isWithdraw
                ? 'BNB Withdrew: ${numToCrypto(amount)}'
                : 'BNB Received: ${numToCrypto(amount)}',
        'subtitle': 'Binance Coin worth: ${numToCurrency(amount * price, '2')}',
        'amount': '${numToCrypto(amount)} BNB',
      };
    } else if (transaction.HMSTR != null && transaction.HMSTR != 0) {
      final amount = transaction.HMSTR!;
      final price = prices['HMSTRUSD'] ?? 0.0;
      return {
        'network': 'Hamster-Kombat',
        'asset': 'assets/images/hmstr.png',
        'title': isTrade
            ? 'HMSTR Spot Trading: ${numToCrypto(amount)}'
            : isWithdraw
                ? 'HMSTR Withdrew: ${numToCrypto(amount)}'
                : 'HMSTR Received: ${numToCrypto(amount)}',
        'subtitle': 'Hamster-Kombat worth: ${numToCurrency(amount * price, '2')}',
        'amount': '${numToCrypto(amount)} HMSTR',
      };
    }else if (transaction.PEPE != null && transaction.PEPE != 0) {
      final amount = transaction.PEPE!;
      final price = prices['PEPEUSD'] ?? 0.0;
      return {
        'network': 'PEPE',
        'asset': 'assets/images/pepe.jpeg',
        'title': isTrade
            ? 'PEPE Spot Trading: ${numToCrypto(amount)}'
            : isWithdraw
                ? 'PEPE Withdrew: ${numToCrypto(amount)}'
                : 'PEPE Received: ${numToCrypto(amount)}',
        'subtitle': 'PEPE worth: ${numToCurrency(amount * price, '2')}',
        'amount': '${numToCrypto(amount)} PEPE',
      };
    }else if (transaction.MNT != null && transaction.MNT != 0) {
      final amount = transaction.MNT!;
      final price = prices['MNTUSD'] ?? 0.0;
      return {
        'network': 'MNT',
        'asset': 'assets/images/MNT.png',
        'title': isTrade
            ? 'MNT Spot Trading: ${numToCrypto(amount)}'
            : isWithdraw
                ? 'MNT Withdrew: ${numToCrypto(amount)}'
                : 'MNT Received: ${numToCrypto(amount)}',
        'subtitle': 'MNT worth: ${numToCurrency(amount * price, '2')}',
        'amount': '${numToCrypto(amount)} MNT',
      };
    }else if (transaction.TRX != null && transaction.TRX != 0) {
      final amount = transaction.TRX!;
      final price = prices['TRXUSD'] ?? 0.0;
      return {
        'network': 'Tron',
        'asset': 'assets/images/TRX.png',
        'title': isTrade
            ? 'TRX Spot Trading: ${numToCrypto(amount)}'
            : isWithdraw
                ? 'TRX Withdrew: ${numToCrypto(amount)}'
                : 'TRX Received: ${numToCrypto(amount)}',
        'subtitle': 'Tron worth: ${numToCurrency(amount * price, '2')}',
        'amount': '${numToCrypto(amount)} TRX',
      };
    }else if (transaction.USDT != null && transaction.USDT != 0) {
      final amount = transaction.USDT!;
      final price = prices['USDTUSD'] ?? 0.0;
      return {
        'network': 'Tether',
        'asset': 'assets/images/usdt.png',
        'title': isTrade
            ? 'USDT Spot Trading: ${numToCrypto(amount)}'
            : isWithdraw
                ? 'USDT Withdrew: ${numToCrypto(amount)}'
                : 'USDT Received: ${numToCrypto(amount)}',
        'subtitle': 'Tether worth: ${numToCurrency(amount * price, '2')}',
        'amount': '${numToCrypto(amount)} USDT',
      };
    }else if (transaction.USDC != null && transaction.USDC != 0) {
      final amount = transaction.USDC!;
      final price = prices['USDCUSD'] ?? 0.0;
      return {
        'network': 'USDC',
        'asset': 'assets/images/usdc.png',
        'title': isTrade
            ? 'USDC Spot Trading: ${numToCrypto(amount)}'
            : isWithdraw
                ? 'USDC Withdrew: ${numToCrypto(amount)}'
                : 'USDC Received: ${numToCrypto(amount)}',
        'subtitle': 'USDC worth: ${numToCurrency(amount * price, '2')}',
        'amount': '${numToCrypto(amount)} USDC',
      };
    }else if (transaction.XRP != null && transaction.XRP != 0) {
      final amount = transaction.XRP!;
      final price = prices['XRPUSD'] ?? 0.0;
      return {
        'network': 'Ripple',
        'asset': 'assets/images/xrp.png',
        'title': isTrade
            ? 'XRP Spot Trading: ${numToCrypto(amount)}'
            : isWithdraw
                ? 'XRP Withdrew: ${numToCrypto(amount)}'
                : 'XRP Received: ${numToCrypto(amount)}',
        'subtitle': 'Ripple worth: ${numToCurrency(amount * price, '2')}',
        'amount': '${numToCrypto(amount)} XRP',
      };
    }else if (transaction.X != null && transaction.X != 0) {
      final amount = transaction.X!;
      final price = prices['XUSD'] ?? 0.0;
      return {
        'network': 'Solana',
        'asset': 'assets/images/x.png',
        'title': isTrade
            ? 'X Spot Trading: ${numToCrypto(amount)}'
            : isWithdraw
                ? 'X Withdrew: ${numToCrypto(amount)}'
                : 'X Received: ${numToCrypto(amount)}',
        'subtitle': 'Solana worth: ${numToCurrency(amount * price, '2')}',
        'amount': '${numToCrypto(amount)} X',
      };
    }

    return {
      'network': '',
      'asset': null,
      'title': 'Unknown Transaction',
      'subtitle': 'No Value',
      'amount': 'N/A',
    };
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        label == 'Network' || label == 'Date'
            ? Container(
                color: Theme.of(context).primaryColor,
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              )
            : Text(
                value,
                style: Theme.of(context).textTheme.labelLarge,
              ),
      ],
    );
  }
}
