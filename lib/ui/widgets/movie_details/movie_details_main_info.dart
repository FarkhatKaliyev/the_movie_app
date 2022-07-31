import 'package:flutter/material.dart';
import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/entity/movie_details_credits.dart';
import 'package:the_movie_db/library/provider.dart';
import 'package:the_movie_db/ui/navigation/main_navigation.dart';
import 'package:the_movie_db/ui/widgets/movie_details/movie_details_model.dart';

import '../elements/radial_percent_widget.dart';

class MovieDetailsMainInfo extends StatelessWidget {
  const MovieDetailsMainInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _TopPosterWidget(),
        Padding(
          padding: EdgeInsets.all(30.0),
          child: _MovieNAmeWidget(),
        ),
        _ScoreWidget(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
          child: _SummeryWidget(),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: _OverviewWidget(),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: _DiscriptionWidget(),
        ),
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: _PeopleWidget(),
        ),
      ],
    );
  }
}

class _DiscriptionWidget extends StatelessWidget {
  const _DiscriptionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);

    return Text(
      model?.movieDetails?.overview ?? '',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class _OverviewWidget extends StatelessWidget {
  const _OverviewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Обзор',
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class _TopPosterWidget extends StatelessWidget {
  const _TopPosterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final backdropPath = model?.movieDetails?.backdropPath;
    final posterPath = model?.movieDetails?.posterPath;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          backdropPath != null
              ? Image.network(ApiClient.imageUrl(backdropPath))
              : const SizedBox.shrink(),
          Positioned(
            top: 20,
            left: 20,
            bottom: 20,
            child: posterPath != null
                ? Image.network(ApiClient.imageUrl(posterPath))
                : const SizedBox.shrink(),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              onPressed: () {},
              icon: Icon(model?.isFavorite == true
                  ? Icons.favorite
                  : Icons.favorite_outline),
            ),
          )
        ],
      ),
    );
  }
}

class _MovieNAmeWidget extends StatelessWidget {
  const _MovieNAmeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    var year = model?.movieDetails?.releaseDate?.year.toString();
    year = year != null ? ' ($year)' : '';
    return Center(
      child: RichText(
        maxLines: 3,
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: model?.movieDetails?.title ?? '',
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: year,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieDetails =
        NotifierProvider.watch<MovieDetailsModel>(context)?.movieDetails;
    var voteAverege = movieDetails?.voteAverage ?? 0;
    final video = movieDetails?.videos.results
        .where((video) => video.type == 'Trailer' && video.site == 'YouTube');
    final trailerKey = video?.isNotEmpty == true ? video?.first.key : null;
    voteAverege = voteAverege * 10;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          style:
              ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
          onPressed: () {},
          child: Row(
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: RadiantPecentWidget(
                  child: Text(
                    '${voteAverege.toStringAsFixed(0)}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                  percent: voteAverege / 100,
                  fillcolor: const Color.fromARGB(255, 10, 23, 25),
                  freeColor: const Color.fromARGB(255, 25, 37, 31),
                  lineColor: const Color.fromARGB(255, 37, 203, 103),
                  lineWidth: 3,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Пользавательский счет',
              ),
            ],
          ),
        ),
        Container(width: 1, height: 15, color: Colors.grey),
        trailerKey != null
            ? TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                onPressed: () => Navigator.of(context).pushNamed(
                    MainNavigationRoutesName.movieTrailerWidget,
                    arguments: trailerKey),
                child: Row(
                  children: const [
                    Icon(Icons.play_arrow),
                    Text('Воспроизвести трейлер'),
                  ],
                ))
            : const SizedBox.shrink(),
      ],
    );
  }
}

class _SummeryWidget extends StatelessWidget {
  const _SummeryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    if (model == null) return const SizedBox.shrink();

    var texts = <String>[];

    final releaseDate = model.movieDetails?.releaseDate;
    if (releaseDate != null) {
      texts.add(model.stringFromDate(releaseDate));
    }

    final productionCountries = model.movieDetails?.productionCountries;
    if (productionCountries != null && productionCountries.isNotEmpty) {
      var countries = <String>[];

      for (var country in productionCountries) {
        countries.add(country.iso);
      }
      texts.add('(${countries.join(', ')})');
    }

    final runtime = model.movieDetails?.runtime ?? 0;
    // final milliseconds = runtime * 60000;
    // final runtimeDate =
    //     DateTime.fromMillisecondsSinceEpoch(milliseconds).toUtc();
    // texts.add(DateFormat.Hm().format(runtimeDate));
    final duration = Duration(minutes: runtime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    texts.add('${hours}h ${minutes}m');

    final genres = model.movieDetails?.genres;
    if (genres != null && genres.isNotEmpty) {
      var genresNames = <String>[];
      for (var genr in genres) {
        genresNames.add(genr.name);
      }
      texts.add(genresNames.join(', '));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Text(
        texts.join(' '),
        maxLines: 3,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _PeopleWidget extends StatelessWidget {
  const _PeopleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    var crew = model?.movieDetails?.credits.crew;
    if (crew == null || crew.isEmpty) return const SizedBox.shrink();
    crew = crew.length > 4 ? crew.sublist(0, 4) : crew;
    var crewChunks = <List<Employee>>[];
    int chunkSize = 2;
    for (var i = 0; i < crew.length; i += chunkSize) {
      crewChunks.add(
        crew.sublist(
            i, i + chunkSize > crew.length ? crew.length : i + chunkSize),
      );
    }
    return Column(
        children: crewChunks
            .map(
              (chunk) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _PeopleWidgetRow(employes: chunk),
              ),
            )
            .toList());
  }
}

class _PeopleWidgetRow extends StatelessWidget {
  final List<Employee> employes;
  const _PeopleWidgetRow({
    Key? key,
    required this.employes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        children: employes
            .map((employee) => _PeopleWidgetRowItem(employee: employee))
            .toList());
  }
}

class _PeopleWidgetRowItem extends StatelessWidget {
  final Employee employee;
  const _PeopleWidgetRowItem({
    Key? key,
    required this.employee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const nameStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w700,
    );
    const jobStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(employee.name, style: nameStyle),
          Text(employee.job, style: jobStyle),
        ],
      ),
    );
  }
}
