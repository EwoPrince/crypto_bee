import 'package:flutter/material.dart';

// Utility functions from Explore, Market, and Wallet
String numToCrypto(double value) {
  return value.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
}

String numToCurrency(double value, String decimals) {
  return '\$${value.toStringAsFixed(int.parse(decimals))}';
}

class AssetTileWidget extends StatelessWidget {
  final String image;
  final String name;
  final String amount;
  final String asset;
  final double currentPrice;
  final String percentageChange;
  final bool top;
  final bool bottom;
  final Color? color;
  final VoidCallback? onTap;

  const AssetTileWidget({
    super.key,
    required this.image,
    required this.name,
    required this.amount,
    required this.asset,
    required this.currentPrice,
    required this.percentageChange,
    this.top = false,
    this.bottom = false,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final effectiveColor = color ?? Theme.of(context).cardColor;

    BorderRadius borderRadius = BorderRadius.zero;
    if (top && bottom) {
      borderRadius = BorderRadius.circular(30);
    } else if (top) {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      );
    } else if (bottom) {
      borderRadius = const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: effectiveColor,
          ),
          // width: size.width,
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildImage(context),
              SizedBox(
                width: size.width * 0.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.labelLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      numToCurrency(currentPrice, '2'),
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      percentageChange,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: percentageChange.startsWith('-') ? Colors.red : Colors.green,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: size.width * 0.25,
                child: Padding(
                  padding:  EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        asset,
                        style: Theme.of(context).textTheme.labelLarge,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        amount,
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Image.asset(
        image,
        height: 35,
        width: 35,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.broken_image,
          size: 35,
          color: Colors.grey,
        ),
      ),
    );
  }
}