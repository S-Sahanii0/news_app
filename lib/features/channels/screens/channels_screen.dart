import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:news_app/features/auth/bloc/auth_bloc.dart';
import 'package:news_app/features/categories/bloc/category_bloc.dart';
import 'package:news_app/features/categories/screens/news_by_category.dart';
import 'package:news_app/features/channels/bloc/channel_bloc.dart';
import 'package:news_app/features/channels/screens/news_by_channel.dart';
import 'package:news_app/features/news_feed/screens/my_feed.dart';
import '../../../components/app_bar/app_bar.dart';
import '../../../components/app_card.dart';
import '../../../components/app_drawer.dart';
import '../../../components/app_floating_button.dart';

import '../../../config/theme/theme.dart';

class ChannelScreen extends StatefulWidget {
  const ChannelScreen({Key? key}) : super(key: key);
  static const String route = '/kRouteChannel';

  @override
  _ChannelScreenState createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  late final AuthBloc _authBloc;

  late String uid;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChannelBloc>(context).add(GetChannelEvent());
    _authBloc = BlocProvider.of<AuthBloc>(context);
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var userData = (_authBloc.state as AuthSuccess).currentUser;

    return SafeArea(
      child: Scaffold(
        key: _key,
        appBar: CustomAppBar()
            .primaryAppBarNoFilter(pageTitle: "Category", context: context),
        floatingActionButton: AppFloatingActionButton(
          scaffoldKey: _key,
        ),
        drawer: const AppDrawer(),
        body: SingleChildScrollView(
          child: BlocBuilder<ChannelBloc, ChannelState>(
            builder: (context, state) {
              if (state is ChannelInitial || state is ChannelLoading) {
                return LoadingIndicator(indicatorType: Indicator.ballBeat);
              }

              if (state is ChannelLoadSuccess) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("My Interests",
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
                            return AppCard.hasHeart(
                              cardText: "Interest #1",
                              onTap: () {},
                              isSaved: false,
                              onTapheart: () {},
                            );
                          }),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text("Other Topics",
                          style: AppStyle.regularText14
                              .copyWith(color: AppColors.darkBlueShade2)),
                      SizedBox(
                        height: 8.h,
                      ),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.otherChannels.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    NewsByChannelScreen.route,
                                    arguments: [
                                      userData,
                                      state.otherChannels[index].channel
                                    ]);
                              },
                              child: AppCard.hasHeart(
                                cardText: state.otherChannels[index].channel,
                                onTap: () {},
                                isSaved: false,
                                onTapheart: () {},
                              ),
                            );
                          })
                    ],
                  ),
                );
              } else {
                return const Center(child: Text("Please try again later"));
              }
            },
          ),
        ),
      ),
    );
  }
}
