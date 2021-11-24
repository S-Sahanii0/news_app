import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/features/auth/bloc/auth_bloc.dart';
import 'package:news_app/features/categories/models/category_model.dart';
import 'package:news_app/features/categories/services/category_service.dart';

import '../../../components/buttons/form_button.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_styles.dart';

class ChooseCategoryScreen extends StatefulWidget {
  final CategoryService categoryService;
  const ChooseCategoryScreen({
    Key? key,
    required this.categoryService,
  }) : super(key: key);

  static const String route = '/kRouteChooseInterest';

  @override
  _ChooseCategoryScreenState createState() => _ChooseCategoryScreenState();
}

class _ChooseCategoryScreenState extends State<ChooseCategoryScreen> {
  List<CategoryModel> categoryList = [];
  late final AuthBloc _authBloc;
  final chosenList = <String>[];

  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
    widget.categoryService.getCategoryList().then((value) {
      setState(() => categoryList = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    var userData = (_authBloc.state as AuthSuccess).currentUser;

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
                width: 400,
                height: 400,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    runAlignment: WrapAlignment.center,
                    alignment: WrapAlignment.start,
                    direction: Axis.vertical,
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: [
                      ...List.generate(categoryList.length, (index) {
                        return ChooseInterestCard(
                            onTap: (val) {
                              print(val);
                              chosenList.add(val);
                            },
                            option: categoryList[index].categoryName);
                      }),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text("You can later add & delete your interests",
                    style: AppStyle.semiBoldText16
                        .copyWith(color: AppColors.yellowShade1)),
              ),
              FormButton(onTap: () {
                _authBloc.add(AddChosenCategoryEvent(
                    categoryList: chosenList, user: userData));
                Navigator.of(context).pop();
              })
            ],
          ),
        ),
      ),
    );
  }
}

class ChooseInterestCard extends StatefulWidget {
  final ValueSetter<String> onTap;
  final String option;
  const ChooseInterestCard(
      {Key? key, required this.onTap, required this.option})
      : super(key: key);

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
            widget.onTap(widget.option);
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
            widget.option,
            style:
                AppStyle.mediumText16.copyWith(color: AppColors.darkBlueShade1),
          ),
        )
      ],
    );
  }
}
