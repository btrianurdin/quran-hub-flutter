import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/models/bookmark_model.dart';
import 'package:quran/services/storage/hive_storage.dart';
import 'package:quran/services/storage/storage_service.dart';

class BookmarkNotifier extends StateNotifier<List<BookmarkModel>> {
  final LocalStorageService _storage;

  BookmarkNotifier(
    this._storage,
  ) : super([]) {
    getAll();
  }

  Future<List<BookmarkModel>> getAll() async {
    final data = await _storage.get('bookmarks');

    if (data != null) {
      final bookmarks = BookmarkModel.toList(json.decode(data));
      state = bookmarks;

      return state;
    }

    return [];
  }

  Future<void> add(BookmarkModel bookmark) async {
    final bookmarks = [...state, bookmark];
    await _storage.put('bookmarks', BookmarkModel.toJson(bookmarks));

    state = bookmarks;
  }

  Future<void> remove(int bookmarId) async {
    final bookmarks =
        state.where((bookmark) => bookmark.bookmarkId != bookmarId).toList();
    await _storage.put('bookmarks', BookmarkModel.toJson(bookmarks));

    state = bookmarks;
  }
}

final bookmarkRepositoryProvider =
    StateNotifierProvider<BookmarkNotifier, List<BookmarkModel>>((ref) {
  return BookmarkNotifier(ref.watch(hiveStorageProvider));
});

final bookmarkProvider = Provider.autoDispose((ref) {
  return ref.watch(bookmarkRepositoryProvider);
});

final selectBookmarkProvider =
    Provider.family.autoDispose<List<BookmarkModel>, int>((ref, surahId) {
  final bookmarks = ref.watch(bookmarkProvider);

  return bookmarks.where((element) => element.surahId == surahId).toList();
});

final bookmarkProviderGrouped = Provider.autoDispose((ref) {
  final bookmarks = ref.watch(bookmarkProvider);

  return bookmarks
      .fold<Map<String, List<BookmarkModel>>>(
        {},
        (previousValue, element) {
          final current = previousValue;
          if (!current.containsKey(element.surahName)) {
            current[element.surahName!] = [];
          }

          current[element.surahName]!.add(element);
          return current;
        },
      )
      .entries
      .toList();
});

final addBookmarkProvider =
    FutureProvider.autoDispose.family<void, BookmarkModel>(
  (ref, bookmark) async {
    final repository = ref.watch(bookmarkRepositoryProvider.notifier);

    return await repository.add(bookmark);
  },
);

final removeBookmarkProvider = FutureProvider.autoDispose.family<void, int>(
  (ref, bookmarkId) async {
    final repository = ref.watch(bookmarkRepositoryProvider.notifier);

    return await repository.remove(bookmarkId);
  },
);
