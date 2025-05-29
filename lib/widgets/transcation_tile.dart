import 'package:crypto_beam/model/transcation.dart';
import 'package:crypto_beam/states/verified_state.dart';
import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
        cryptoInfo['subtitle'] ?? 'No Value',
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
                  readTimestamp(transaction.date),
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
                  '0.000000',
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
                  'Date',
                  readTimestamp(transaction.date),
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
      final price = prices['BTC'] ?? 0.0;
      return {
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
      final price = prices['ETH'] ?? 0.0;
      return {
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
      final price = prices['DOGE'] ?? 0.0;
      return {
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
      final price = prices['SOL'] ?? 0.0;
      return {
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
      final price = prices['BNB'] ?? 0.0;
      return {
        'asset': 'assets/images/bnb.png',
        'title': isTrade
            ? 'BNB Spot Trading: ${numToCrypto(amount)}'
            : isWithdraw
                ? 'BNB Withdrew: ${numToCrypto(amount)}'
                : 'BNB Received: ${numToCrypto(amount)}',
        'subtitle': 'Binance Coin worth: ${numToCurrency(amount * price, '2')}',
        'amount': '${numToCrypto(amount)} BNB',
      };
    }

    return {
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
