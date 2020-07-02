import 'dart:async';

import 'package:fliccs/model/justwatch.dart';
import 'file:///D:/projects/fliccs/lib/pages/movie_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class SearchResultsPage extends StatefulWidget {
  final String _title;
  final String _country;

  const SearchResultsPage(this._title, this._country, {Key key})
      : super(key: key);

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  StreamController<List<Movie>> _movieListStream;
  TextEditingController _titleController;
  JustWatch _justwatchApi;
  bool _showClearButton = true;

  Widget buildError(String error) {
    return SizedBox.expand(
      child: Container(
          decoration: BoxDecoration(color: Color(0xFF424242)),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(error,
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFf1faee))),
          )),
    );
  }

  Widget buildAppBar() {
    ScreenUtil.init(width: 1080, height: 2280, allowFontScaling: false);
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
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          color: Color(0xFFff6b6b)),
                      child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child:
                              Icon(Icons.arrow_back, color: Color(0xFFf1faee))),
                    ),
                    Flexible(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF424242),
                              blurRadius: 30.0, // soften the shadow
                              spreadRadius: 0.0, //extend the shadow
                              offset: Offset(
                                0.0, // Move to right 10  horizontally
                                15.0, // Move to bottom 5 Vertically
                              ),
                            )
                          ],
                        ),
                        child: TextFormField(
                            onChanged: (text) => {
                                  setState(() {
                                    if (text.length > 0)
                                      _showClearButton = true;
                                    else
                                      _showClearButton = false;
                                    _loadMovies(text);
                                  })
                                },
                            style: TextStyle(color: Color(0xFFf1faee)),
                            controller: _titleController,
                            decoration: InputDecoration(
                                suffixIcon: _showClearButton
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _showClearButton = false;
                                            _titleController.clear();
                                          });
                                        },
                                        icon: Icon(Icons.clear,
                                            color: Color(0xFFf1faee)))
                                    : Icon(Icons.search,
                                        color: Color(0xFFf1faee)),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFf1faee)),
                                ),
                                hintText: 'enter title',
                                hintStyle: TextStyle(color: Color(0xFFf1faee)),
                                hoverColor: Color(0xFFf1faee),
                                focusColor: Color(0xFFf1faee)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'please enter title you want to look for';
                              } else
                                return null;
                            }),
                      ),
                    ))
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget buildList(BuildContext context, int index, Movie movie) {
    ScreenUtil.init(width: 1080, height: 2280, allowFontScaling: false);
    return InkWell(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MoviePage(movie, _justwatchApi)),
            ),
        child: Container(
          child: Card(
              color: Color(0xFF525252),
              elevation: 2.0,
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: ListTile(
                leading: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(75.0),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/fliccs_logo.png',
                      image: movie.getThumbnailUrl(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(movie.name),
                trailing: Icon(Icons.keyboard_arrow_right,
                    color: Color(0xFFff6b6b), size: 30.0),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              )),
        ));
  }

  void _loadMovies(String title) async {
    _justwatchApi
        .searchForItem(title)
        .then((val) => _movieListStream.sink.add(val))
        .catchError((err) => _movieListStream.sink.addError(err));
  }

  @override
  void initState() {
    _movieListStream = StreamController<List<Movie>>();
    _justwatchApi = JustWatch(widget._country);
    _loadMovies(widget._title);
    _titleController = TextEditingController(text: widget._title);
    super.initState();
  }

  @override
  void dispose() {
    _movieListStream.close();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Movie>>(
      stream: _movieListStream.stream,
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasError)
          return Scaffold(
              appBar: buildAppBar(),
              body:
                  buildError('oops... something went wrong\nplease try again'));
        else if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        else
          return Scaffold(
              appBar: buildAppBar(),
              body: Container(
                decoration: BoxDecoration(color: Color(0xFF424242)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: snapshot.data.length == 0
                      ? buildError(
                          'no results found\ntry changing the search phrase')
                      : ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) =>
                              Container(
                                  decoration:
                                      BoxDecoration(color: Color(0xFF424242)),
                                  child: buildList(
                                      context, index, snapshot.data[index]))),
                ),
              ));
      },
    );
  }
}
