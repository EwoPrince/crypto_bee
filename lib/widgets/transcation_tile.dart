import 'package:crypto_beam/model/transcation.dart';
import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TranscationTile extends ConsumerWidget {
  const TranscationTile({super.key, required this.transcation});
  final Transcation transcation;

  @override
  Widget build(BuildContext context, ref) {
    return ExpansionTile(
      leading: Image.asset(
        transcation.BTC != 0
            ? 'assets/images/btc.png'
            : transcation.ETH != 0
                ? 'assets/images/eth.png'
                : transcation.DOGE != 0
                    ? 'assets/images/doge.png'
                    : transcation.SOL != 0
                        ? 'assets/images/sol.png'
                        : transcation.BNB != 0
                            ? 'assets/images/bnb.png'
                            : '',
        width: 40,
        height: 40,
        fit: BoxFit.contain,
      ),
      title: Text(
        transcation.BTC != 0
            ? transcation.withdraw!
                ? 'BTC Withdrew: ${numToCrypto(transcation.BTC! / btcPrice)}'
                : 'BTC Received: ${numToCrypto(transcation.BTC! / btcPrice)}'
            : transcation.ETH != 0
                ? transcation.withdraw!
                    ? 'ETH Withdrew: ${numToCrypto(transcation.ETH! / ethPrice)}'
                    : 'ETH Received: ${numToCrypto(transcation.ETH! / ethPrice)}'
                : transcation.DOGE != 0
                    ? transcation.withdraw!
                        ? 'DOGE Withdrew: ${numToCrypto(transcation.DOGE! / dogePrice)}'
                        : 'DOGE Received: ${numToCrypto(transcation.DOGE! / dogePrice)}'
                    : transcation.SOL != 0
                        ? transcation.withdraw!
                            ? 'SOL Withdrew: ${numToCrypto(transcation.SOL! / solPrice)}'
                            : 'SOL Received: ${numToCrypto(transcation.SOL! / solPrice)}'
                        : transcation.BNB != 0
                            ? transcation.withdraw!
                                ? 'BNB Withdrew: ${numToCrypto(transcation.BNB! / bnbPrice)}'
                                : 'BNB Received: ${numToCrypto(transcation.BNB! / bnbPrice)}'
                            : 'Dollar',
      ),
      subtitle: Text(
        transcation.BTC != 0
            ? 'Bitcoin worth: \$ ${transcation.BTC}'
            : transcation.ETH != 0
                ? 'Ethereum worth: \$ ${transcation.ETH}'
                : transcation.DOGE != 0
                    ? 'Doge worth: \$ ${transcation.DOGE}'
                    : transcation.SOL != 0
                        ? 'Solana worth: \$ ${transcation.SOL}'
                        : transcation.BNB != 0
                            ? 'Binance Coin worth: \$ ${transcation.BNB}'
                            : 'Dollar',
      ),
      children: [
        Divider(),
        ListTile(
          title: Text('${transcation.receiver_username!}'),
          subtitle: Text(
            readTimestamp(transcation.date),
          ),
        ),
      ],
    );
  }
}
