import 'package:crypto_bee/model/user.dart';
import 'package:crypto_bee/provider/auth_provider.dart';
import 'package:crypto_bee/widgets/button.dart';
import 'package:crypto_bee/widgets/loading.dart';
import 'package:crypto_bee/widgets/textField.dart';
import 'package:crypto_bee/x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Senddoge extends ConsumerStatefulWidget {
  const Senddoge({super.key});
  static const routeName = '/senddoge';

  @override
  ConsumerState<Senddoge> createState() => _SenddogeState();
}

class _SenddogeState extends ConsumerState<Senddoge> {
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
      if (!_hasEnoughBalance(amount, user!.DOGE)) {
        showMessage(
          context,
          'You don\'t have sufficient amount of DOGE for this transaction',
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
    var auth = ref.read(authProvider);
    await auth.withdrawRequest(
      _searchController.text,
      _amountController.text,
      user.name,
      'DOGE',
    );
    showMessage(
      context,
      'Your DOGE Withdrawal is processing, check Transaction history to confirm status',
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
        title: const Text('Send Doge'),
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
                  const SizedBox(height: 16),
                  Text(
                    'Address or Domain Name',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  _buildSearchTextField(),
                  const SizedBox(height: 24),
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
                    child: button(
                      context,
                      'Verify',
                      _verify,
                    ),
                  ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTextField() {
    return reusableTextField(
      'Search or Enter',
      _searchController,
      Theme.of(context).primaryColor,
      () {
        return null;
      },
    );
  }

  Widget _buildAmountTextField() {
    return transferTextField(
      Image.asset(
        'assets/images/doge.png',
        height: 18,
        width: 18,
      ),
      'Doge Amount',
      _amountController,
      Theme.of(context).primaryColor,
      () {
        return null;
      },
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
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => _updateAmount(percentage),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _updateAmount(double percentage) {
    final user = ref.read(authProvider).user;
    final amount = user!.DOGE * percentage;
    _amountController.text = amount.toStringAsFixed(8);
  }
}
