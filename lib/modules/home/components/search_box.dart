import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:quran/providers/search_provider.dart';
import 'package:quran/utils/debounce.dart';
import 'package:quran/utils/font_styles.dart';
import 'package:quran/utils/theme_color.dart';

class SearchBox extends ConsumerStatefulWidget {
  const SearchBox({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchBoxState();
}

class _SearchBoxState extends ConsumerState<SearchBox> {
  late SearchController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = SearchController();
    final debounce = Debouncer(milliseconds: 500);

    _searchController.addListener(() {
      debounce.run(() {
        ref
            .read(searchTextSurahProvider.notifier)
            .update((_) => _searchController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: _searchController,
      viewBackgroundColor: ThemeColor.background,
      dividerColor: const Color.fromRGBO(135, 137, 163, .40),
      headerTextStyle: FontStyles.regular.copyWith(
        fontSize: 14,
      ),
      viewElevation: 0,
      viewTrailing: [
        IconButton(
          splashColor: ThemeColor.surface,
          highlightColor: ThemeColor.surface,
          icon: const Icon(
            Icons.close,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            _searchController.clear();
          },
        ),
      ],
      viewLeading: IconButton(
        splashColor: ThemeColor.surface,
        highlightColor: ThemeColor.surface,
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () {
          _searchController.closeView('');
        },
      ),
      builder: (context, controller) {
        return TextField(
          onTap: () {
            controller.openView();
          },
          readOnly: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 35,
              minHeight: 18,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: ThemeColor.secondary,
            ),
            filled: true,
            fillColor: ThemeColor.surface,
            hintText: "Search surah",
            hintStyle: FontStyles.regular.copyWith(
              color: ThemeColor.secondary,
              fontSize: 12,
              height: 1.5,
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
          style: FontStyles.regular.copyWith(
            fontSize: 12,
            height: 1.5,
          ),
        );
      },
      viewBuilder: (suggestions) {
        return Consumer(
          builder: (context, ref, child) {
            final results = ref.watch(searchSurahProvider);

            return results.when(
              data: (data) {
                if (data.isEmpty && _searchController.text.isNotEmpty) {
                  return Container(
                    width: double.infinity,
                    height: 80,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Surah not found',
                      style: FontStyles.regular,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        height: 1,
                        color: Color.fromRGBO(135, 137, 163, .40),
                      ),
                    );
                  },
                  itemCount: data.length,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, index) {
                    final current = data[index];

                    return InkWell(
                      overlayColor:
                          MaterialStateProperty.all(ThemeColor.surface),
                      splashFactory: InkSplash.splashFactory,
                      onTap: () => {
                        context.push(
                          '/surah/${current.id}',
                          extra: {'from': 'search', 'surahName': current.latinName},
                        )
                      },
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        margin: const EdgeInsets.all(0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                SvgPicture.asset(
                                    'assets/images/verse-number.svg'),
                                Positioned(
                                  top: 8,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Text(
                                      current.id.toString(),
                                      style: FontStyles.regular.copyWith(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  current.latinName,
                                  style: FontStyles.regular
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      current.relativationType.toUpperCase(),
                                      style: FontStyles.regular.copyWith(
                                        fontSize: 12,
                                        color: ThemeColor.secondary,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '•',
                                      style: FontStyles.regular.copyWith(
                                        fontSize: 12,
                                        color: ThemeColor.secondary,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${current.verseCount} Verses'
                                          .toUpperCase(),
                                      style: FontStyles.regular.copyWith(
                                        fontSize: 12,
                                        color: ThemeColor.secondary,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const Spacer(),
                            Text(
                              current.arabicName,
                              style: FontStyles.arabic.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: ThemeColor.primary,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              error: (error, stackTrace) {
                return Center(
                  child: Text('Error', style: FontStyles.regular),
                );
              },
              loading: () {
                return ListView(
                  children: const [
                    SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
      suggestionsBuilder: (context, controller) => [],
    );
  }
}

// final results = ref.watch(searchSurahProvider(controller.text));

//         return results.when(
//           data: (data) {
//             print('search data ${data.length}');

//             return List.generate(data.length, (int index) {
//               return InkWell(
//                 overlayColor: MaterialStateProperty.all(ThemeColor.surface),
//                 splashFactory: InkSplash.splashFactory,
//                 onTap: () => {},
//                 child: Container(
//                   padding: const EdgeInsets.all(18),
//                   margin: const EdgeInsets.all(0),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Stack(
//                         children: [
//                           SvgPicture.asset('assets/images/verse-number.svg'),
//                           Positioned(
//                             top: 8,
//                             left: 0,
//                             right: 0,
//                             child: Center(
//                               child: Text(
//                                 data[index].id.toString(),
//                                 style: FontStyles.regular.copyWith(
//                                   color: Colors.white,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(width: 16),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             data[index].latinName,
//                             style: FontStyles.regular
//                                 .copyWith(fontWeight: FontWeight.w500),
//                           ),
//                           const SizedBox(height: 4),
//                           Row(
//                             children: [
//                               Text(
//                                 data[index].relativationType.toUpperCase(),
//                                 style: FontStyles.regular.copyWith(
//                                   fontSize: 12,
//                                   color: ThemeColor.secondary,
//                                 ),
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 '•',
//                                 style: FontStyles.regular.copyWith(
//                                   fontSize: 12,
//                                   color: ThemeColor.secondary,
//                                 ),
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 '${data[index].verseCount} Verses'
//                                     .toUpperCase(),
//                                 style: FontStyles.regular.copyWith(
//                                   fontSize: 12,
//                                   color: ThemeColor.secondary,
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                       const Spacer(),
//                       Text(
//                         data[index].arabicName,
//                         style: FontStyles.arabic.copyWith(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: ThemeColor.primary,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             });
//           },
//           error: (error, stackTrace) {
//             return Iterable.empty();
//           },
//           loading: () {
//             return Iterable.empty();
//           },
//         );