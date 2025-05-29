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

class Sendsol extends ConsumerStatefulWidget {
  const Sendsol({super.key});
  static const routeName = '/sendsol';

  @override
  ConsumerState<Sendsol> createState() => _SendsolState();
}

class _SendsolState extends ConsumerState<Sendsol> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

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
      if (!_hasEnoughBalance(amount, user!.SOL)) {
        showMessage(
          context,
          'You don\'t have sufficient amount of SOL for this transaction',
        );
        return;
      }
      _startLoading();
      await _processWithdrawal(user, amount);
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
      'SOL',
      ref.read(priceProvider),
    );
    showMessage(
      context,
      'Your SOL Withdrawal is processing, check Transaction history to confirm status',
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
        title: const Text('Send Solana'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            const Spacer(),
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
    final BTCPrice = prices['BTCUSD'] ?? 0.0;
    return CustomTextField(
      labelText: 'BTC amount',
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
          height: 80,
          width: 120,
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
    final amount = user!.SOL * percentage;
    _amountController.text = amount.toStringAsFixed(8);
  }
}
