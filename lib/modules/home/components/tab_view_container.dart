import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quran/utils/font_styles.dart';
import 'package:quran/utils/theme_color.dart';

class TabViewContainer extends StatefulWidget {
  const TabViewContainer({
    required this.views,
    required this.adapterBox,
    super.key,
  });

  final List<Widget> views;
  final SliverToBoxAdapter adapterBox;

  @override
  State<TabViewContainer> createState() => _TabViewContainerState();
}

class _TabViewContainerState extends State<TabViewContainer> {
  bool isTabScroll = false;
  double appBarOpacity = 0.0;
  bool isTabBarPinnedBegin = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        isTabBarPinnedBegin = _scrollController.offset > 255;
        isTabScroll = _scrollController.offset > 200;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.background,
      appBar: AppBar(
        primary: true,
        backgroundColor: ThemeColor.surface.withOpacity(appBarOpacity),
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        elevation: 0.0,
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 3),
            child: IconButton(
              icon: const Icon(
                Icons.favorite_border,
                color: Colors.white,
              ),
              onPressed: () {
                context.push('/bookmarks');
              },
              splashColor: ThemeColor.surface,
              highlightColor: ThemeColor.surface,
            ),
          )
        ],
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Quran App',
            style: FontStyles.appbar,
          ),
        ),
      ),
      body: NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            if (notification.metrics.pixels / 100 <= 1 && !isTabScroll) {
              setState(() {
                appBarOpacity = notification.metrics.pixels / 100;
              });
            }
          }
          return true;
        },
        child: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              widget.adapterBox,
              SliverAppBar(
                backgroundColor: isTabBarPinnedBegin
                    ? ThemeColor.surface
                    : ThemeColor.background,
                surfaceTintColor: Colors.transparent,
                elevation: 0.0,
                pinned: true,
                forceElevated: innerBoxIsScrolled,
                automaticallyImplyLeading: false,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: Container(
                    color: isTabBarPinnedBegin
                        ? ThemeColor.surface
                        : ThemeColor.background,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: ThemeColor.secondary,
                      indicatorColor: ThemeColor.primary,
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerHeight: 3,
                      dividerColor: const Color.fromRGBO(135, 137, 163, .20),
                      splashFactory: NoSplash.splashFactory,
                      tabs: [
                        Tab(
                          child:
                              Text('Surah', style: FontStyles.regularNoColor),
                        ),
                        Tab(
                          child: Text('Juz', style: FontStyles.regularNoColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            body: TabBarView(children: widget.views),
          ),
        ),
      ),
    );
  }
}
