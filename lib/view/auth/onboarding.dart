import 'dart:async';

import 'package:crypto_beam/view/auth/login_step/signin.dart';
import 'package:crypto_beam/view/auth/login_step/signup.dart';
import 'package:crypto_beam/widgets/button.dart';
import 'package:crypto_beam/widgets/column_with_spacing.dart';
import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  static const routeName = '/onboarding';

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _mainScrollController = ScrollController();
  Timer? _horizontalScrollTimer;
  Timer? _verticalScrollTimer;
  Timer? _userInteractionTimer;
  bool _isUserScrolling = false;
  bool _isVerticalAutoScrolling = false;
  final double _horizontalScrollSpeed =
      40.0; // Pixels per second for horizontal
  final double _verticalScrollSpeed = 12.0; // Pixels per frame for vertical
  final Duration _scrollInterval = const Duration(milliseconds: 30);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startHorizontalAutoScroll();
      _startVerticalAutoScroll();
    });
  }

  @override
  void dispose() {
    _horizontalScrollTimer?.cancel();
    _verticalScrollTimer?.cancel();
    _userInteractionTimer?.cancel();
    _scrollController.dispose();
    _mainScrollController.dispose();
    super.dispose();
  }

  void _startHorizontalAutoScroll() {
    _horizontalScrollTimer?.cancel();
    _userInteractionTimer?.cancel();

    _startHorizontalAutoScroll();

    _horizontalScrollTimer = Timer.periodic(_scrollInterval, (timer) {
      if (!mounted || !_scrollController.hasClients || _isUserScrolling) {
        timer.cancel();
        return;
      }

      final maxExtent = _scrollController.position.maxScrollExtent;
      final currentPosition = _scrollController.position.pixels;
      final scrollIncrement =
          _horizontalScrollSpeed * _scrollInterval.inMilliseconds / 1000.0;
      final newPosition = currentPosition + scrollIncrement;

      if (newPosition >= maxExtent) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      } else {
        _scrollController.animateTo(
          newPosition,
          duration: _scrollInterval,
          curve: Curves.linear,
        );
      }
    });
  }

  void _startVerticalAutoScroll() {
    _verticalScrollTimer?.cancel();
    _userInteractionTimer?.cancel();
    _startVerticalAutoScroll();

    _verticalScrollTimer = Timer.periodic(_scrollInterval, (timer) {
      if (!mounted ||
          !_mainScrollController.hasClients ||
          _isUserScrolling ||
          !_isVerticalAutoScrolling) {
        timer.cancel();
        return;
      }

      final maxExtent = _mainScrollController.position.maxScrollExtent;
      final currentPosition = _mainScrollController.position.pixels;
      final newPosition = currentPosition + _verticalScrollSpeed;

      if (newPosition >= maxExtent) {
        _mainScrollController.animateTo(
          _mainScrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOut,
        );
      } else {
        _mainScrollController.animateTo(
          newPosition,
          duration: _scrollInterval,
          curve: Curves.linear,
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, outterBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                pinned: true,
                floating: true,
                stretch: true,
                snap: true,
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 80,
                          height: 50,
                          child: Image.asset("assets/splash.png"),
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      'CryptoBeam',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                actions: [
                  InkWell(
                    onTap: () => goto(context, Signup.routeName, null),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Sign Up',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: Theme.of(context).primaryColor,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: NotificationListener<ScrollNotification>(
          
          child: SingleChildScrollView(
            controller: _mainScrollController,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ColumnWithSpacing(
                spacing: 10,
                children: [
                  const SizedBox(height: 50),
                  _buildHeroSection(context),
                  const SizedBox(height: 15),
                  _buildInterchainSection(context),
                  const SizedBox(height: 40),
                  _buildTradingCards(context),
                  const SizedBox(height: 20),
                  _buildFeatureCards(context),
                  const SizedBox(height: 40),
                  _buildWeb3Section(context),
                  const SizedBox(height: 30),
                  _buildSecuritySection(context),
                  const SizedBox(height: 30),
                  _buildEarnSection(context),
                  const SizedBox(height: 30),
                  _buildSwapSection(context),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 606,
            height: 500,
            child: SvgPicture.asset("assets/images/rewards.svg"),
          ),
        ),
        ColumnWithSpacing(
          spacing: 25,
          children: [
            Text(
              'Trade Beyond Limits with CryptoBeam',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              'Unleash Crypto Freedom: Limitless, Trustworthy, and Sign-Up Free.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white54),
            ),
            CustomButton(
              color: Theme.of(context).primaryColor,
              name: 'Start Trading',
              onTap: () => goto(context, Signin.routeName, null),
            ),
            _buildRatingRow(context),
            const SizedBox(height: 10),
            _buildStatsRow(context),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Excellent',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.white30),
        ),
        Text(
          '  4.7 out of 5',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.white),
        ),
        const SizedBox(width: 12),
        Icon(Icons.star, color: Colors.green.shade400),
        const SizedBox(width: 4),
        Text(
          'Trustpilot',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatCard(context, '\$12.46B+', '24h Trading Volume'),
        _buildStatCard(context, '2600+', 'Cryptocurrencies'),
        _buildStatCard(context, '150%', 'Simple Earn APR'),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label) {
    return ColumnWithSpacing(
      spacing: 5,
      children: [
        Text(value, style: Theme.of(context).textTheme.headlineLarge),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.white30),
        ),
      ],
    );
  }

  Widget _buildInterchainSection(BuildContext context) {
    return ColumnWithSpacing(
      spacing: 8,
      children: [
        Text(
          'Experience Seamless Interchain Integration',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          'All your tokens, DeFi positions, NFT collections, and transaction history across all major networks.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.white30),
        ),
      ],
    );
  }

  Widget _buildTradingCards(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 8,
      children: [
        _buildTradingCard(
          context,
          title: 'Buy Sell',
          description:
              'The purpose of \'Buy\' and \'Sell\' is to facilitate trading by providing clear options for executing market transactions.',
          buttonText: 'Fast Trade',
          buttonColor: Colors.red.shade400,
          image: 'assets/images/sell.png',
        ),
        _buildTradingCard(
          context,
          title: 'Swap/DEX',
          description:
              'Swap/DEX allows users to trade cryptocurrencies directly without intermediaries, enabling fast and decentralized transactions.',
          buttonText: 'Confidence',
          buttonColor: Colors.blue.shade400,
          image: 'assets/images/transfer.png',
        ),
      ],
    );
  }

  Widget _buildTradingCard(BuildContext context,
      {required String title,
      required String description,
      required String buttonText,
      required Color buttonColor,
      required String image}) {
    return SizedBox(
      width: 450,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              ColumnWithSpacing(
                spacing: 10,
                children: [
                  Text(title, style: Theme.of(context).textTheme.headlineLarge),
                  SizedBox(
                    width: 230,
                    child: Text(
                      description,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white30),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(buttonColor),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                      ),
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 140,
                height: 200,
                child: Image.asset(image),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCards(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 8,
      children: [
        _buildFeatureCard(
          context,
          title: 'Fast Exchange',
          description:
              'Fast Exchange enables quick and seamless cryptocurrency trades, ensuring efficient transactions with minimal delays.',
          image: 'assets/images/10.svg',
        ),
        _buildFeatureCard(
          context,
          title: 'Instant Buy',
          description:
              'Instant Buy allows you to purchase cryptocurrencies quickly and effortlessly at real-time market prices.',
          image: 'assets/images/9.svg',
        ),
        _buildFeatureCard(
          context,
          title: 'Spot Trading',
          description:
              'Spot Trading enables you to buy and sell cryptocurrencies instantly at current market prices with full ownership of your assets.',
          image: 'assets/images/13.svg',
        ),
      ],
    );
  }

  Widget _buildFeatureCard(BuildContext context,
      {required String title,
      required String description,
      required String image}) {
    return SizedBox(
      width: 300,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ColumnWithSpacing(
            spacing: 10,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: SvgPicture.asset(image),
              ),
              Text(title, style: Theme.of(context).textTheme.headlineLarge),
              SizedBox(
                width: 230,
                child: Text(
                  description,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeb3Section(BuildContext context) {
    return ColumnWithSpacing(
      spacing: 8,
      children: [
        Text(
          'Elevate Your Web3 Experience',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          'All your tokens, DeFi positions, NFT collections, and transaction history across all major networks.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.white30),
        ),
        const SizedBox(height: 30),
        Wrap(
          direction: Axis.horizontal,
          spacing: 8,
          children: [
            _buildWalletCard(context),
            _buildCryptoCard(context),
          ],
        ),
      ],
    );
  }

  Widget _buildWalletCard(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ColumnWithSpacing(
            spacing: 10,
            children: [
              Text(
                'Multiple wallets support',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(
                width: 350,
                child: Text(
                  'Unlock the power of crypto with our developer-friendly platform, enabling your business to accept payments on popular networks.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 70),
              Text(
                'Available on',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white30),
              ),
              const SizedBox(height: 10),
              Wrap(
                direction: Axis.horizontal,
                spacing: 2,
                children: [
                  crypcard(context, "assets/images/metamask.svg", "metamask"),
                  crypcard(context, "assets/images/coinbase.svg", "coinbase"),
                  crypcard(
                      context, "assets/images/trustwallet.svg", "trustwallet"),
                  crypcard(context, "assets/images/phantom.svg", "phantom"),
                  crypcard(context, "assets/images/bitkeep.svg", "bitkeep"),
                  crypcard(context, "assets/images/passkeys.svg", "passkeys"),
                  crypcard(context, "assets/images/walletconnect.svg",
                      "walletconnect"),
                  crypcard(context, "assets/images/rainbow.svg", "rainbow"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCryptoCard(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ColumnWithSpacing(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              Text(
                'Multiple cryptocurrencies',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(
                width: 230,
                child: Text(
                  'Swap Bitcoin, Ethereum, all the most popular altcoins, and thousands of other crypto assets instantly.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white30),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              MouseRegion(
                // onExit: (_) => _resumeAutoScrollAfterDelay(),
                child: NotificationListener<ScrollNotification>(
                 
                  child: SizedBox(
                    height: 105,
                    child: ListView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      children: [
                        crypbox("assets/images/mnt.svg"),
                        crypbox("assets/images/stx.svg"),
                        crypbox("assets/images/near.svg"),
                        crypbox("assets/images/op.svg"),
                        crypbox("assets/images/eth.svg"),
                        crypbox("assets/images/sol.svg"),
                        crypbox("assets/images/wld.svg"),
                        crypbox("assets/images/avax.svg"),
                        crypbox("assets/images/tron.svg"),
                        crypbox("assets/images/arb.svg"),
                        crypbox("assets/images/apex.svg"),
                        crypbox("assets/images/kas.svg"),
                        crypbox("assets/images/bnb.svg"),
                      ],
                    ),
                  ),
                ),
              ),
              MouseRegion(
                child: NotificationListener<ScrollNotification>(
                  
                  child: SizedBox(
                    height: 105,
                    child: ListView(
                      reverse: true,
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      children: [
                        crypbox("assets/images/avax.svg"),
                        crypbox("assets/images/tron.svg"),
                        crypbox("assets/images/arb.svg"),
                        crypbox("assets/images/apex.svg"),
                        crypbox("assets/images/kas.svg"),
                        crypbox("assets/images/bnb.svg"),
                        crypbox("assets/images/mnt.svg"),
                        crypbox("assets/images/stx.svg"),
                        crypbox("assets/images/near.svg"),
                        crypbox("assets/images/wld.svg"),
                        crypbox("assets/images/op.svg"),
                        crypbox("assets/images/eth.svg"),
                        crypbox("assets/images/sol.svg"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    return ColumnWithSpacing(
      spacing: 8,
      children: [
        Text(
          'Secure and private',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Text(
          'Explore More Possibilities',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          'Discover the future with our web3 products. Experience new level of digital era.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.white30),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Wrap(
          children: [
            _buildBlockchainCard(context),
            _buildFeatureRows(context),
          ],
        ),
      ],
    );
  }

  Widget _buildBlockchainCard(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: SvgPicture.asset("assets/images/blockchain.svg"),
              ),
              const SizedBox(height: 20),
              Text(
                '31 Blockchains',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 380,
                child: Text(
                  'Swaps supports 13 available and 18 on-demand blockchain integrations.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white30),
                ),
              ),
              SizedBox(
                width: 440,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Text(
                          'Trusted by industry leaders',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 10),
                        MouseRegion(
                          child: NotificationListener<ScrollNotification>(
                           
                            child: SizedBox(
                              height: 105,
                              child: ListView(
                                controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  crypbox("assets/images/sandbox.svg"),
                                  crypbox("assets/images/sudobox.svg"),
                                  crypbox("assets/images/tradingview.svg"),
                                  crypbox("assets/images/babyc.svg"),
                                  crypbox("assets/images/opensea.svg"),
                                  crypbox("assets/images/rarible.svg"),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Divider(color: Colors.white, height: 1),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Rated',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white30),
                            ),
                            Text(
                              '  4.7 out of 5',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              height: 14,
                              color: Colors.red,
                              child: Text(
                                '486 reviews',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                            Text(
                              ' on ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white30),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.star_rate_rounded,
                                color: Colors.orange),
                            const SizedBox(width: 4),
                            Text(
                              'Trustpilot',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRows(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          _buildFeatureRow(
              context,
              'Low Transaction Fees',
              'Instant Buy allows you to purchase cryptocurrencies quickly and effortlessly at real-time market prices.',
              'assets/images/lowfees.svg'),
          _buildFeatureRow(
              context,
              'Up to 50x leverage.',
              'Trade with up to 50x leverage, amplifying your potential gains while managing risk effectively.',
              'assets/images/up50.svg'),
          _buildFeatureRow(
              context,
              'Transparent.',
              'Trade with up to 50x leverage, amplifying your potential gains while managing risk effectively.',
              'assets/images/trans.svg'),
          _buildFeatureRow(
              context,
              'Ultra speed.',
              'Execute trades instantly with ultra-fast transaction speeds and low latency.',
              'assets/images/ultra.svg'),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(
      BuildContext context, String title, String description, String image) {
    return SizedBox(
      width: 450,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              height: 70,
              child: SvgPicture.asset(image),
            ),
            Column(
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  child: Text(
                    description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white30),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarnSection(BuildContext context) {
    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              'CryptoBeam Earn.',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 10),
            Text(
              'Earn rewards effortlessly with high-yield opportunities and secure investments.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwapSection(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 8,
      children: [
        SizedBox(
          width: 500,
          height: 500,
          child: Image.asset("assets/images/crypt02.png"),
        ),
        SizedBox(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                SizedBox(
                  width: 430,
                  child: Text(
                    'Instant swap with cashback',
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 450,
                  child: Text(
                    'Instant swaps with cashback—trade seamlessly and earn rewards on every exchange. Enjoy fast, secure transactions with competitive rates while getting extra value on your trades. Swap assets effortlessly and maximize your returns with every transaction.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white30),
                  ),
                ),
                const SizedBox(height: 12),
                _buildCheckRow(
                    context, 'Buy, sell, and store different cryptocurrencies'),
                const SizedBox(height: 8),
                _buildCheckRow(context,
                    'Powerful tools, designed for the advanced trader'),
                const SizedBox(height: 8),
                _buildCheckRow(context, 'Deposit crypto easily from exchanges'),
                const SizedBox(height: 12),
                CustomButton(
                  color: Theme.of(context).primaryColor,
                  name: 'Start Trading',
                  onTap: () => goto(context, Signup.routeName, null),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckRow(BuildContext context, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[600],
          ),
          child: Icon(
            Icons.check_circle,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }

  Widget crypcard(BuildContext context, String image, String name) {
    return SizedBox(
      width: 230,
      child: Card(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: SvgPicture.asset(image),
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget crypbox(String image) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: SizedBox(
        width: 100,
        height: 100,
        child: SvgPicture.asset(image),
      ),
    );
  }
}
