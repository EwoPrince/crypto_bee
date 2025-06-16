import 'package:crypto_beam/model/user.dart';
import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/services/transfer_service.dart';
import 'package:crypto_beam/states/verified_state.dart';
import 'package:crypto_beam/widgets/button.dart';
import 'package:crypto_beam/widgets/loading.dart';
import 'package:crypto_beam/widgets/textField.dart';
import 'package:crypto_beam/states/repository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:crypto_beam/x.dart';

// Utility functions from Explore
String numToCrypto(double value) {
  return value
      .toStringAsFixed(6)
      .replaceAll(RegExp(r'0+$'), '')
      .replaceAll(RegExp(r'\.$'), '');
}

String numToCurrency(double value, String decimals) {
  return '\$${value.toStringAsFixed(int.parse(decimals))}';
}

// Show message utility
void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

class Swapcoin extends ConsumerStatefulWidget {
  final String? symbol;
  const Swapcoin({this.symbol, super.key});
  static const routeName = '/Swapcoin';

  @override
  ConsumerState<Swapcoin> createState() => _SwapcoinState();
}

class _SwapcoinState extends ConsumerState<Swapcoin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final KrakenRepository _repository = KrakenRepository();
  bool _isLoading = false;
  String? _errorMessage;
  String currentSymbol = 'XBTUSD';
  String currentLabel = 'BTC';

  final List<Map<String, String>> symbols = [
    {'pair': 'XBTUSD', 'label': 'BTC'},
    {'pair': 'BNBUSD', 'label': 'BNB'},
    {'pair': 'ETHUSD', 'label': 'ETH'},
    {'pair': 'XDGUSD', 'label': 'DOGE'},
    {'pair': 'SOLUSD', 'label': 'SOL'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  void _initializeState() {
    setState(() {
      currentSymbol = widget.symbol ?? 'XBTUSD';
      currentLabel = symbols.firstWhere((s) => s['pair'] == currentSymbol,
          orElse: () => symbols[0])['label']!;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _amountController.dispose();
    _repository.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final prices = ref.watch(priceProvider);
    final user = ref.read(authProvider).user;

    if (user == null) {
      setState(() {
        _errorMessage = 'User not logged in';
      });
      return;
    }

    if (_formKey.currentState!.validate()) {
      final sourceAmount = _parseAmount(_searchController.text);
      if (sourceAmount == null) return;

      final sourcePrice = prices[currentSymbol] ?? 0.0;
      final targetPrice = prices[
              symbols.firstWhere((s) => s['label'] == currentLabel)['pair']] ??
          0.0;

      if (sourcePrice == 0.0 || targetPrice == 0.0) {
        showMessage(context, 'Price data unavailable for selected pair');
        return;
      }

      final sourceBalance = _getUserBalance(currentSymbol, user);
      if (sourceAmount > sourceBalance) {
        showMessage(context, 'Insufficient $currentSymbol balance');
        return;
      }

      _startLoading();
      try {
        await _processSwap();
      } catch (e) {
        showMessage(context, 'Swap failed: $e');
        setState(() {
          _errorMessage = 'Swap failed: $e';
        });
      } finally {
        _stopLoading();
      }
    }
  }

  double? _parseAmount(String text) {
    final amount = double.tryParse(text);
    if (amount == null || amount <= 0) {
      showMessage(
          context, 'Invalid amount entered. Please enter a valid number.');
      return null;
    }
    return amount;
  }

  double _getUserBalance(String symbol, User user) {
    switch (symbol) {
      case 'XBTUSD':
        return user.BTC;
      case 'ETHUSD':
        return user.ETH;
      case 'XDGUSD':
        return user.DOGE;
      case 'SOLUSD':
        return user.SOL;
      case 'BNBUSD':
        return user.BNB;
      default:
        return 0.0;
    }
  }

  static String _getsymbol(String symbol) {
    switch (symbol) {
      case 'BTC':
        return "BTC";
      case 'XBTUSD':
        return "BTC";
      case 'BTCUSD':
        return "BTC";
      case 'ETH':
        return "ETH";
      case 'ETHUSD':
        return "ETH";
      case 'DOGE':
        return "DOGE";
      case 'XDGUSD':
        return "DOGE";
      case 'SOL':
        return "SOL";
      case 'SOLUSD':
        return "SOL";
      case 'BNB':
        return "BNB";
      case 'BNBUSD':
        return "BNB";
      default:
        return "BTC";
    }
  }

  Future<void> _processSwap() async {
    final sourceAmount = _parseAmount(_searchController.text);
    final targetAmount = _parseAmount(_amountController.text);

    if (sourceAmount == null || targetAmount == null) return;

    await TransferService.swapRequest(
      sourceAmount.toString(),
      targetAmount.toString(),
      _getsymbol(currentLabel),
      _getsymbol(currentSymbol),
    );

    showMessage(
      context,
      'Crypto Beam coin swap in process, check transaction history to confirm status',
    );
    Navigator.pop(context);
  }

  void _startLoading() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
  }

  void _stopLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  void _updateAmount(String targetLabel) {
    final prices = ref.watch(priceProvider);
    final user = ref.read(authProvider).user;
    if (user == null) return;

    setState(() {
      currentLabel = targetLabel;
    });

    final sourcePrice = prices[currentSymbol] ?? 0.0;
    final targetPair =
        symbols.firstWhere((s) => s['label'] == targetLabel)['pair']!;
    final targetPrice = prices[targetPair] ?? 0.0;

    if (sourcePrice == 0.0 || targetPrice == 0.0) {
      showMessage(context, 'Price data unavailable for conversion');
      return;
    }

    final sourceBalance = _getUserBalance(currentSymbol, user);
    final sourceAmount = _searchController.text.isEmpty
        ? sourceBalance
        : _parseAmount(_searchController.text) ?? 0.0;

    if (_searchController.text.isEmpty) {
      _searchController.text = numToCrypto(sourceBalance);
    }

    final targetAmount = (sourceAmount * sourcePrice) / targetPrice;
    _amountController.text = numToCrypto(targetAmount);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Convert')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage!,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verify,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Convert'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                autovalidateMode: AutovalidateMode.always,
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(height: 16),
                    // Text(
                    //   'Convert from',
                    //   style: Theme.of(context).textTheme.bodyMedium,
                    //   semanticsLabel: 'Source cryptocurrency',
                    // ),
                    const SizedBox(height: 8),
                    _buildSearchTextField(),
                    const SizedBox(height: 24),
                    Text(
                      'To',
                      style: Theme.of(context).textTheme.bodyMedium,
                      semanticsLabel: 'Target cryptocurrency',
                    ),
                    const SizedBox(height: 8),
                    _buildSwapButtons(),
                    const SizedBox(height: 8),
                    _buildAmountTextField(),
                  ],
                ),
              ),
              SizedBox(height: 40),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Semantics(
          label: 'Select source cryptocurrency',
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: EdgeInsets.all(28.0),
                child: Text(
                  _formatSymbol(currentSymbol),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ).onTap(_showSymbolSelectionBottomSheet),
          ),
        ),
        CustomTextField(
          labelText: 'Send Amount (${_formatSymbol(currentSymbol)})',
          hintText: _formatPrice(currentSymbol),
          controller: _searchController,
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(Icons.dialpad),
          maxLines: 1,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Amount to convert is required';
            }
            return null;
          },
          // semanticsLabel: 'Receive amount in $currentLabel',
        ),
      ],
    );
  }

  Widget _buildAmountTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Receive Amount ($currentLabel)',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _amountController.text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
        ),
      ],
    );

    // CustomTextField(
    //   labelText: 'Receive Amount ($currentLabel)',
    //   hintText: 'Enter amount in $currentLabel',
    //   controller: _amountController,
    //   keyboardType: TextInputType.number,
    //   prefixIcon: const Icon(Icons.dialpad),
    //   maxLines: 1,
    //   validator: (value) {
    //     if (value == null || value.isEmpty) {
    //       return 'Enter amount in $currentLabel';
    //     }
    //     return null;
    //   },
    //   // semanticsLabel: 'Receive amount in $currentLabel',
    // );
  }

  Widget _buildSwapButtons() {
    return Wrap(
      children: symbols
          .map((s) => _buildSwapButton(
                s['label']!,
                _getImagePath(s['label']!),
              ))
          .toList(),
    );
  }

  Widget _buildSwapButton(String label, String image) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton(
        onPressed: () => _updateAmount(label),
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                height: 18,
                width: 18,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getImagePath(String label) {
    switch (label) {
      case 'BTC':
        return 'assets/images/btc.png';
      case 'BNB':
        return 'assets/images/bnb.png';
      case 'ETH':
        return 'assets/images/eth.png';
      case 'DOGE':
        return 'assets/images/doge.png';
      case 'SOL':
        return 'assets/images/sol.png';
      default:
        return 'assets/images/default.png';
    }
  }

  String _formatPrice(String symbol) {
    final user = ref.read(authProvider).user;
    final balance = _getUserBalance(symbol, user!);
    return numToCurrency(
        balance * (ref.read(priceProvider)[symbol] ?? 0.0), '2');
  }

  String _formatSymbol(String symbol) {
    return symbols.firstWhere((s) => s['pair'] == symbol,
        orElse: () => symbols[0])['label']!;
  }

  void _showSymbolSelectionBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 300,
            height: MediaQuery.of(context).size.height * 0.75,
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
            child: ListView(
              children: symbols
                  .map((s) =>
                      _buildSymbolButton(context, s['pair']!, s['label']!))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSymbolButton(BuildContext context, String pair, String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 70,
        height: 40,
        child: RawMaterialButton(
          elevation: 0,
          fillColor: const Color(0xFF494537),
          onPressed: () {
            setState(() {
              currentSymbol = pair;
            });
            Navigator.of(context).pop();
            _updateAmount(currentLabel);
          },
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFFF0B90A)),
          ),
        ),
      ),
    );
  }
}
