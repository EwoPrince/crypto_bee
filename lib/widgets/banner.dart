import 'package:flutter/material.dart';
import 'package:crypto_beam/widgets/button.dart';

class BannerLook extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String description;
  final String buttonText;

  const BannerLook({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const padding = EdgeInsets.all(10.0);
    const margin = EdgeInsets.symmetric(horizontal: 8);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Theme.of(context).primaryColor.withOpacity(0.2),
      ),
      width: size.width,
      margin: margin,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              height: size.width * 0.3,
              width: size.width,
            ),
          ),
          Padding(
            padding: padding,
            child:
                Text(title, style: Theme.of(context).textTheme.headlineLarge),
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Padding(
            padding: padding,
            child:
                Text(description, style: Theme.of(context).textTheme.bodyLarge),
          ),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              name: buttonText,
              onTap: () {},
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
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
