import 'package:crypto_bee/widgets/banner.dart';


import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final List<BannerData> _banners = [
    BannerData(
      imageUrl: 'assets/images/bann1.png',
      title: 'Unlock 20% Returns in Just 2 Weeks with cryptobee!',
      subtitle:
          'Trade Bitcoin, Ethereum, Dogecoin, and Solana. Secure Your Investment, Maximize Your Profits.',
      description:
          'Join cryptobee today and experience the power of expert trading strategies with guaranteed 20% returns on your crypto assets in just two weeks. Whether you\'re a seasoned trader or new to the crypto world, our platform offers the perfect balance of security, transparency, and high returns.',
      buttonText: 'Don’t miss out—join the future of crypto trading with cryptobee!',
    ),
    BannerData(
      imageUrl: 'assets/images/bann2.jpg',
      title: 'Boost Your Crypto Portfolio by 20% in Two Weeks!',
      subtitle: 'Invest in Bitcoin, Ethereum, Dogecoin, and Solana with cryptobee.',
      description:
          'Why settle for average returns when you can grow your assets by 20% in just two weeks? With cryptobee, you’re in control—trade top cryptocurrencies on a secure platform designed for high-performance returns.',
      buttonText: 'Your crypto journey to financial freedom starts here!',
    ),
    BannerData(
      imageUrl: 'assets/images/bann3.jpeg',
      title: 'Maximize Your Crypto Gains: 20% Returns in 14 Days!',
      subtitle: 'Trade Safely and Profitably with cryptobee.',
      description:
          'Turn your crypto assets into profits with cryptobee! Earn a guaranteed 20% return on your investments in just two weeks. Our platform offers unparalleled security, transparency, and ease of use—making crypto trading accessible and rewarding for everyone.',
      buttonText: 'Experience the future of crypto trading with cryptobee!',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Explore'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        itemCount: _banners.length,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
        itemBuilder: (BuildContext context, int index) {
          final banner = _banners[index];
          return  BannerLook(
            key: ValueKey(banner.imageUrl),
           imageUrl: banner.imageUrl,
          title:  banner.title,
           subtitle:  banner.subtitle,
           description:  banner.description,
          buttonText:   banner.buttonText,
          );
        },
        ),
    );


  }
}

class BannerData {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String description;
  final String buttonText;

  BannerData({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.buttonText,
  });
}
