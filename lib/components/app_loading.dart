import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:news_app/config/theme/theme.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 20,
        width: 100,
        child: LoadingIndicator(
          indicatorType: Indicator.ballPulse,
          colors: [
            AppColors.yellowShade1,
            AppColors.yellowShade2,
          ],
          strokeWidth: 2,
        ),
      ),
    );
  }
}
