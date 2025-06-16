import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/provider/transcation_provider.dart';
import 'package:crypto_beam/services/transfer_service.dart';
import 'package:crypto_beam/states/verified_state.dart';
import 'package:crypto_beam/widgets/he3.dart';
import 'package:crypto_beam/widgets/stakeBS.dart';
import 'package:crypto_beam/widgets/trade_tile.dart';
import 'package:crypto_beam/widgets/transcation_tile.dart';
import 'package:crypto_beam/x.dart' as x;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class History extends ConsumerStatefulWidget {
  const History({super.key});

  @override
  ConsumerState<History> createState() => _HistoryState();
}

class _HistoryState extends ConsumerState<History>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final user = ref.read(authProvider).user;
    if (user == null) {
      x.showMessage(context, 'User not authenticated');
      return;
    }
    try {
      await ref.read(transactionProvider).fetchTransactions(user.uid);
      await ref.read(transactionProvider).fetchTrades(user.uid);
    } catch (e) {
      x.showMessage(context, 'Error loading data: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final prices = ref.watch(priceProvider);
    final pnl = ref.watch(transactionProvider).pnl;
    final apnl = ref.watch(transactionProvider).apnl;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to view history')),
      );
    }
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, outterBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  pinned: false,
                  floating: true,
                  stretch: true,
                  snap: true,
                  automaticallyImplyLeading: false,
                  expandedHeight: apnl != 0 ? 160 : 120,
                  flexibleSpace: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Balance:',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Text(
                            '${x.numToCurrency(TransferService.calculateUserDollarValue(user, prices), '2')}',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Equity:',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Text(
                            '${x.numToCurrency(TransferService.calculateUserDollarValue(user, prices) + apnl, '2')}',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                      
                      if (apnl != 0) SizedBox(height: 10),
                      if (apnl != 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Profit and Loss:',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Text(
                              '${x.numToCurrency(pnl , '2')}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: pnl.isNegative
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  bottom: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabs: const [
                      FittedBox(
                        child: Tab(
                          text: 'Overview',
                        ),
                      ),
                      FittedBox(
                        child: Tab(
                          text: 'Trade',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
              controller: _tabController,
              dragStartBehavior: DragStartBehavior.down,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildTransactionTab(context),
                _buildTradeTab(context),
              ])),
    );
  }

  Widget _buildTransactionTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(child: Consumer(builder: (context, ref, child) {
        final data = ref.watch(transactionProvider).transactions;
        if (data.isEmpty) {
          return _buildEmptyState(context);
        }

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, i) {
            var us = data[i];
            return TransactionTile(transaction: us);
          },
        );
      })),
    );
  }

  Widget _buildTradeTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(child: Consumer(builder: (context, ref, child) {
        final data = ref.watch(transactionProvider).trade;
        if (data.isEmpty) {
          return _buildEmptyState(context);
        }

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, i) {
            var us = data[i];
            return TradeTile(trade: us);
          },
        );
      })),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            hes3(context),
            _buildBuyReceiveButton(
                context), // Fixed typo: BuyRecieve -> BuyReceive
          ],
        ),
      ),
    );
  }

  Widget _buildBuyReceiveButton(BuildContext context) {
    final prices = ref.read(priceProvider);
    return TextButton(
      onPressed: () {
        final btcPrice = prices['XBTUSD'] ?? 0.0;
        if (btcPrice == 0.0) {
          x.showMessage(context, 'BTC price not available');
          return;
        }
        showStakeBottomSheet(context, 'XBTUSD', btcPrice, );
      },
      child: const Text('Start Trading'),
    );
  }
}
