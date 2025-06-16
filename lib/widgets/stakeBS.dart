import 'dart:async';
import 'package:crypto_beam/model/user.dart';
import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/services/transfer_service.dart';
import 'package:crypto_beam/states/verified_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Utility functions from Wallet and TradeTile
String numToCrypto(double value) {
  return value
      .toStringAsFixed(6)
      .replaceAll(RegExp(r'0+$'), '')
      .replaceAll(RegExp(r'\.$'), '');
}

String numToCurrency(double value, String decimals) {
  return '\$${value.toStringAsFixed(int.parse(decimals))}';
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

void showStakeBottomSheet(
    BuildContext context, String krakenPair, double currentPrice, ) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (BuildContext context) => BuySell(
      krakenPair: krakenPair,
      currentPrice: currentPrice,
    ),
  );
}

class BuySell extends ConsumerStatefulWidget {
  final String krakenPair;
  final double currentPrice;

  const BuySell({
    required this.krakenPair,
    required this.currentPrice,
    super.key,
  });

  @override
  ConsumerState<BuySell> createState() => _BuySellState();
}

class _BuySellState extends ConsumerState<BuySell>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _tpController = TextEditingController();
  final _slController = TextEditingController();
  final _leverageController = TextEditingController(text: '1.0');
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _tpController.dispose();
    _slController.dispose();
    _leverageController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  String _formatSymbol() {
    switch (widget.krakenPair) {
      case 'XBTUSD':
        return 'BTC/USD';
      case 'ETHUSD':
        return 'ETH/USD';
      case 'XDGUSD':
        return 'DOGE/USD';
      case 'SOLUSD':
        return 'SOL/USD';
      case 'BNBUSD':
        return 'BNB/USD';
      default:
        return widget.krakenPair;
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.read(authProvider).user;

    if (widget.currentPrice <= 0) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Invalid price data',
          style: TextStyle(fontSize: 18, color: Colors.red),
          semanticsLabel: 'Invalid price data',
        ),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.84,
      child: Column(
        children: [
          _buildSymbolDisplay(),
          _buildOrderInfo('Open Limit Order'),
          const Divider(),
          _buildForm(),
          _buildPrices(),
          // _buildSubmitButton(action),
          SizedBox(
            height: 65,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: ElevatedButton(
                    onPressed: () => _onSubmit(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    child: Text(
                      'SELL',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: ElevatedButton(
                    onPressed: () => _onSubmit(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF26A69A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    child: Text(
                      'BUY',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildAvailableBalance(user),
          SizedBox(height: 18),
        ],
      ),
    );
  }

  Widget _buildSymbolDisplay() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        _formatSymbol(),
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(fontWeight: FontWeight.bold),
        semanticsLabel: 'Trading pair ${_formatSymbol()}',
      ),
    );
  }

  Widget _buildOrderInfo(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
        semanticsLabel: title,
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            _buildTextField('Margin', _amountController),
            _buildTextField('Leverage', _leverageController, isLeverage: true),
            _buildTextField('Take Profit (USD)', _tpController, isPrice: true),
            _buildTextField('Stop Loss (USD)', _slController, isPrice: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPrice = false, bool isLeverage = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
            prefixText: isLeverage ? null : '\$ ',
            labelText: label,
            hintText: isLeverage ? 'e.g., 1.0' : 'Enter amount in USD',
            enabledBorder: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          final numValue = double.tryParse(value);
          if (numValue == null || numValue <= 0) {
            return '$label must be a positive number';
          }
          if (isLeverage && (numValue < 1 || numValue > 100)) {
            return 'Leverage must be between 1 and 100';
          }
          // if (isPrice) {
          //   if (action == 'Buy' &&
          //       label == 'Take Profit' &&
          //       numValue <= widget.currentPrice) {
          //     return 'Take Profit must be above current price';
          //   }
          //   if (action == 'Buy' &&
          //       label == 'Stop Loss' &&
          //       numValue >= widget.currentPrice) {
          //     return 'Stop Loss must be below current price';
          //   }
          //   if (action == 'Sell' &&
          //       label == 'Take Profit' &&
          //       numValue >= widget.currentPrice) {
          //     return 'Take Profit must be below current price';
          //   }
          //   if (action == 'Sell' &&
          //       label == 'Stop Loss' &&
          //       numValue <= widget.currentPrice) {
          //     return 'Stop Loss must be above current price';
          //   }
          // }
          return null;
        },
        onChanged: (value) {
          if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
          _debounceTimer = Timer(const Duration(milliseconds: 500), () {
            _formKey.currentState?.validate();
          });
        },
      ),
    );
  }

  Widget _buildAvailableBalance(User? user) {
    final prices = ref.watch(priceProvider);
    final balance = prices[widget.krakenPair];
  
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Available ${_formatSymbol()}',
            style: Theme.of(context).textTheme.bodyMedium,
            semanticsLabel: 'Available USD',
          ),
          Text(
            numToCurrency(balance ?? 0, '2'),
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
            semanticsLabel: 'Available balance ${numToCurrency(balance ?? 0, '2')}',
          ),
        ],
      ),
    );
  }

  Widget _buildPrices() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 18.0,
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            numToCurrency(widget.currentPrice + 3.5, '2'),
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
            semanticsLabel:
                'Sell Margin ${numToCurrency(widget.currentPrice + 3.5, '2')}',
          ),
          Text(
            numToCurrency(widget.currentPrice - 3.5, '2'),
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
            semanticsLabel:
                'Buy Margin ${numToCurrency(widget.currentPrice - 3.5, '2')}',
          ),
        ],
      ),
    );
  }

  void _onSubmit(bool isSell) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _placeOrder(isSell);
        if (context.mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (context.mounted) {
          showMessage(context, 'Error placing trade: $e');
        }
      }
    }
  }

  Future<void> _placeOrder(bool isSell) async {
    final user = ref.read(authProvider).user;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final margin = double.tryParse(_amountController.text);
    final tp =
        _tpController.text.isNotEmpty ? double.parse(_tpController.text) : null;
    final sl =
        _slController.text.isNotEmpty ? double.parse(_slController.text) : null;
    final leverage = double.tryParse(_leverageController.text) ?? 1.0;

    if (margin == null) {
      throw Exception('Invalid margin amount');
    }

    // final balance =
    //     TransferService.calculateUserDollarValue(user, ref.read(priceProvider));
    // if (balance < margin) {
    //   throw Exception('Insufficient funds for margin');
    // }

    await TransferService.initiateMarginTrade(
      context,
      ref,
      user,
      tp,
      sl,
      margin,
      widget.krakenPair,
      isSell,
      leverage,
    );
  }
}
