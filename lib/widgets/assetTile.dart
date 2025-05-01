import 'package:flutter/material.dart';

class AssetTileWidget extends StatelessWidget {
  final String image;
  final String name;
  final String amount;
  final String asset;
  final String currentPrice;
  final bool top;
  final bool bottom;
  final Color color;

  const AssetTileWidget({
    Key? key,
    required this.image,
    required this.name,
    required this.amount,
    required this.asset,
    required this.currentPrice,
    this.top = false,
    this.bottom = false,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    BorderRadius? borderRadius;
    if (top) {
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
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: color,
        ),
        width: size.width,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              image,
              height: 35,
              width: 35,
            ),
            SizedBox(
              width: size.width * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Text(
                    currentPrice,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: true,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: size.width * 0.35,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    asset,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Text(
                    amount,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: true,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
