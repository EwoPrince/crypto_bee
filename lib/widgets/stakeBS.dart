import 'dart:async';
import 'package:crypto_bee/provider/auth_provider.dart';
import 'package:crypto_bee/services/transfer_service.dart';
import 'package:crypto_bee/widgets/button.dart';
import 'package:crypto_bee/widgets/textField.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Displays a modal bottom sheet for buying or selling a cryptocurrency.
void showStakeBottomSheet(
    BuildContext context, String symbol, double currentPrice, int index) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (BuildContext context) => BuySell(
      currentSymbol: symbol,
      index: index,
      currentPrice: currentPrice,
    ),
  );
}

class BuySell extends ConsumerStatefulWidget {
  final String currentSymbol;
  final int index;
  final double currentPrice;

  const BuySell({
    required this.currentSymbol,
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildModalContent();
  }

  Widget _buildModalContent() {
    return Column(
      children: [
        _buildSymbolDisplay(),
        const SizedBox(height: 8),
        _buildTabBar(),
        Expanded(child: _buildTabContent()),
      ],
    );
  }

  Widget _buildSymbolDisplay() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        _formatSymbol(widget.currentSymbol),
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _formatSymbol(String symbol) {
    switch (symbol) {
      case 'XBTUSD':
        return "BTCUSD";
      case 'XDGUSD':
        return "DOGEUSD";
      default:
        return symbol;
    }
  }

  Widget _buildTabBar() {
    return Container(
      height: 55,
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Theme.of(context).primaryColor,
        ),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        tabs: const [
          Tab(text: 'Buy'),
          Tab(text: 'Sell'),
        ],
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      ),
    );
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      dragStartBehavior: DragStartBehavior.down,
      physics: const BouncingScrollPhysics(),
      children: ['Buy', 'Sell'].map(_buildSingleTabContent).toList(),
    );
  }

  Widget _buildSingleTabContent(String action) {
    final user = ref.watch(authProvider).user;
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      children: [
        _buildOrderInfo('Open Limit Order'),
        _buildOrderInfo(
            'Current Price: \$ ${widget.currentPrice.toStringAsFixed(2)}'),
        const Divider(color: Colors.grey),
        _buildForm(action),
        _buildAvailableBalance(user?.dollar),
        _buildSubmitButton(action),
      ],
    );
  }

  Widget _buildOrderInfo(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Theme.of(context).primaryColor,
      ),
      child: Text(
        title,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildForm(String action) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildTextField('Margin', _amountController, action),
            _buildCheckbox('Take Profit', _showTp,
                (value) => setState(() => _showTp = value!)),
            if (_showTp)
              _buildTextField('Take Profit (USDT)', _tpController, action,
                  isPrice: true),
            _buildCheckbox('Stop Loss', _showSl,
                (value) => setState(() => _showSl = value!)),
            if (_showSl)
              _buildTextField('Stop Loss (USDT)', _slController, action,
                  isPrice: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String action,
      {bool isPrice = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: moneyTextField(
        label,
        controller,
        Theme.of(context).primaryColor,
        () => _validateInput(label, controller.text, action, isPrice),
      ),
    );
  }

  Function()? _validateInput(
      String label, String text, String action, bool isPrice) {
    if (text.isEmpty) return () => showMessage(context, '$label is required');
    final value = double.tryParse(text);
    if (value == null) return () => showMessage(context, 'Invalid $label');
    if (value == 0) return () => showMessage(context, "$label cannot be zero");
    if (isPrice) {
      return _validatePrice(label, value, action);
    }
    return null;
  }

  Function()? _validatePrice(String label, double price, String action) {
    if (action == 'Buy' && price <= widget.currentPrice) {
      return () => showMessage(context,
          "Price must be greater than the current price for buy orders");
    }
    if (action == 'Sell' && price >= widget.currentPrice) {
      return () => showMessage(
          context, "Price must be less than the current price for sell orders");
    }
    return null;
  }

  Widget _buildCheckbox(
      String label, bool value, void Function(bool?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(onPressed: () => onChanged(!value), child: Text(label)),
          Checkbox(
            value: value,
            onChanged: (newValue) {
              if (newValue != null) {
                setState(() => onChanged(newValue));
              }
            },
            side: const BorderSide(width: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableBalance(double? balance) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Available USDT'),
          Text('\$ ${balance?.toStringAsFixed(2) ?? '0.00'}',
              style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(String action) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : button(context, action, _onSubmit),
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await _placeOrder(action: _tabController.index == 0 ? 'Buy' : 'Sell');
        if (context.mounted) Navigator.pop(context);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _placeOrder({required String action}) async {
    final margin = double.parse(_amountController.text);
    final tp =
        _tpController.text.isNotEmpty ? double.parse(_tpController.text) : null;
    final sl =
        _slController.text.isNotEmpty ? double.parse(_slController.text) : null;
    final user = ref.read(authProvider).user;
    final bool isSell = action == 'Sell';

    // User's available balance
    final double? userBalance = user?.dollar;

    // Calculate leverage based on margin and current price of the asset
    final double leverage =
        widget.currentPrice > 0 ? (margin / widget.currentPrice) : 1.0;

    // Check if the user has enough balance for the margin
    if (userBalance == null || userBalance < margin) {
      showMessage(context, 'Insufficient Funds for Margin');
      return;
    }

    // The actual amount traded will be calculated in TransferService based on leverage
    await TransferService.initiateMarginTrade(
      context,
      user,
      tp,
      sl,
      margin,
      widget.currentSymbol,
      isSell,
      leverage,
    );
  }

  void showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Validation Error"),
        content: Text(message),
        actions: [
          TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }
}
