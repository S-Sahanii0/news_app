import 'package:flutter/material.dart';
import 'package:news_app/components/buttons/app_card.dart';
import 'package:news_app/config/app_bar/app_bar.dart';
import 'package:news_app/config/theme/theme.dart';

class ChannelScreen extends StatefulWidget {
  const ChannelScreen({Key? key}) : super(key: key);
  static const String route = '/kRouteChannel';

  @override
  _ChannelScreenState createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar().primaryAppBarNoFilter(pageTitle: "Channel"),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Top Picks",
                  style: AppStyle.regularText14
                      .copyWith(color: AppColors.darkBlueShade2)),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    bool isSaved = false;
                    return AppCard(
                      cardText: "Interest #1",
                      canBeSaved: true,
                      onTap: () {},
                      onTapheart: () {
                        setState(() {
                          isSaved = !isSaved;
                        });
                      },
                      isSaved: isSaved,
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
