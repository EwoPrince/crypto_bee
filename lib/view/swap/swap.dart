import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/widgets/button.dart';
import 'package:crypto_beam/widgets/loading.dart';
import 'package:crypto_beam/widgets/textField.dart';
import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Swapcoin extends ConsumerStatefulWidget {
  final String? symbol;
  const Swapcoin({this.symbol, super.key});
  static const routeName = '/Swapcoin';

  @override
  ConsumerState<Swapcoin> createState() => _SendbtcState();
}

class _SendbtcState extends ConsumerState<Swapcoin> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final List<String> symbols = [
    'XBTUSD',
    'BNB/USD',
    'ETH/USD',
    'XDGUSD',
    'SOL/USD',
  ];
  String currentSymbol = "XBTUSD";
  String currentLabel = 'BTC';

  @override
  void dispose() {
    _searchController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  void _initializeState() {
    setState(() {
      currentSymbol = widget.symbol ?? "XBTUSD";
    });
  }

  Future<void> _verify() async {
    if (_formKey.currentState!.validate()) {
      final amount = _parseAmount();
      if (amount == null) return;
      final user = ref.read(authProvider).user;
      if (!_hasEnoughBalance(amount, user!.dollar)) {
        showMessage(
          context,
          'You don\'t have sufficient amount of Cryptocurrency for this transaction',
        );
        return;
      }
      _startLoading();
      await _processSwap();
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

  double? _parsesearchAmount() {
    final amountText = _searchController.text;
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

  Future<void> _processSwap() async {
    var auth = ref.read(authProvider);
    await auth.swapRequest(
      _searchController.text,
      _amountController.text,
      currentLabel,
      _formatSymbol(currentSymbol),
    );
    showMessage(
      context,
      'cryptobee coin Swap in process, check Transaction history to confirm status',
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
        title: const Text('cryptobee Swap'),
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
                    'Convert from ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  _buildSearchTextField(),
                  const SizedBox(height: 24),
                  Text(
                    'To',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  _buildswapButtons(),
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
                        name: 
                      'Verify',
                     onTap:  _verify,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          _formatSymbol(currentSymbol),
          style: Theme.of(context).textTheme.headlineSmall,
        ).onTap(
          () {
            _showSymbolSelectionBottomSheet(context);
          },
        ),
        SizedBox(
          width: 300,
          child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return "amount for convert is required";
                }
                return null;
              },
              controller: _searchController,
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16,
              ),
              decoration: InputDecoration(
                prefix: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '  \$',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                labelText: 'amount',
                hintText: _formatPrice(currentSymbol),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.number),
        ),
      ],
    );
  }

  Widget _buildAmountTextField() {
    return   CustomTextField(
                labelText: 'Recovery Amount',
                hintText: 'Enter Recovery Amount in Dollars',
                controller: _amountController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.dialpad),
                maxLines: 1,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Recovery Amount in Dollars';
                  }
                  return null;
                },
              );
      }

  Widget _buildswapButtons() {
    return Wrap(
      children: [
        _buildswapButton(
          'BTC',
          'assets/images/btc.png',
        ),
        _buildswapButton(
          'BNB',
          'assets/images/bnb.png',
        ),
        _buildswapButton(
          'ETH',
          'assets/images/eth.png',
        ),
        _buildswapButton(
          'DOGE',
          'assets/images/doge.png',
        ),
        _buildswapButton(
          'SOL',
          'assets/images/sol.png',
        ),
      ],
    );
  }

  Widget _buildswapButton(String label, String image) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => _updateAmount(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: SizedBox(
          width: 90,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                height: 18,
                width: 18,
              ),
              SizedBox(width: 8),
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

  String _formatPrice(String symbol) {
    var user = ref.read(authProvider).user;
    if (symbol == 'XBTUSD') return '\$ ${user!.BTC}';
    if (symbol == 'XDGUSD') return "\$ ${user!.DOGE}";
    if (symbol == 'ETH/USD') return "\$ ${user!.ETH}";
    if (symbol == 'SOL/USD') return "\$ ${user!.SOL}";
    if (symbol == 'BNB/USD') return "\$ ${user!.BNB}";
    return symbol;
  }

  String _formatSymbol(String symbol) {
    if (symbol == 'XBTUSD') return "BTC";
    if (symbol == 'XDGUSD') return "DOGE";
    if (symbol == 'ETH/USD') return "ETH";
    if (symbol == 'SOL/USD') return "SOL";
    if (symbol == 'BNB/USD') return "BNB";
    return symbol;
  }

  void _showSymbolSelectionBottomSheet(BuildContext context) {
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
                    .map((e) => _buildSymbolButton(context, e))
                    .toList()),
          ),
        ),
      ),
    );
  }

  Widget _buildSymbolButton(BuildContext context, String e) {
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
              currentSymbol = e;
            });
            Navigator.of(context).pop();
          },
          child: Text(_formatSymbol(e),
              style: const TextStyle(color: Color(0xFFF0B90A))),
        ),
      ),
    );
  }

  void _updateAmount(String label) {
    setState(() {
      currentLabel = label;
    });
    final user = ref.read(authProvider).user;
    if (label == 'BTC' && currentSymbol == 'XBTUSD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.BTC * btcPrice) / btcPrice;
        setState(() {
          _searchController.text = user.BTC.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * btcPrice) / btcPrice;
      setState(() {
        _amountController.text = amount.toStringAsFixed(8);
      });
    }
    if (label == 'BNB' && currentSymbol == 'XBTUSD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.BTC * btcPrice) / bnbPrice;
        setState(() {
          _searchController.text = user.BTC.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * btcPrice) / bnbPrice;
      setState(() {
        _amountController.text = amount.toStringAsFixed(8);
      });
    }
    if (label == 'ETH' && currentSymbol == 'XBTUSD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.BTC * btcPrice) / ethPrice;
        setState(() {
          _searchController.text = user.BTC.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * btcPrice) / ethPrice;
      setState(() {
        _amountController.text = amount.toStringAsFixed(8);
      });
    }
    if (label == 'DOGE' && currentSymbol == 'XBTUSD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.BTC * btcPrice) / dogePrice;
        setState(() {
          _searchController.text = user.BTC.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * btcPrice) / dogePrice;
      setState(() {
        _amountController.text = amount.toStringAsFixed(8);
      });
    }
    if (label == 'SOL' && currentSymbol == 'XBTUSD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.BTC * btcPrice) / solPrice;
        setState(() {
          _searchController.text = user.BTC.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * btcPrice) / solPrice;
      setState(() {
        _amountController.text = amount.toStringAsFixed(8);
      });
    }
    if (label == 'BTC' && currentSymbol == 'ETH/USD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.ETH * ethPrice) / btcPrice;
        setState(() {
          _searchController.text = user.ETH.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * ethPrice) / btcPrice;
      setState(() {
        _amountController.text = amount.toStringAsFixed(8);
      });
    }
    if (label == 'BNB' && currentSymbol == 'ETH/USD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.ETH * ethPrice) / bnbPrice;
        setState(() {
          _searchController.text = user.ETH.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * ethPrice) / bnbPrice;
      setState(() {
        _amountController.text = amount.toStringAsFixed(8);
      });
    }
    if (label == 'ETH' && currentSymbol == 'ETH/USD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.ETH * ethPrice) / ethPrice;
        setState(() {
          _searchController.text = user.ETH.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * ethPrice) / ethPrice;
      setState(() {
        _amountController.text = amount.toStringAsFixed(8);
      });
    }
    if (label == 'DOGE' && currentSymbol == 'ETH/USD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.ETH * ethPrice) / dogePrice;
        setState(() {
          _searchController.text = user.ETH.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * ethPrice) / dogePrice;
      setState(() {
        _amountController.text = amount.toStringAsFixed(8);
      });
    }
    if (label == 'SOL' && currentSymbol == 'ETH/USD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.ETH * ethPrice) / solPrice;
        setState(() {
          _searchController.text = user.ETH.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * ethPrice) / solPrice;
      setState(() {
        _amountController.text = amount.toStringAsFixed(8);
      });
    }
    if (label == 'BTC' && currentSymbol == 'XDGUSD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.DOGE * dogePrice) / btcPrice;
        setState(() {
          _searchController.text = user.DOGE.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * dogePrice) / btcPrice;
      setState(() {
        _amountController.text = amount.toStringAsFixed(8);
      });
    }
    if (label == 'BNB' && currentSymbol == 'XDGUSD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.DOGE * dogePrice) / bnbPrice;
        setState(() {
          _searchController.text = user.DOGE.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * dogePrice) / bnbPrice;
      _amountController.text = amount.toStringAsFixed(8);
    }
    if (label == 'ETH' && currentSymbol == 'XDGUSD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.DOGE * dogePrice) / ethPrice;
        setState(() {
          _searchController.text = user.DOGE.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * dogePrice) / ethPrice;
      setState(() {
        _amountController.text = amount.toStringAsFixed(8);
      });
    }
    if (label == 'DOGE' && currentSymbol == 'XDGUSD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.DOGE * dogePrice) / dogePrice;
        setState(() {
          _searchController.text = user.DOGE.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * dogePrice) / dogePrice;
      setState(() {
        _amountController.text = amount.toStringAsFixed(8);
      });
    }
    if (label == 'SOL' && currentSymbol == 'XDGUSD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.DOGE * dogePrice) / solPrice;
        setState(() {
          _searchController.text = user.DOGE.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * dogePrice) / solPrice;
      setState(() {
        _amountController.text = amount.toStringAsFixed(8);
      });
    }
    if (label == 'BTC' && currentSymbol == 'SOL/USD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.SOL * solPrice) / btcPrice;
        setState(() {
          _searchController.text = user.SOL.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * solPrice) / btcPrice;
      setState(() {
        _amountController.text = amount.toStringAsFixed(8);
      });
    }
    if (label == 'BNB' && currentSymbol == 'SOL/USD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.SOL * solPrice) / bnbPrice;
        setState(() {
          _searchController.text = user.SOL.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * solPrice) / bnbPrice;
      setState(() {
        _amountController.text = amount.toStringAsFixed(8);
      });
    }
    if (label == 'ETH' && currentSymbol == 'SOL/USD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.SOL * solPrice) / ethPrice;
        setState(() {
          _searchController.text = user.SOL.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * solPrice) / ethPrice;
      setState(() {
        _amountController.text = amount.toStringAsFixed(8);
      });
    }
    if (label == 'DOGE' && currentSymbol == 'SOL/USD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.SOL * solPrice) / dogePrice;
        setState(() {
          _searchController.text = user.SOL.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * solPrice) / dogePrice;
      setState(() {
        _amountController.text = amount.toStringAsFixed(8);
      });
    }
    if (label == 'SOL' && currentSymbol == 'SOL/USD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.SOL * solPrice) / solPrice;
        setState(() {
          _searchController.text = user.SOL.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * solPrice) / solPrice;
      setState(() {
        _amountController.text = amount.toStringAsFixed(8);
      });
    }

    if (label == 'BTC' && currentSymbol == 'BNB/USD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.BNB * bnbPrice) / btcPrice;
        setState(() {
          _searchController.text = user.BNB.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * bnbPrice) / btcPrice;
      setState(() {
        _amountController.text = amount.toStringAsFixed(8);
      });
    }

    if (label == 'BNB' && currentSymbol == 'BNB/USD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.BNB * bnbPrice) / bnbPrice;
        setState(() {
          _searchController.text = user.BNB.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * bnbPrice) / bnbPrice;
      setState(() {
        _amountController.text = amount.toStringAsFixed(8);
      });
    }
    if (label == 'ETH' && currentSymbol == 'BNB/USD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.BNB * bnbPrice) / ethPrice;
        setState(() {
          _searchController.text = user.BNB.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * bnbPrice) / ethPrice;
      setState(() {
        _amountController.text = amount.toStringAsFixed(8);
      });
    }
    if (label == 'DOGE' && currentSymbol == 'BNB/USD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.BNB * bnbPrice) / dogePrice;
        setState(() {
          _searchController.text = user.BNB.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * bnbPrice) / dogePrice;
      setState(() {
        _amountController.text = amount.toStringAsFixed(8);
      });
    }
    if (label == 'SOL' && currentSymbol == 'BNB/USD') {
      if (_searchController.text.isEmpty) {
        final amount = (user!.BNB * bnbPrice) / solPrice;
        setState(() {
          _searchController.text = user.BNB.toStringAsFixed(8);
          _amountController.text = amount.toStringAsFixed(8);
        });
      }

      final amount = (_parsesearchAmount() ?? 0 * bnbPrice) / solPrice;
      setState(() {
        _amountController.text = amount.toStringAsFixed(8);
      });
    }

    // final amount = user!.BTC * percentage;

    // _amountController.text = amount.toStringAsFixed(8);
  }
}
