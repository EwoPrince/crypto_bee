import 'package:crypto_bee/widgets/banner.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Explore'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          children: [
            BannerLook(
              context,
              'assets/images/bann1.png',
              'Unlock 20% Returns in Just 2 Weeks with cryptobee!',
              'Trade Bitcoin, Ethereum, Dogecoin, and Solana. Secure Your Investment, Maximize Your Profits.',
              'Join cryptobee today and experience the power of expert trading strategies with guaranteed 20% returns on your crypto assets in just two weeks. Whether you\'re a seasoned trader or new to the crypto world, our platform offers the perfect balance of security, transparency, and high returns.',
              'Don’t miss out—join the future of crypto trading with cryptobee!',
            ),
            SizedBox(height: 20),
            BannerLook(
                context,
                'assets/images/bann2.jpg',
                'Boost Your Crypto Portfolio by 20% in Two Weeks!',
                'Invest in Bitcoin, Ethereum, Dogecoin, and Solana with cryptobee.',
                'Why settle for average returns when you can grow your assets by 20% in just two weeks? With cryptobee, you’re in control—trade top cryptocurrencies on a secure platform designed for high-performance returns.',
                'Your crypto journey to financial freedom starts here!'),
            SizedBox(height: 20),
            BannerLook(
              context,
              'assets/images/bann3.jpeg',
              'Maximize Your Crypto Gains: 20% Returns in 14 Days!',
              'Trade Safely and Profitably with cryptobee.',
              'Turn your crypto assets into profits with cryptobee! Earn a guaranteed 20% return on your investments in just two weeks. Our platform offers unparalleled security, transparency, and ease of use—making crypto trading accessible and rewarding for everyone.',
              'Experience the future of crypto trading with cryptobee!',
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
