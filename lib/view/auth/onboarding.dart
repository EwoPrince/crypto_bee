import 'dart:async';

import 'package:crypto_bee/view/auth/login_step/signin.dart';
import 'package:crypto_bee/view/auth/login_step/signup.dart';
import 'package:crypto_bee/widgets/button.dart';
import 'package:crypto_bee/x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  static const routeName = '/onboarding';

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  late ScrollController _scrollController;
  late ScrollController _sscrollController;
  late ScrollController _xscrollController;
  Timer? _scrollTimer; // Timer for continuous scrolling
  Timer? _userInteractionTimer; // Timer to resume after user interaction
  bool _isUserScrolling = false; // Flag to track user interaction
  final double _scrollSpeed = 40.0; // Pixels per second
  final Duration _scrollInterval =
      const Duration(milliseconds: 30); // How often to update scroll position
  final Duration _userScrollPauseDuration =
      const Duration(seconds: 3); // How long to wait after user interaction
  final Duration _restartDelay = Duration(milliseconds: 500);
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _sscrollController = ScrollController();
    _xscrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _startAutoScrollTimer();
      }
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _userInteractionTimer?.cancel();
    _scrollController.dispose();
    _sscrollController.dispose();
    _xscrollController.dispose();
    super.dispose();
  }

  void _startAutoScrollTimer() {
    _scrollTimer?.cancel();
    _userInteractionTimer?.cancel();
    if (!mounted || !_scrollController.hasClients) {
      Future.delayed(_restartDelay, () {
        if (mounted) _startAutoScrollTimer();
      });
      return;
    }

    Future.delayed(_restartDelay, () {
      if (!mounted || _isUserScrolling) return;

      _scrollTimer = Timer.periodic(_scrollInterval, (timer) {
        if (!mounted || !_scrollController.hasClients || _isUserScrolling) {
          timer.cancel();
          return;
        }

        double maxExtent = _scrollController.position.maxScrollExtent;
        double currentPosition = _scrollController.position.pixels;
        double scrollAmount =
            (_scrollSpeed * _scrollInterval.inMilliseconds / 1000.0);
        double newPosition = currentPosition + scrollAmount;

        if (newPosition >= maxExtent) {
          _scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
          );
          _sscrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
          );
          _xscrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
          );
        } else {
          _scrollController.jumpTo(newPosition);
          _sscrollController.jumpTo(newPosition);
          _xscrollController.jumpTo(newPosition);
        }
      });
    });
  }

  void _pauseAutoScroll() {
    _scrollTimer?.cancel();
    _userInteractionTimer?.cancel();
    _isUserScrolling = true;
  }

  void _resumeAutoScrollAfterDelay() {
    _isUserScrolling = false;
    _userInteractionTimer?.cancel();
    _userInteractionTimer = Timer(_userScrollPauseDuration, () {
      if (mounted && !_isUserScrolling) {
        _startAutoScrollTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                alignment: Alignment.center,
                                width: 50,
                                height: 50,
                                child: Image.asset("assets/splash.png"),
                              ),
                            ),
                          ),
                          SizedBox(width: 2),
                          Text(
                            'CryptoBee',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          goto(context, Signup.routeName, null);
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Sign Up',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            Icon(Icons.person_2_outlined),
                            SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        alignment: Alignment.center,
                        width: 550,
                        height: 550,
                        child: SvgPicture.asset("assets/images/rewards.svg"),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: 30),
                        Text(
                          'Trade Beyond Limits with CryptoBee',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Unleash Crypto Freedom: Limitless, Trustworthy, and Sign-Up Free.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 30),
                        button(context, 'Start Trading', () {
                          goto(context, Signin.routeName, null);
                        }),
                        SizedBox(height: 30),
                        Row(
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
                            SizedBox(width: 12),
                            Icon(
                              Icons.star,
                              color: Colors.green.shade400,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Trustpilot',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  '\$12.46B+',
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '24h Trading Volume',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.white30),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '2600+',
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Cryptocurrencies',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.white30),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '150%',
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Simple Earn APR',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.white30),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Text(
                  'The seamless interchain experience',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(height: 10),
                Text(
                  'All your tokens, DeFi positions, NFT collections, and transaction history across all major networks.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white30),
                ),
                SizedBox(height: 40),
                Wrap(
                  direction: Axis.horizontal,
                  spacing: 8,
                  children: [
                    SizedBox(
                      width: 420,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Buy Sell',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge,
                                  ),
                                  SizedBox(height: 10),
                                  SizedBox(
                                    width: 240,
                                    child: Text(
                                      'The purpose of \'Buy\' and \'Sell\' is to facilitate trading by providing clear options for executing market transactions.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: const Color.fromRGBO(
                                                  255, 255, 255, 0.302)),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 150,
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Fast Trade',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                        ),
                                      ),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                  Colors.red.shade400),
                                          shape: WidgetStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)))),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                              Container(
                                alignment: Alignment.center,
                                width: 140,
                                height: 200,
                                child: Image.asset("assets/images/sell.png"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 420,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Swap/DEX',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge,
                                  ),
                                  SizedBox(height: 10),
                                  SizedBox(
                                    width: 240,
                                    child: Text(
                                      'Swap/DEX allows users to trade cryptocurrencies directly without intermediaries, enabling fast and decentralized transactions.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: const Color.fromRGBO(
                                                  255, 255, 255, 0.302)),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 220,
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Start with confidence',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                        ),
                                      ),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                  Colors.blue.shade400),
                                          shape: WidgetStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)))),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                              Container(
                                alignment: Alignment.center,
                                width: 140,
                                height: 200,
                                child:
                                    Image.asset("assets/images/transfer.png"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Wrap(
                  direction: Axis.horizontal,
                  spacing: 8,
                  children: [
                    SizedBox(
                      width: 300,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 100,
                                height: 100,
                                child: SvgPicture.asset("assets/images/10.svg"),
                              ),
                              Text(
                                'Fast Exchange',
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: 240,
                                child: Text(
                                  'Fast Exchange enables quick and seamless cryptocurrency trades, ensuring efficient transactions with minimal delays.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: const Color.fromRGBO(
                                              255, 255, 255, 0.302)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 100,
                                height: 100,
                                child: SvgPicture.asset("assets/images/9.svg"),
                              ),
                              Text(
                                'Instant Buy',
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: 240,
                                child: Text(
                                  'Instant Buy allows you to purchase cryptocurrencies quickly and effortlessly at real-time market prices.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: const Color.fromRGBO(
                                              255, 255, 255, 0.302)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 100,
                                height: 100,
                                child: SvgPicture.asset("assets/images/13.svg"),
                              ),
                              Text(
                                'Spot Trading',
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: 240,
                                child: Text(
                                  'Spot Trading enables you to buy and sell cryptocurrencies instantly at current market prices with full ownership of your assets.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: const Color.fromRGBO(
                                              255, 255, 255, 0.302)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Text(
                  'Elevate your Web3 experience',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(height: 10),
                Text(
                  'All your tokens, DeFi positions, NFT collections, and transaction history across all major networks.',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: const Color.fromRGBO(255, 255, 255, 0.302)),
                ),
                SizedBox(height: 30),
                Wrap(
                  direction: Axis.horizontal,
                  spacing: 8,
                  children: [
                    SizedBox(
                      width: 600,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              Text(
                                'Multiple wallets support',
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: 540,
                                child: Text(
                                  'Unlock the power of crypto with our developer-friendly platform, enabling your business to accept payments on popular networks.',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 70),
                              Text(
                                'Available on',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 0.302)),
                              ),
                              SizedBox(height: 10),
                              Wrap(
                                direction: Axis.horizontal,
                                spacing: 2,
                                children: [
                                  crypcard(
                                    context,
                                    "assets/images/metamask.svg",
                                    "metamask",
                                  ),
                                  crypcard(
                                    context,
                                    "assets/images/coinbase.svg",
                                    "coinbase",
                                  ),
                                  crypcard(
                                    context,
                                    "assets/images/trustwallet.svg",
                                    "trustwallet",
                                  ),
                                  crypcard(
                                    context,
                                    "assets/images/phantom.svg",
                                    "phantom",
                                  ),
                                  crypcard(
                                    context,
                                    "assets/images/bitkeep.svg",
                                    "bitkeep",
                                  ),
                                  crypcard(
                                    context,
                                    "assets/images/passkeys.svg",
                                    "passkeys",
                                  ),
                                  crypcard(
                                    context,
                                    "assets/images/walletconnect.svg",
                                    "walletconnect",
                                  ),
                                  crypcard(
                                    context,
                                    "assets/images/rainbow.svg",
                                    "rainbow",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 270,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              Text(
                                'Multiple wallets support',
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: 240,
                                child: Text(
                                  'Unlock the power of crypto with our developer-friendly platform, enabling your business to accept payments on popular networks.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: const Color.fromRGBO(
                                              255, 255, 255, 0.302)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 40),
                              NotificationListener<ScrollNotification>(
                                onNotification:
                                    (ScrollNotification notification) {
                                  if (notification is ScrollStartNotification) {
                                    if (notification.dragDetails != null) {
                                      _pauseAutoScroll();
                                    }
                                  } else if (notification
                                      is ScrollEndNotification) {
                                    _resumeAutoScrollAfterDelay();
                                  }
                                  return false;
                                },
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
                              NotificationListener<ScrollNotification>(
                                onNotification:
                                    (ScrollNotification notification) {
                                  if (notification is ScrollStartNotification) {
                                    if (notification.dragDetails != null) {
                                      _pauseAutoScroll();
                                    }
                                  } else if (notification
                                      is ScrollEndNotification) {
                                    _resumeAutoScrollAfterDelay();
                                  }
                                  return false;
                                },
                                child: SizedBox(
                                  height: 105,
                                  child: ListView(
                                    reverse: true,
                                    controller: _sscrollController,
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  'Secure and private',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(height: 8),
                Text(
                  'You might also be interested in',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(height: 10),
                Text(
                  'Metaverse evolution of connectivity, compute & collaboration in the digital realm· An era of new possibilities·',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: const Color.fromRGBO(255, 255, 255, 0.302)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Wrap(
                  children: [
                    SizedBox(
                      width: 500,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 140,
                                height: 140,
                                child: SvgPicture.asset(
                                    "assets/images/blockchain.svg"),
                              ),
                              SizedBox(height: 20),
                              Text(
                                '31 Blockchains',
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: 440,
                                child: Text(
                                  'Swaps supports 13 available and 18 on-demand blockchain integrations.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: const Color.fromRGBO(
                                              255, 255, 255, 0.302)),
                                ),
                              ),
                              SizedBox(
                                width: 500,
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Trusted by industry leaders',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge,
                                        ),
                                        SizedBox(height: 10),
                                        NotificationListener<
                                            ScrollNotification>(
                                          onNotification: (ScrollNotification
                                              notification) {
                                            if (notification
                                                is ScrollStartNotification) {
                                              if (notification.dragDetails !=
                                                  null) {
                                                _pauseAutoScroll();
                                              }
                                            } else if (notification
                                                is ScrollEndNotification) {
                                              _resumeAutoScrollAfterDelay();
                                            }
                                            return false;
                                          },
                                          child: SizedBox(
                                            height: 105,
                                            child: ListView(
                                              controller: _scrollController,
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                crypbox(
                                                    "assets/images/sandbox.svg"),
                                                crypbox(
                                                    "assets/images/sudobox.svg"),
                                                crypbox(
                                                    "assets/images/tradingview.svg"),
                                                crypbox(
                                                    "assets/images/babyc.svg"),
                                                crypbox(
                                                    "assets/images/opensea.svg"),
                                                crypbox(
                                                    "assets/images/rarible.svg"),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 30),
                                        Divider(
                                          color: Colors.white,
                                          height: 1,
                                        ),
                                        SizedBox(height: 18),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Rated',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color: Colors.white30),
                                            ),
                                            Text(
                                              '  4.7 out of 5',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                            SizedBox(width: 5),
                                            Container(
                                              height: 14,
                                              color: Colors.red,
                                              child: SizedBox(
                                                  child: Text(
                                                '486 reviews',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: Colors.white),
                                              )),
                                            ),
                                            Text(
                                              ' on ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color: Colors.white30),
                                            ),
                                            SizedBox(width: 8),
                                            Icon(
                                              Icons.star,
                                              color: Colors.green.shade400,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              'Trustpilot',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: Colors.white),
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
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 450,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    child: SvgPicture.asset(
                                        "assets/images/lowfees.svg"),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Low fees.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge,
                                      ),
                                      SizedBox(height: 10),
                                      SizedBox(
                                        width: 300,
                                        child: Text(
                                          'Instant Buy allows you to purchase cryptocurrencies quickly and effortlessly at real-time market prices.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: const Color.fromRGBO(
                                                      255, 255, 255, 0.302)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 450,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    child: SvgPicture.asset(
                                        "assets/images/up50.svg"),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Up to 50x leverage.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge,
                                      ),
                                      SizedBox(height: 10),
                                      SizedBox(
                                        width: 300,
                                        child: Text(
                                          'Trade with up to 50x leverage, amplifying your potential gains while managing risk effectively.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: const Color.fromRGBO(
                                                      255, 255, 255, 0.302)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 450,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    child: SvgPicture.asset(
                                        "assets/images/trans.svg"),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Transparent.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge,
                                      ),
                                      SizedBox(height: 10),
                                      SizedBox(
                                        width: 300,
                                        child: Text(
                                          'Trade with up to 50x leverage, amplifying your potential gains while managing risk effectively.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: const Color.fromRGBO(
                                                      255, 255, 255, 0.302)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 450,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    child: SvgPicture.asset(
                                        "assets/images/ultra.svg"),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Ultra speed.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge,
                                      ),
                                      SizedBox(height: 10),
                                      SizedBox(
                                        width: 300,
                                        child: Text(
                                          'Execute trades instantly with ultra-fast transaction speeds and low latency.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: const Color.fromRGBO(
                                                      255, 255, 255, 0.302)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  height: 400,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(
                          'CryptoBee Earn.',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          child: Text(
                            'Earn rewards effortlessly with high-yield opportunities and secure investments.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: const Color.fromRGBO(
                                        255, 255, 255, 0.302)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Wrap(
                  direction: Axis.horizontal,
                  spacing: 8,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 500,
                      height: 500,
                      child: Image.asset("assets/images/crypt02.png"),
                    ),
                    Container(
                      width: 500,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 430,
                              child: Text(
                                'Instant swap with cashback',
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              width: 450,
                              child: Text(
                                'Instant swaps with cashback—trade seamlessly and earn rewards on every exchange. Enjoy fast, secure transactions with competitive rates while getting extra value on your trades. Swap assets effortlessly and maximize your returns with every transaction.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 0.302)),
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
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
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Buy, sell, and store differnt cryptocurrencies',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
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
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Powerful tools, designed for the advanced trader',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
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
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Deposit crypto easily from exchanges',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            button(context, 'Start Trading', () {
                              goto(context, Signup.routeName, null);
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget crypcard(
    BuildContext context,
    String image,
    String name,
  ) {
    return SizedBox(
      width: 230,
      child: Card(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                width: 40,
                height: 40,
                child: SvgPicture.asset(image),
              ),
              SizedBox(width: 10),
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
      padding: EdgeInsets.all(4),
      child: Container(
        alignment: Alignment.center,
        width: 100,
        height: 100,
        child: SvgPicture.asset(image),
      ),
    );
  }
}
