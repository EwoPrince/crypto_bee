import 'package:crypto_bee/provider/auth_provider.dart';
import 'package:crypto_bee/provider/transcation_provider.dart';
import 'package:crypto_bee/widgets/he3.dart';
import 'package:crypto_bee/widgets/trade_tile.dart';
import 'package:crypto_bee/widgets/transcation_tile.dart';
import 'package:crypto_bee/x.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class History extends ConsumerStatefulWidget {
  const History({super.key});

  @override
  ConsumerState<History> createState() => _HistoryState();
}

class _HistoryState extends ConsumerState<History>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
    _startTimer();
  }

  Future<void> _loadData() async {
    final user = ref.read(authProvider).user;
    try {
      await ref.read(transcationProvider).fetchTranscations(user!.uid);
      await ref.read(transcationProvider).fetchTrades(user.uid);
    } catch (e) {}
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    var pnl = ref.watch(transcationProvider).pnl;
    var apnl = ref.watch(transcationProvider).apnl;
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
                  title: Column(
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
                            user!.dollar.toStringAsFixed(2),
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (apnl != 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Profit and Loss:',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Text(
                              pnl.toStringAsFixed(2),
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
        final data = ref.watch(transcationProvider).transactions;
        if (data.isEmpty) {
          return _buildEmptyState(context);
        }

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, i) {
            var us = data[i];
            return TranscationTile(transcation: us);
          },
        );
      })),
    );
  }

  Widget _buildTradeTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(child: Consumer(builder: (context, ref, child) {
        final data = ref.watch(transcationProvider).trade;
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          hes3(context),
          _buildBuyRecieveButton(context),
        ],
      ),
    );
  }

  Widget _buildBuyRecieveButton(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await Clipboard.setData(
            ClipboardData(text: "bc1q24tj0ytwyl3lnjd6hyqlh6n34m94hx5nqumrqk"));
        showMessage(context, 'Wallet Address copied successfully');
        if (!await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        )) {
          throw Exception('Could not launch $url');
        }
      },
      child: const Text('Start Trading'),
    );
  }
}
