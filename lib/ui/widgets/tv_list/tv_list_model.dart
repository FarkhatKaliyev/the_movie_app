import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/entity/popular_tv_response.dart';
import 'package:the_movie_db/entity/tv.dart';
import 'package:the_movie_db/ui/navigation/main_navigation.dart';

class TVListModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _tvs = <TV>[];
  late int _currentPage;
  late int _totalPage;
  late DateFormat _dateFormat;
  var _isLoadingInProgress = false;
  String _locale = '';
  String? _searchQuery;
  Timer? searchDebounce;

  List<TV> get tvs => List.unmodifiable(_tvs);

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);
    await _resetList();
  }

  Future<void> _resetList() async {
    _currentPage = 0;
    _totalPage = 1;
    _tvs.clear();
    await _loadNextPage();
  }

  Future<PopularTVResponse> _loadMovies(int nextPage, String locale) async {
    final query = _searchQuery;
    if (query == null) {
      return await _apiClient.popularTV(nextPage, _locale);
    } else {
      return await _apiClient.searchTV(nextPage, locale, query);
    }
  }

  Future<void> _loadNextPage() async {
    if (_isLoadingInProgress || _currentPage >= _totalPage) return;
    _isLoadingInProgress = true;
    final nextPage = _currentPage + 1;
    try {
      final tvResponse = await _loadMovies(nextPage, _locale);
      _tvs.addAll(tvResponse.tvs);
      _currentPage = tvResponse.page;
      _totalPage = tvResponse.totalPages;
      _isLoadingInProgress = false;
      notifyListeners();
    } catch (e) {
      _isLoadingInProgress = false;
    }
  }

  void onTVTap(BuildContext context, int index) {
    final id = _tvs[index].id;
    Navigator.of(context).pushNamed(
      MainNavigationRoutesName.movieDetails,
      arguments: id,
    );
  }

  Future<void> searchMovie(String text) async {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      final searchQuery = text.isNotEmpty ? text : null;
      if (_searchQuery == searchQuery) return;
      _searchQuery = searchQuery;
      await _resetList();
    });
  }

  void showTVAtIndex(int index) {
    if (index < _tvs.length - 1) return;
    _loadNextPage();
  }
}
