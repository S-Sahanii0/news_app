import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/components/app_bar/app_bar.dart';
import 'package:news_app/config/theme/app_icons.dart';
import 'package:news_app/config/theme/theme.dart';
import 'package:news_app/features/news_feed/widgets/news_detail_bottom_sheet.dart';

class SingleNewsScreen extends StatefulWidget {
  const SingleNewsScreen({Key? key}) : super(key: key);
  static const String route = '/kRouteSingleNewsScreen';

  @override
  _SingleNewsScreenState createState() => _SingleNewsScreenState();
}

class _SingleNewsScreenState extends State<SingleNewsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar().appBarWithBack(context: context, pageTitle: ""),
        bottomSheet: const NewsDetailBottomSheet(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.yellowShade2,
                    radius: 15,
                    backgroundImage:
                        ExactAssetImage("assets/images/dummy_channel.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Channel",
                      style: AppStyle.regularText14
                          .copyWith(color: AppColors.darkBlueShade2),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                height: 150,
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AppIcons.dummy,
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      width: 2,
                      color: AppColors.yellowShade4,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Lorem lorem lorem lorem lorem lorem lorem lorem Lorem",
                  style: AppStyle.regularText14
                      .copyWith(color: AppColors.darkBlueShade3),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
              Text(
                "Lorem lorem lorem lorem lorem lorem lorem lorem Lorem Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem IpsumLorem Ipsum Lorem Ipsum Lorem Ipsum",
                style: AppStyle.regularText18
                    .copyWith(color: AppColors.darkBlueShade1),
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Text(
                      "Read more",
                      style: AppStyle.semiBoldText12
                          .copyWith(color: AppColors.darkBlueShade2),
                    ),
                    Spacer(
                      flex: 6,
                    ),
                    Text(
                      "04/05/2021",
                      style: AppStyle.regularText12
                          .copyWith(color: AppColors.darkBlueShade2),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 2,
              ),
              Flexible(
                flex: 4,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Image(image: AppIcons.heartTapped),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "100",
                        style: AppStyle.regularText12
                            .copyWith(color: AppColors.greyShade2),
                      ),
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    InkWell(
                        onTap: () {},
                        child: const Image(image: AppIcons.comment)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "100",
                        style: AppStyle.regularText12
                            .copyWith(color: AppColors.greyShade2),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
