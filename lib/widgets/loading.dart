import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RepaintBoundary(
        child: LoadingAnimationWidget.threeRotatingDots(
          color: Theme.of(context).primaryColor,
          size: 45,
        ),
      ),
    );
  }
}
