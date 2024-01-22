import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran/modules/home/components/surah_tab.dart';
import 'package:quran/utils/font_styles.dart';
import 'package:quran/utils/theme_color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
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
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Assalamualaikum',
                        style: FontStyles.regular.copyWith(
                          fontSize: 18,
                          color: ThemeColor.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Abdul Aziz', style: FontStyles.title),
                      const SizedBox(height: 24),
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: ThemeColor.accent,
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [0.0, 1.0],
                                colors: [Color(0xFFDF98FA), Color(0xFF9055FF)],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Last Read',
                                  style: FontStyles.regular.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Al-Baqarah',
                                  style:
                                      FontStyles.title.copyWith(fontSize: 18),
                                ),
                                const SizedBox(height: 4),
                                Text('Ayah No. 1',
                                    style: FontStyles.regular
                                        .copyWith(fontSize: 14)),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: SvgPicture.asset(
                                'assets/images/home-quran.svg'),
                          )
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
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
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: TabBarView(
                children: [
                  const SurahTab(),
                  Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
