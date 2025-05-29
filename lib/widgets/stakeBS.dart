import 'dart:async';
import 'package:crypto_beam/model/user.dart';
import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/services/transfer_service.dart';
import 'package:crypto_beam/states/verified_state.dart';
import 'package:crypto_beam/widgets/button.dart';
import 'package:crypto_beam/widgets/loading.dart';
import 'package:flutter/gestures.dart';
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
    BuildContext context, String krakenPair, double currentPrice, int index) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (BuildContext context) => BuySell(
      krakenPair: krakenPair,
      index: index,
      currentPrice: currentPrice,
    ),
  );
}

class BuySell extends ConsumerStatefulWidget {
  final String krakenPair;
  final int index;
  final double currentPrice;

  const BuySell({
    required this.krakenPair,
    required this.index,
    required this.currentPrice,
    super.key,
  });

  @override
  ConsumerState<BuySell> createState() => _BuySellState();
}

class _BuySellState extends ConsumerState<BuySell>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  bool _showTp = false;
  bool _showSl = false;
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _tpController = TextEditingController();
  final _slController = TextEditingController();
  final _leverageController = TextEditingController(text: '1.0');
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(initialIndex: widget.index, vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          _buildSymbolDisplay(),
          const SizedBox(height: 8),
          _buildTabBar(),
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _buildSymbolDisplay() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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

  Widget _buildTabBar() {
    return Container(
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TabBar(
        controller: _tabController,
        labelColor: 
        Theme.of(context).colorScheme.onPrimary,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: _tabController.index == 0 ? Colors.green : Colors.red,
          // Theme.of(context).colorScheme.primary,
        ),
        labelStyle: Theme.of(context)
            .textTheme
            .labelLarge!
            .copyWith(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: 'Buy'),
          Tab(text: 'Sell'),
        ],
        indicatorSize: TabBarIndicatorSize.tab,
        // semanticsLabel: 'Buy or Sell tabs',
      ),
    );
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      dragStartBehavior: DragStartBehavior.down,
      physics: BouncingScrollPhysics(),
      children: ['Buy', 'Sell'].map(_buildSingleTabContent).toList(),
    );
  }

  Widget _buildSingleTabContent(String action) {
    final user = ref.watch(authProvider).user;
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      children: [
        _buildOrderInfo('Open Limit Order'),
        _buildOrderInfo(
            'Current Price: ${numToCurrency(widget.currentPrice, '2')}'),
        const Divider(),
        _buildForm(action),
        _buildAvailableBalance(user),
        _buildSubmitButton(action),
      ],
    );
  }

  Widget _buildOrderInfo(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
        semanticsLabel: title,
      ),
    );
  }

  Widget _buildForm(String action) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField('Margin', _amountController, action),
          _buildTextField('Leverage', _leverageController, action,
              isLeverage: true),
          _buildCheckbox('Take Profit', _showTp,
              (value) => setState(() => _showTp = value!)),
          if (_showTp)
            _buildTextField('Take Profit (USD)', _tpController, action,
                isPrice: true),
          _buildCheckbox('Stop Loss', _showSl,
              (value) => setState(() => _showSl = value!)),
          if (_showSl)
            _buildTextField('Stop Loss (USD)', _slController, action,
                isPrice: true),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String action,
      {bool isPrice = false, bool isLeverage = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          prefixText: isLeverage ? null : '\$ ',
          labelText: label,
          hintText: isLeverage ? 'e.g., 1.0' : 'Enter amount in USD',
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
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
          if (isPrice) {
            if (action == 'Buy' &&
                label == 'Take Profit' &&
                numValue <= widget.currentPrice) {
              return 'Take Profit must be above current price';
            }
            if (action == 'Buy' &&
                label == 'Stop Loss' &&
                numValue >= widget.currentPrice) {
              return 'Stop Loss must be below current price';
            }
            if (action == 'Sell' &&
                label == 'Take Profit' &&
                numValue >= widget.currentPrice) {
              return 'Take Profit must be below current price';
            }
            if (action == 'Sell' &&
                label == 'Stop Loss' &&
                numValue <= widget.currentPrice) {
              return 'Stop Loss must be above current price';
            }
          }
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

  Widget _buildCheckbox(
      String label, bool value, void Function(bool?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
            semanticsLabel: label,
          ),
          Checkbox(
            value: value,
            onChanged: onChanged,
            side: BorderSide(color: Theme.of(context).colorScheme.outline),
            // semanticsLabel: 'Toggle $label',
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableBalance(User? user) {
    final prices = ref.watch(priceProvider);
    final balance = user != null
        ? TransferService.calculateUserDollarValue(user, prices)
        : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Available USD',
            style: Theme.of(context).textTheme.bodyMedium,
            semanticsLabel: 'Available USD',
          ),
          Text(
            numToCurrency(balance, '2'),
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
            semanticsLabel: 'Available balance ${numToCurrency(balance, '2')}',
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(String action) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: _isLoading
          ? const Loading()
          : CustomButton(
              name: action,
              onTap: _onSubmit,
              color: _isLoading
                  ? Theme.of(context).colorScheme.surfaceContainerHighest
                  : Theme.of(context).colorScheme.primary,
            ),
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await _placeOrder();
        if (context.mounted) {
          showMessage(context, 'Trade placed successfully');
          Navigator.pop(context);
        }
      } catch (e) {
        if (context.mounted) {
          showMessage(context, 'Error placing trade: $e');
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _placeOrder() async {
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
    final isSell = _tabController.index == 1;

    if (margin == null) {
      throw Exception('Invalid margin amount');
    }

    final balance =
        TransferService.calculateUserDollarValue(user, ref.read(priceProvider));
    if (balance < margin) {
      throw Exception('Insufficient funds for margin');
    }

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
