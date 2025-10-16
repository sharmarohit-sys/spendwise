import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/core/constants/dimensions.dart';
import 'package:spendwise/core/constants/image_constant.dart';
import 'package:spendwise/features/splash/controller/splash_screen_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(splashScreenControllerProvider.notifier).checkLoginStatus(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImageConstant.logo, height: 100),
            // Icon(
            //   Icons.savings_rounded,
            //   size: Dimensions.padding * 30,
            //   color: colorScheme.primary,
            // ),
            // const CircularProgressIndicator(),
            const Text(
              "Spendwise",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
