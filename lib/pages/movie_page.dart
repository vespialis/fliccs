import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fliccs/model/justwatch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class MoviePage extends StatefulWidget {
  final Movie _movie;
  final JustWatch _justWatch;

  const MoviePage(this._movie, this._justWatch, {Key key}) : super(key: key);

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> with TickerProviderStateMixin {
  Future<Movie> _getMovieDetails;
  String posterUrl;

  Widget _buildProviderLogo(var providerUrl){
    ScreenUtil.init(width: 1080, height: 2280, allowFontScaling: false);
    var blackBackgroundLogos = ['chili'];
    bool forceBlackBackground = false;
    String imageUri;

    if (providerUrl.host.toString().contains('chili')){
      imageUri = 'assets/chili.png';
    } else if (providerUrl.host.toString().contains('google')){
      imageUri = 'assets/google.png';
    } else if (providerUrl.host.toString().contains('hbogo')){
      imageUri = 'assets/hbo_go.png';
    } else if (providerUrl.host.toString().contains('hbo')){
      imageUri = 'assets/hbo.png';
    } else if (providerUrl.host.toString().contains('netflix')){
      imageUri = 'assets/netflix.png';
    } else if (providerUrl.host.toString().contains('prime')){
      imageUri = 'assets/prime_video.png';
    } else if (providerUrl.host.toString().contains('youtube')){
      imageUri = 'assets/youtube.png';
    } else if (providerUrl.host.toString().contains('itunes')){
      imageUri = 'assets/itunes.png';
    }

    for (String provider in blackBackgroundLogos){
      if (providerUrl.toString().contains(provider) || imageUri == null){
        forceBlackBackground = true;
        break;
      }
    }
    return Container(
      decoration: BoxDecoration(
        color: forceBlackBackground?Colors.black:Color(0xFFf1faee),
        borderRadius: BorderRadius.circular(8)
      ),
      child: (SizedBox(
        width: 90,
        height: 90,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: (imageUri != null)?Image.asset(imageUri, fit: BoxFit.contain):AutoSizeText(
              providerUrl.host.replaceAll('www.', ''),
              minFontSize: 0.0,
              maxLines: 1,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Color(0xFFf1faee),
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(0.0, ScreenUtil().setHeight(3.0)),
                    blurRadius: 0.0,
                    color: Color(0xFFff6b6b),
                  )
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

  Widget _buildProviderCard(var provider) {
    ScreenUtil.init(width: 1080, height: 2280, allowFontScaling: false);
    var providerUrl = Uri.parse(provider['urls']['standard_web']);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => _launchURL(providerUrl.toString()),
        child: Card(
          elevation: 5.0,
          color: Color(0xFF424242),
          child: SizedBox(
            width: ScreenUtil().setWidth(320),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: _buildProviderLogo(providerUrl),
                  ),
                  (provider['retail_price'] != null)
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: AutoSizeText(
                            provider['retail_price'].toStringAsFixed(2) +
                                ' ' +
                                provider['currency'],
                            style: TextStyle(color: Color(0xFFf1faee)),
                          ),
                        )
                      : Container(),
                  (provider['element_count'] != null)
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: AutoSizeText(
                            provider['element_count'].toString() +
                                ' ' +
                                'season(s)',
                            style: TextStyle(color: Color(0xFFf1faee)),
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AutoSizeText(
                      provider['presentation_type'].toString().toUpperCase(),
                      style: TextStyle(color: Colors.amber),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildProvidersList(List<dynamic> providers) {
    List<Widget> cards = List<Widget>();
    List<Widget> streaming = List<Widget>();
    List<Widget> buy = List<Widget>();
    List<Widget> rent = List<Widget>();
    List<Widget> free = List<Widget>();
    for (var provider in providers) {
      print(provider);
      if (provider['monetization_type'] == 'streaming')
        streaming.add(_buildProviderCard(provider));
      if (provider['monetization_type'] == 'flatrate')
        streaming.add(_buildProviderCard(provider));
      if (provider['monetization_type'] == 'buy')
        buy.add(_buildProviderCard(provider));
      if (provider['monetization_type'] == 'rent')
        rent.add(_buildProviderCard(provider));
      if (provider['monetization_type'] == 'free')
        free.add(_buildProviderCard(provider));
    }
    if (free.length > 0)
      cards.add(Container(
        decoration: BoxDecoration(color: Color(0xFF525252)),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          RotatedBox(
            quarterTurns: 3,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'free',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFf1faee),
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0.0, ScreenUtil().setHeight(4.0)),
                      blurRadius: 0.0,
                      color: Color(0xFFff6b6b),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Color(0xFF525252),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: free,
                ),
              ),
            ),
          )
        ]),
      ));
    if (streaming.length > 0)
      cards.add(Container(
        decoration: BoxDecoration(color: Color(0xFF525252)),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          RotatedBox(
            quarterTurns: 3,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'streaming',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFf1faee),
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0.0, ScreenUtil().setHeight(4.0)),
                      blurRadius: 0.0,
                      color: Color(0xFFff6b6b),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Color(0xFF525252),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: streaming,
                ),
              ),
            ),
          )
        ]),
      ));
    if (rent.length > 0)
      cards.add(Container(
        decoration: BoxDecoration(color: Color(0xFF525252)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          RotatedBox(
            quarterTurns: 3,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'rent',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFf1faee),
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0.0, ScreenUtil().setHeight(4.0)),
                      blurRadius: 0.0,
                      color: Color(0xFFff6b6b),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Color(0xFF525252)),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: rent,
                ),
              ),
            ),
          )
        ]),
      ));
    if (buy.length > 0)
      cards.add(Container(
        decoration: BoxDecoration(color: Color(0xFF525252)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          RotatedBox(
            quarterTurns: 3,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'buy',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFf1faee),
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0.0, ScreenUtil().setHeight(4.0)),
                      blurRadius: 0.0,
                      color: Color(0xFFff6b6b),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Color(0xFF525252)),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: buy,
                ),
              ),
            ),
          )
        ]),
      ));
    return cards;
  }

  Widget _buildAppBar(String text) {
    return PreferredSize(
        preferredSize: Size.fromHeight(ScreenUtil().setHeight(250)),
        child: AppBar(
            flexibleSpace: Image(
                image: AssetImage('assets/fliccs_searchbar.png'),
                fit: BoxFit.cover),
            automaticallyImplyLeading: false,
            title: Container(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Color(0xFFff6b6b)),
                        child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Icon(Icons.arrow_back,
                                color: Color(0xFFf1faee))),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SizedBox(
                          height: ScreenUtil().setHeight(150),
                          child: Center(
                            child: AutoSizeText(
                              text,
                              maxLines: 2,
                              minFontSize: 0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Color(0xFFf1faee),
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(
                                        0.0, ScreenUtil().setHeight(5.0)),
                                    blurRadius: 0.0,
                                    color: Color(0xFFff6b6b),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                    ],
                  ),
                ],
              ),
            )));
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void getPosterUrl(Movie movie) {
    if (posterUrl == null) {
      posterUrl = movie.getPosterUrl();
    }
  }

  @override
  void initState() {
    _getMovieDetails = widget._justWatch.getDetails(widget._movie).catchError(
        (onError) => _getMovieDetails = Future<Movie>.error(onError));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(width: 1080, height: 2280, allowFontScaling: false);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder<Movie>(
      future: _getMovieDetails,
      builder: (BuildContext context, AsyncSnapshot<Movie> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              appBar: _buildAppBar(widget._movie.name),
              body: SizedBox.expand(
                child: Container(
                    decoration: BoxDecoration(color: Color(0xFF424242)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                          'oops... something went wrong\nplease try again',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFFf1faee))),
                    )),
              ));
        } else if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        else {
          getPosterUrl(snapshot.data);
          return Scaffold(
            appBar: _buildAppBar(snapshot.data.name),
            body: Container(
              height: double.infinity,
              decoration: BoxDecoration(color: Color(0xFF424242)),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Card(
                        elevation: 8.0,
                        color: Color(0xFF525252),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        width: width * 0.25,
                                        child: Image(
                                            image: NetworkImage(posterUrl))),
                                  ),
                                  Text(
                                    snapshot.data.contentType,
                                    style: TextStyle(
                                        color: Color(0xFFf1faee), fontSize: 20.0),
                                  ),
                                  (snapshot.data.imdbScoring != null)
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Icon(Icons.star,
                                                  color: Colors.amber),
                                            ),
                                            Text(
                                                snapshot.data.imdbScoring
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Color(0xFFf1faee),
                                                    fontSize: 20.0)),
                                            Text(
                                              '/10',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0),
                                              child: Container(
                                                  width: width * 0.1,
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: Image.asset(
                                                          'assets/imdb-logo-transparent.png'))),
                                            )
                                          ],
                                        )
                                      : Container(),
                                  (snapshot.data.tmdbScoring != null)
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Icon(Icons.star,
                                                  color: Colors.amber),
                                            ),
                                            Text(
                                                snapshot.data.tmdbScoring
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Color(0xFFf1faee),
                                                    fontSize: 20.0)),
                                            Text(
                                              '/10',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0),
                                              child: Container(
                                                  width: width * 0.1,
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: Image.asset(
                                                          'assets/tmdb-logo.png'))),
                                            )
                                          ],
                                        )
                                      : Container()
                                ],
                              ),
                              Expanded(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                child: Text(
                                  snapshot.data.description,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(color: Color(0xFFf1faee)),
                                ),
                              ))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'where to watch?',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFFf1faee),
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(0.0, ScreenUtil().setHeight(4.0)),
                              blurRadius: 0.0,
                              color: Color(0xFFff6b6b),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Card(
                        elevation: 8.0,
                        color: Color(0xFF525252),
                        child: (snapshot.data.providers != null)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    _buildProvidersList(snapshot.data.providers) +
                                        <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Center(
                                              child: Text(
                                                'tap the provider to start watching',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                  color: Color(0xFFf1faee),
                                                  shadows: <Shadow>[
                                                    Shadow(
                                                      offset: Offset(
                                                          0.0,
                                                          ScreenUtil()
                                                              .setHeight(4.0)),
                                                      blurRadius: 0.0,
                                                      color: Color(0xFFff6b6b),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                              )
                            : Center(
                                child: Container(
                                    decoration:
                                        BoxDecoration(color: Color(0xFF525252)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          'oops... we could not find any providers at the moment...',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color(0xFFf1faee))),
                                    )),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
