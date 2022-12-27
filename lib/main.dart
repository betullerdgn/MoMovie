import 'package:flutter/material.dart';
import 'package:mo_movie/utils/text.dart';
import 'package:mo_movie/widgets/lateset.dart';
import 'package:mo_movie/widgets/nowplaying.dart';
import 'package:mo_movie/widgets/toprated.dart';
import 'package:mo_movie/widgets/trending.dart';
import 'package:mo_movie/widgets/tv.dart';
import 'package:mo_movie/widgets/upcoming.dart';
import 'package:tmdb_api/tmdb_api.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, primaryColor: Colors.green),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List trendingmovies = [];
  List topratedmovies = [];
  List tv = [];
  List nowplaying = [];
  List upcoming = [];
  //List latest = [];
  final String apikey = "4e16a9c9580245c7a7ebb9b086dfeaae";
  final String readaccesstoken =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0ZTE2YTljOTU4MDI0NWM3YTdlYmI5YjA4NmRmZWFhZSIsInN1YiI6IjYzYTIzMjA5ZDhlMjI1MGU4YjM5M2MzNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.1zyvDmUxsI_DEiRk8-mOhgtEacyDCDPeRHtcxTEtCoo";

  @override
  void initState() {
    loadmovies();
    super.initState();
  }

  loadmovies() async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(apikey, readaccesstoken),
        logConfig: ConfigLogger(showLogs: true, showErrorLogs: true));
    Map trendingresults = await tmdbWithCustomLogs.v3.trending.getTrending();
    Map topratedresults = await tmdbWithCustomLogs.v3.movies.getTopRated();
    Map tvresults = await tmdbWithCustomLogs.v3.tv.getPopular();
    Map nowplayingresults = await tmdbWithCustomLogs.v3.movies.getNowPlaying();
    //Map latestresults = await tmdbWithCustomLogs.v3.movies.getLatest();
    Map upcomingresults = await tmdbWithCustomLogs.v3.movies.getUpcoming();

    print(tv);
    setState(() {
      trendingmovies = trendingresults["results"];
      topratedmovies = topratedresults["results"];
      tv = tvresults["results"];
      nowplaying = nowplayingresults["results"];
      //latest = latestresults["results"];
      upcoming = upcomingresults["results"];
    });
    //print(latest);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: modified_text(
          text: 'MoMovie Recommender 🎬 ',
          color: Colors.white,
          size: 28.0,
        ),
      ),
      body: ListView(children: [
        Card(
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            height: 300,
            width: 400,
            child: Image(
              image: AssetImage("images/banner.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
        TopRated(toprated: topratedmovies),
        TV(tv: tv),
        TrendingMovies(trending: trendingmovies),
        NowPlayingMovies(nowplaying: nowplaying),
        //Latest(latest: latest),
        UpComing(upcoming: upcoming),
      ]),
    );
  }
}
