import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/components/app_bar/app_bar.dart';
import 'package:news_app/components/app_card.dart';

import 'package:news_app/config/theme/theme.dart';
import 'package:news_app/utils/app_drawer.dart';

class ChannelScreen extends StatefulWidget {
  const ChannelScreen({Key? key}) : super(key: key);
  static const String route = '/kRouteChannel';

  @override
  _ChannelScreenState createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        appBar: CustomAppBar().primaryAppBarNoFilter(pageTitle: "Channel"),
        floatingActionButton: InkWell(
          onTap: () {
            _key.currentState!.openDrawer();
          },
          child: const Image(
            image: AppIcons.floating,
          ),
        ),
        drawer: const AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Top Picks",
                  style: AppStyle.regularText14
                      .copyWith(color: AppColors.darkBlueShade2)),
              SizedBox(
                height: 8.h,
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return AppCard(
                      cardText: "Interest #1",
                      onTap: () {},
                    );
                  }),
              SizedBox(
                height: 8.h,
              ),
              Text("Other Channels",
                  style: AppStyle.regularText14
                      .copyWith(color: AppColors.darkBlueShade2)),
              SizedBox(
                height: 8.h,
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return AppCard(
                      cardText: "Interest #1",
                      onTap: () {},
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
