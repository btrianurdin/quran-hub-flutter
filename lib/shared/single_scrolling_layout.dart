import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quran/utils/font_styles.dart';
import 'package:quran/utils/theme_color.dart';

class SingleScrollingLayout extends StatefulWidget {
  const SingleScrollingLayout({
    required this.slivers,
    required this.appBarTitle,
    this.scrollingAppBarTitle,
    this.actions,
    super.key,
  });

  final List<Widget> slivers;
  final String appBarTitle;
  final String? scrollingAppBarTitle;
  final List<Widget>? actions;

  @override
  State<SingleScrollingLayout> createState() => _SingleScrollingLayoutState();
}

class _SingleScrollingLayoutState extends State<SingleScrollingLayout> {
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0;
  bool isScrollingActive = false;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.offset / 100 <= 1.0) {
        setState(() {
          _appBarOpacity = _scrollController.offset / 100;
        });
      }

      setState(() {
        isScrollingActive = _scrollController.offset > 100;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.background,
      appBar: AppBar(
        primary: true,
        backgroundColor: ThemeColor.surface.withOpacity(_appBarOpacity),
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => {context.pop()},
          padding: EdgeInsets.zero,
          splashColor: ThemeColor.surface,
          highlightColor: ThemeColor.surface,
        ),
        actions: widget.actions,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Text(
            isScrollingActive
                ? widget.scrollingAppBarTitle ?? widget.appBarTitle
                : widget.appBarTitle,
            style: FontStyles.appbar,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: widget.slivers,
        ),
      ),
    );
  }
}
