import 'package:crypto_beam/model/user.dart';
import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/services/transfer_service.dart';
import 'package:crypto_beam/states/verified_state.dart';
import 'package:crypto_beam/widgets/button.dart';
import 'package:crypto_beam/widgets/loading.dart';
import 'package:crypto_beam/widgets/textField.dart';
import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Sendbtc extends ConsumerStatefulWidget {
  final String? symbol;
  const Sendbtc({this.symbol, super.key});
  static const routeName = '/sendbtc';

  @override
  ConsumerState<Sendbtc> createState() => _SendbtcState();
}

class _SendbtcState extends ConsumerState<Sendbtc> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final List<Map<String, String>> symbols = [
    {'pair': 'XBTUSD', 'label': 'BTC'},
    {'pair': 'BNBUSD', 'label': 'BNB'},
    {'pair': 'ETHUSD', 'label': 'ETH'},
    {'pair': 'XDGUSD', 'label': 'DOGE'},
    {'pair': 'SOLUSD', 'label': 'SOL'},
    {'pair': 'HMSTRUSD', 'label': 'HMSTR'},
    {'pair': 'PEPEUSD', 'label': 'PEPE'},
    {'pair': 'MNTUSD', 'label': 'MNT'},
    {'pair': 'TRXUSD', 'label': 'TRX'},
    {'pair': 'USDTUSD', 'label': 'USDT'},
    {'pair': 'USDCUSD', 'label': 'USDC'},
    {'pair': 'XRPUSD', 'label': 'XRP'},
    {'pair': 'XUSD', 'label': 'X'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (_formKey.currentState!.validate()) {
      final amount = _parseAmount();
      if (amount == null) return;
      final user = ref.read(authProvider).user;
      if(widget.symbol == 'BTC'){
      if (!_hasEnoughBalance(amount, user!.BTC)) {
        showMessage(
          context,
          'You don\'t have sufficient amount of ${widget.symbol} for this transaction',
        );
        return;
      }}
      if(widget.symbol == 'BNB'){
      if (!_hasEnoughBalance(amount, user!.BNB)) {
        showMessage(
          context,
          'You don\'t have sufficient amount of ${widget.symbol} for this transaction',
        );
        return;
      }}
      if(widget.symbol == 'ETH'){
      if (!_hasEnoughBalance(amount, user!.ETH)) {
        showMessage(
          context,
          'You don\'t have sufficient amount of ${widget.symbol} for this transaction',
        );
        return;
      }}
      if(widget.symbol == 'DOGE'){
      if (!_hasEnoughBalance(amount, user!.DOGE)) {
        showMessage(
          context,
          'You don\'t have sufficient amount of ${widget.symbol} for this transaction',
        );
        return;
      }}
      if(widget.symbol == 'SOL'){
      if (!_hasEnoughBalance(amount, user!.SOL)) {
        showMessage(
          context,
          'You don\'t have sufficient amount of ${widget.symbol} for this transaction',
        );
        return;
      }}
      if(widget.symbol == 'HMSTR'){
      if (!_hasEnoughBalance(amount, user!.HMSTR)) {
        showMessage(
          context,
          'You don\'t have sufficient amount of ${widget.symbol} for this transaction',
        );
        return;
      }}
      if(widget.symbol == 'PEPE'){
      if (!_hasEnoughBalance(amount, user!.PEPE)) {
        showMessage(
          context,
          'You don\'t have sufficient amount of ${widget.symbol} for this transaction',
        );
        return;
      }}
      if(widget.symbol == 'MNT'){
      if (!_hasEnoughBalance(amount, user!.MNT)) {
        showMessage(
          context,
          'You don\'t have sufficient amount of ${widget.symbol} for this transaction',
        );
        return;
      }}
      if(widget.symbol == 'TRX'){
      if (!_hasEnoughBalance(amount, user!.TRX)) {
        showMessage(
          context,
          'You don\'t have sufficient amount of ${widget.symbol} for this transaction',
        );
        return;
      }}
      if(widget.symbol == 'USDT'){
      if (!_hasEnoughBalance(amount, user!.USDT)) {
        showMessage(
          context,
          'You don\'t have sufficient amount of ${widget.symbol} for this transaction',
        );
        return;
      }}
      if(widget.symbol == 'USDC'){
      if (!_hasEnoughBalance(amount, user!.USDC)) {
        showMessage(
          context,
          'You don\'t have sufficient amount of ${widget.symbol} for this transaction',
        );
        return;
      }}
      if(widget.symbol == 'XRP'){
      if (!_hasEnoughBalance(amount, user!.XRP)) {
        showMessage(
          context,
          'You don\'t have sufficient amount of ${widget.symbol} for this transaction',
        );
        return;
      }}
      if(widget.symbol == 'X'){
      if (!_hasEnoughBalance(amount, user!.X)) {
        showMessage(
          context,
          'You don\'t have sufficient amount of ${widget.symbol} for this transaction',
        );
        return;
      }}
      _startLoading();
      await _processWithdrawal(user!, amount);
      _stopLoading();
    }
  }

  double? _parseAmount() {
    final amountText = _amountController.text;
    final amount = double.tryParse(amountText);
    if (amount == null) {
      showMessage(
        context,
        'Invalid amount entered. Please enter a valid number.',
      );
      return null;
    }
    return amount;
  }

  bool _hasEnoughBalance(double amount, double balance) {
    if (amount > balance) {
      return false;
    }
    return true;
  }

  Future<void> _processWithdrawal(User user, double amount) async {
    await TransferService.withdrawRequest(
      _searchController.text,
      _amountController.text,
      user.name,
      widget.symbol ?? '___',
      ref.read(priceProvider),
    );
    showMessage(
      context,
      'Your ${widget.symbol} Withdrawal is processing, check Transaction history to confirm status',
    );
    Navigator.pop(context);
  }

  void _startLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void _stopLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Send ${widget.symbol}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                autovalidateMode: AutovalidateMode.always,
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Address or Domain Name',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 18),
                    _buildSearchTextField(),
                    const SizedBox(height: 32),
                    Text(
                      'Amount',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildPercentageButtons(), // Added percentage buttons
                    const SizedBox(height: 8),
                    _buildAmountTextField(),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _isLoading
                  ? const Loading()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomButton(
                        name: 'Verify',
                        onTap: _verify,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchTextField() {
    return CustomTextField(
      labelText: 'Enter Wallet Address',
      hintText: 'hold to paste address',
      controller: _searchController,
    );
  }

  Widget _buildAmountTextField() {
    final prices = ref.watch(priceProvider);
    final BTCPrice = prices[widget.symbol] ?? 0.0;
    return CustomTextField(
      labelText: '${widget.symbol} amount',
      hintText: "$BTCPrice",
      controller: _amountController,
      keyboardType: TextInputType.number,
      prefixIcon: const Icon(Icons.dialpad),
      maxLines: 1,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Amount in Dollars is required';
        }
        return null;
      },
      // semanticsLabel: 'Receive amount in $currentLabel',
    );
  }

  Widget _buildPercentageButtons() {
    return Wrap(
      children: [
        _buildPercentageButton('10%', 0.1),
        _buildPercentageButton('25%', 0.25),
        _buildPercentageButton('50%', 0.5),
        _buildPercentageButton('75%', 0.75),
        _buildPercentageButton('100%', 1.0),
      ],
    );
  }

  Widget _buildPercentageButton(String label, double percentage) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton(
        onPressed: () => _updateAmount(percentage),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: SizedBox(
          height: 50,
          width: 78,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void _updateAmount(double percentage) {
    final user = ref.read(authProvider).user;
    if (widget.symbol == 'BTC') {
      double amount = user!.BTC * percentage;
    _amountController.text = amount.toStringAsFixed(8);
    }
    if (widget.symbol == 'BNB') {
      double amount = user!.BNB * percentage;
    _amountController.text = amount.toStringAsFixed(8);
    }
    if (widget.symbol == 'ETH') {
      double amount = user!.ETH * percentage;
    _amountController.text = amount.toStringAsFixed(8);
    }
    if (widget.symbol == 'DOGE') {
      double amount = user!.DOGE * percentage;
    _amountController.text = amount.toStringAsFixed(8);
    }
    if (widget.symbol == 'SOL') {
      double amount = user!.SOL * percentage;
    _amountController.text = amount.toStringAsFixed(8);
    }
    if (widget.symbol == 'HMSTR') {
      double amount = user!.HMSTR * percentage;
    _amountController.text = amount.toStringAsFixed(8);
    }
    if (widget.symbol == 'PEPE') {
      double amount = user!.PEPE * percentage;
    _amountController.text = amount.toStringAsFixed(8);
    }
    if (widget.symbol == 'MNT') {
      double amount = user!.MNT * percentage;
    _amountController.text = amount.toStringAsFixed(8);
    }
    if (widget.symbol == 'TRX') {
      double amount = user!.TRX * percentage;
    _amountController.text = amount.toStringAsFixed(8);
    }
    if (widget.symbol == 'USDT') {
      double amount = user!.USDT * percentage;
    _amountController.text = amount.toStringAsFixed(8);
    }
    if (widget.symbol == 'USDC') {
      double amount = user!.USDC * percentage;
    _amountController.text = amount.toStringAsFixed(8);
    }
    if (widget.symbol == 'XRP') {
      double amount = user!.XRP * percentage;
    _amountController.text = amount.toStringAsFixed(8);
    }
    if (widget.symbol == 'X') {
      double amount = user!.X * percentage;
    _amountController.text = amount.toStringAsFixed(8);
    }

  }
}
