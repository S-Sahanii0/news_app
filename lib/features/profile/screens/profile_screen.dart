import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../components/app_drawer.dart';
import '../../../components/app_floating_button.dart';
import '../../../config/theme/theme.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../news_feed/screens/my_feed.dart';
import '../tabs/bookmark_tab.dart';
import '../tabs/history.dart';
import '../tabs/settings_tab.dart';
import '../widgets/profile_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const String route = '/kRouteProfile';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TabController? _tabController;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  late String uid;
  late final AuthBloc _authBloc;
  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    var userData = (_authBloc.state as AuthSuccess).currentUser;
    return SafeArea(
      child: Scaffold(
        key: _key,
        floatingActionButton: AppFloatingActionButton(
          scaffoldKey: _key,
        ),
        drawer: const AppDrawer(),
        body: Stack(
          children: [
            DefaultTabController(
              length: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProfileCard(
                      username: '${userData.username}',
                      profileBio: "Get only what you want"),
                  ColoredBox(
                    color: AppColors.appWhite,
                    child: TabBar(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      overlayColor:
                          MaterialStateProperty.all(AppColors.appWhite),
                      controller: _tabController,
                      indicatorColor: Colors.transparent,
                      unselectedLabelColor: AppColors.greyShade1,
                      labelColor: AppColors.darkBlueShade1,
                      tabs: [
                        Text("Settings", style: AppStyle.mediumText14),
                        Text("Bookmarks", style: AppStyle.mediumText14),
                        Text("History", style: AppStyle.mediumText14),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        BlocProvider.value(
                          value: BlocProvider.of<AuthBloc>(context),
                          child: Settings(user: userData),
                        ),
                        BookmarkTab(
                          bookmarkList: userData.bookmarks ?? [],
                        ),
                        History(
                          historyList: userData.history ?? [],
                        ),
                      ],
                    ),
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
