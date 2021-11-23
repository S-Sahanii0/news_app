import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/features/news_feed/bloc/news_bloc.dart';
import 'package:news_app/features/news_feed/bloc/tts/tts_cubit.dart';
import '../../../components/app_bar/app_bar.dart';
import '../../../config/theme/app_icons.dart';
import '../../../config/theme/theme.dart';
import '../model/news_model.dart';
import '../widgets/news_detail_bottom_sheet.dart';

class SingleNewsScreen extends StatefulWidget {
  const SingleNewsScreen(
      {Key? key, required this.newsList, required this.currentNewsIndex})
      : super(key: key);
  final List<News> newsList;
  final int currentNewsIndex;
  static const String route = '/kRouteSingleNewsScreen';

  @override
  _SingleNewsScreenState createState() => _SingleNewsScreenState();
}

class _SingleNewsScreenState extends State<SingleNewsScreen> {
  late final TtsCubit _ttsCubit;

  @override
  void initState() {
    _ttsCubit = context.read<TtsCubit>()..init(widget.currentNewsIndex);
    super.initState();
  }

  @override
  void dispose() {
    _ttsCubit.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<TtsCubit, TtsState>(
        builder: (context, state) {
          return PageView.builder(
              controller: state.pageController,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final _news = widget.newsList[index];
                final _shouldPlay = _ttsCubit.state.shouldAutoPlay;
                if (_shouldPlay) _ttsCubit.handlePlay(_news.content);
                return Scaffold(
                  appBar: CustomAppBar()
                      .appBarWithBack(context: context, pageTitle: ""),
                  bottomSheet: NewsDetailBottomSheet(
                    onPlay: (isPlaying) => isPlaying
                        ? _ttsCubit.stop()
                        : _ttsCubit.handlePlay(_news.content),
                    shouldPlay: _shouldPlay,
                  ),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.yellowShade2,
                              radius: 15,
                              child: Image(
                                fit: BoxFit.contain,
                                image: NetworkImage(_news.channel.channelImage),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                _news.channel.channel,
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
                              image: DecorationImage(
                                image: NetworkImage(_news.newsImage),
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
                            _news.title,
                            style: AppStyle.regularText14
                                .copyWith(color: AppColors.darkBlueShade3),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                        Text(
                          _news.content,
                          style: AppStyle.regularText18
                              .copyWith(color: AppColors.darkBlueShade1),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              InkWell(
                                // todo add cofig for iOS
                                onTap: () => launch(_news.url),
                                child: Text(
                                  "Read more",
                                  style: AppStyle.semiBoldText12.copyWith(
                                      color: AppColors.darkBlueShade2),
                                ),
                              ),
                              Spacer(
                                flex: 6,
                              ),
                              Text(
                                _news.date,
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
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
                );
              });
        },
      ),
    );
  }
}
