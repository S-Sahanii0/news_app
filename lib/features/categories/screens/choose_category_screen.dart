import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../components/buttons/form_button.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_styles.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/models/user_model.dart';
import '../../news_feed/screens/my_feed.dart';

class ChooseCategoryScreen extends StatefulWidget {
  const ChooseCategoryScreen({
    Key? key,
  }) : super(key: key);

  static const String route = '/kRouteChooseInterest';

  @override
  _ChooseCategoryScreenState createState() => _ChooseCategoryScreenState();
}

class _ChooseCategoryScreenState extends State<ChooseCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text("What interests you more?",
                    style: AppStyle.mediumText16
                        .copyWith(color: AppColors.darkBlueShade1)),
              ),
              SizedBox(
                width: 290,
                height: 400,
                child: Wrap(
                  runAlignment: WrapAlignment.center,
                  alignment: WrapAlignment.start,
                  direction: Axis.vertical,
                  spacing: 30.0,
                  runSpacing: 20.0,
                  children: [
                    ...List.generate(12, (index) {
                      return const ChooseInterestCard();
                    })
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text("You can later add & delete your interests",
                    style: AppStyle.semiBoldText16
                        .copyWith(color: AppColors.yellowShade1)),
              ),
              FormButton(onTap: () {
                Navigator.of(context).pushReplacementNamed(MyFeedScreen.route);
              })
            ],
          ),
        ),
      ),
    );
  }
}

class ChooseInterestCard extends StatefulWidget {
  const ChooseInterestCard({Key? key}) : super(key: key);

  @override
  State<ChooseInterestCard> createState() => _ChooseInterestCardState();
}

class _ChooseInterestCardState extends State<ChooseInterestCard> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isSelected = !isSelected;
            });
          },
          child: SizedBox(
            height: 30.h,
            width: 30.w,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: AppColors.yellowShade4),
              child: Center(
                child: SizedBox(
                  height: 15.h,
                  width: 15.h,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: isSelected
                            ? AppColors.greyShade3
                            : AppColors.yellowShade4),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Option",
            style:
                AppStyle.mediumText16.copyWith(color: AppColors.darkBlueShade1),
          ),
        )
      ],
    );
  }
}
