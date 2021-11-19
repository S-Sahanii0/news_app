import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../components/app_bar/app_bar.dart';
import '../../../config/theme/theme.dart';

class SearchScreen extends StatelessWidget {
  static const String route = "/kRouteSearch";
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar().appBarSearch(context: context),
      body: const Center(
        child: Image(
          image: AppIcons.searchResult,
        ),
      ),
    );
  }
}
