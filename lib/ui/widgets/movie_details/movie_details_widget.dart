import 'package:flutter/material.dart';
import 'package:the_movie_db/library/provider.dart';
import 'package:the_movie_db/ui/widgets/movie_details/movie_details_main_info.dart';
import 'package:the_movie_db/ui/widgets/movie_details/movie_details_model.dart';
import 'package:the_movie_db/ui/widgets/movie_details/movie_details_screen_cast_widget.dart';

class MovieDetailsWidget extends StatefulWidget {
  const MovieDetailsWidget({Key? key}) : super(key: key);

  @override
  State<MovieDetailsWidget> createState() => _MovieDetailsWidgetState();
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    NotifierProvider.read<MovieDetailsModel>(context)?.setupLocale(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _TitleWidget(),
      ),
      body: const ColoredBox(
        color: Color.fromRGBO(24, 23, 27, 1.0),
        child: _BodyWidget(),
      ),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    return Text(model?.movieDetails?.title ?? 'Загрузка...');
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final movieDetails = model?.movieDetails;
    if (movieDetails == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      children: const [
        MovieDetailsMainInfo(),
        SizedBox(height: 30),
        MovieDeatailsScreenCastWidget(),
      ],
    );
  }
}
