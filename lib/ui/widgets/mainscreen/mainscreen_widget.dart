import 'package:flutter/material.dart';
import 'package:the_movie_db/domain/data_providers/session_data_providre.dart';
import 'package:the_movie_db/library/provider.dart';
import 'package:the_movie_db/ui/widgets/movieList/movie_list_model.dart';
import 'package:the_movie_db/ui/widgets/movieList/movie_list_widget.dart';
import 'package:the_movie_db/ui/widgets/news/news_widget.dart';
import 'package:the_movie_db/ui/widgets/tv_list/tv_list_model.dart';
import 'package:the_movie_db/ui/widgets/tv_list/tv_list_widget.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;
  final movieListModel = MovieListModel();
  final tvListModel = TVListModel();

  void onSelectTab(int index) {
    if (_selectedTab == index) return;

    setState(() {
      _selectedTab = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    movieListModel.setupLocale(context);
    tvListModel.setupLocale(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TMDB'),
        actions: [
          IconButton(
            onPressed: () => SessionDataProvider().setSessionId(null),
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          NotifierProvider(
            create: () => movieListModel,
            isManagingModel: false,
            child: const NewsWidget(),
          ),
          NotifierProvider(
            create: () => movieListModel,
            isManagingModel: false,
            child: const MovieListWidget(),
          ),
          NotifierProvider(
            create: () => tvListModel,
            isManagingModel: false,
            child: const TVListWidget(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv_rounded),
            label: 'Фильмы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection),
            label: 'Сериалы',
          ),
        ],
        onTap: onSelectTab,
      ),
    );
  }
}
