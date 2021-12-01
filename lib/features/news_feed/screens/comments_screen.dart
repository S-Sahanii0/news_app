import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/features/auth/bloc/auth_bloc.dart';
import 'package:news_app/features/auth/models/user_model.dart';
import 'package:news_app/features/news_feed/bloc/news_bloc.dart';
import 'package:news_app/features/news_feed/model/comment_model.dart';
import 'package:share_plus/share_plus.dart';

import '../../../components/app_bar/app_bar.dart';
import '../../../components/app_form_field.dart';
import '../model/news_model.dart';
import '../widgets/comment_card.dart';
import '../widgets/news_detail_card.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key, required this.newsModel}) : super(key: key);
  static final _formKey = GlobalKey<FormBuilderState>();

  static const String route = "/kRouteComment";
  final News newsModel;

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late final AuthBloc _authBloc;
  late final UserModel userData;
  late final NewsBloc _newsBloc;
  late final User _currentUser;

  @override
  void initState() {
    _currentUser = FirebaseAuth.instance.currentUser!;
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _newsBloc = BlocProvider.of<NewsBloc>(context);
    userData = (_authBloc.state as AuthSuccess).currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar()
            .appBarWithBack(context: context, pageTitle: "Comments"),
        body: SingleChildScrollView(
          child: BlocBuilder<NewsBloc, NewsState>(
            bloc: BlocProvider.of<NewsBloc>(context),
            builder: (context, state) {
              final currentNews = (state as NewsLoadingSuccess)
                  .newsList
                  .where((element) => element.id == widget.newsModel.id)
                  .first;
              return Column(
                children: [
                  NewsDetailCard(
                    channelName: widget.newsModel.channel.channel,
                    newsDescription: widget.newsModel.content,
                    newsTime: widget.newsModel.date,
                    numberOfLikes: currentNews.likes.toString(),
                    numberOfComments: currentNews.comment!.length.toString(),
                    commentTapped: true,
                    isHeart:
                        userData.history!.any((e) => currentNews.id == e.id),
                    isBookmark:
                        userData.bookmarks!.any((e) => currentNews.id == e.id),
                    onTapHeart: () {
                      if (userData.history!.contains(widget.newsModel)) {
                        _authBloc.add(RemoveFromHistory(
                            newsModel: widget.newsModel, user: userData));
                      } else {
                        _authBloc.add(AddToHistory(
                            newsModel: widget.newsModel, user: userData));
                        _newsBloc.add(LikeNewsEvent(
                            likedNews: currentNews.copyWith(
                                likes: currentNews.likes! + 1)));
                      }
                    },
                    onTapComment: () {},
                    onTapBookmark: () {
                      if (userData.bookmarks!.contains(currentNews)) {
                        _authBloc.add(RemoveBookMarkEvent(
                            newsToBookmark: currentNews, user: userData));
                      } else {
                        _authBloc.add(AddToBookMarkEvent(
                            newsToBookmark: currentNews, user: userData));
                      }
                    },
                    onTapShare: () {
                      Share.share('check out this ${widget.newsModel.url}');
                    },
                    onTapMenu: () {},
                    channelImage: widget.newsModel.channel.channelImage,
                    imageUrl: widget.newsModel.newsImage,
                  ),
                  Divider(
                    thickness: 2.h,
                  ),
                  FormBuilder(
                    key: CommentScreen._formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      child: AppFormField(
                          fieldTitle: "",
                          fieldName: "comment",
                          hintText: "Add your comment",
                          suffixIcon: Icons.send,
                          validators: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: ("You cant comment empty"))
                          ]),
                          onTap: () {
                            if (CommentScreen._formKey.currentState!
                                .validate()) {
                              CommentScreen._formKey.currentState!.save();
                              final result =
                                  CommentScreen._formKey.currentState!.value;
                              BlocProvider.of<NewsBloc>(context).add(
                                  AddCommentEvent(
                                      comment: CommentModel.fromMap({
                                        "userId": _currentUser.uid,
                                        "comment": result['comment']
                                      }),
                                      news: widget.newsModel.copyWith(
                                          comment: widget.newsModel.comment!
                                            ..add(
                                              CommentModel.fromMap({
                                                "userId": _currentUser.uid,
                                                "comment": result['comment']
                                              }),
                                            ))));
                              CommentScreen._formKey.currentState!.reset();
                            }
                          },
                          textInputAction: TextInputAction.done),
                    ),
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.newsModel.comment!.length,
                      itemBuilder: (context, index) {
                        final comment =
                            widget.newsModel.comment!.reversed.toList();
                        return CommentCard(
                            commentor: comment[index].userId,
                            noOfLikes: 1,
                            commentText: comment[index].comment,
                            onTapHeart: () {});
                      }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
