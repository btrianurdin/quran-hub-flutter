import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:quran/providers/surah_provider.dart';
import 'package:quran/utils/font_styles.dart';
import 'package:quran/utils/theme_color.dart';

class SurahDetailPage extends StatefulWidget {
  const SurahDetailPage({super.key, required this.surahId});

  final int surahId;

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.offset / 100 <= 1.0) {
        setState(() {
          _appBarOpacity = _scrollController.offset / 100;
        });
      }
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
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Text(
            'Quran App',
            style: FontStyles.appbar,
          ),
        ),
      ),
      body: Consumer(builder: (context, ref, child) {
        final surah = ref.watch(surahDetailProvider(widget.surahId));
        final verses = ref.watch(versesProvider(widget.surahId));

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 24, top: 24),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: SvgPicture.asset('assets/images/home-quran.svg',
                            width: 280),
                      ),
                      Opacity(
                        opacity: 0.9,
                        child: Container(
                          width: double.infinity,
                          height: 260,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.0, 1.0],
                              colors: [Color(0xFFDF98FA), Color(0xFF9055FF)],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        child: surah.when(
                          data: (data) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  data.latinName,
                                  style: FontStyles.title.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(data.meaning, style: FontStyles.regular),
                                const SizedBox(height: 16),
                                const Divider(endIndent: 40, indent: 40),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      data.relativationType.toUpperCase(),
                                      style: FontStyles.regular
                                          .copyWith(fontSize: 14),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 5,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${data.verseCount} Verses'.toUpperCase(),
                                      style: FontStyles.regular
                                          .copyWith(fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 32),
                                SvgPicture.asset('assets/images/opening.svg'),
                              ],
                            );
                          },
                          error: (error, stackTrace) {
                            return Center(
                              child: Text('Error: $error'),
                            );
                          },
                          loading: () {
                            return Container();
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: verses.when(
                    data: (data) {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: ThemeColor.surface,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 13,
                                ),
                                margin: const EdgeInsets.only(top: 24),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 27,
                                      height: 27,
                                      decoration: BoxDecoration(
                                        color: ThemeColor.primary,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Center(
                                        child: Text(
                                          data[index].numberOfVerse.toString(),
                                          style: FontStyles.regular.copyWith(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/share.svg',
                                          width: 24,
                                          theme: const SvgTheme(
                                            currentColor: ThemeColor.primary,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        SvgPicture.asset(
                                          'assets/icons/play.svg',
                                          width: 24,
                                          theme: const SvgTheme(
                                            currentColor: ThemeColor.primary,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        SvgPicture.asset(
                                          'assets/icons/bookmark.svg',
                                          width: 24,
                                          theme: const SvgTheme(
                                            currentColor: ThemeColor.primary,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      data[index].arabicText,
                                      style: FontStyles.arabic.copyWith(
                                        fontSize: 22,
                                        height: 2.5,
                                      ),
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      data[index].translationText,
                                      style: FontStyles.regular.copyWith(
                                        fontSize: 14,
                                        color: ThemeColor.textPrimary,
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.left,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            height: 1,
                            color: Color.fromRGBO(135, 137, 163, .40),
                          );
                        },
                        itemCount: data.length,
                      );
                    },
                    error: (error, stackTrace) {
                      return Center(
                        child: Text('Error: $error'),
                      );
                    },
                    loading: () {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        );
      }),
    );
  }
}
