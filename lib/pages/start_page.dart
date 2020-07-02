import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:fliccs/model/justwatch.dart';
import 'file:///D:/projects/fliccs/lib/pages/search_results_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';

import 'movie_page.dart';

Country _selectedDialogCountry = CountryPickerUtils.getCountryByIsoCode('PL');
JustWatch _justwatchApi;
var supportedCountries = [
  'CA',
  'MX',
  'US',
  'AR',
  'BR',
  'CL',
  'CO',
  'EC',
  'PE',
  'VE',
  'AT',
  'BE',
  'CZ',
  'DK',
  'EE',
  'FI',
  'FR',
  'DE',
  'GR',
  'HU',
  'IE',
  'IT',
  'LV',
  'LT',
  'NL',
  'NO',
  'PL',
  'PT',
  'RO',
  'RU',
  'ES',
  'SE',
  'CH',
  'GB',
  'IN',
  'ID',
  'JP',
  'MY',
  'PH',
  'SG',
  'KR',
  'TH',
  'TR',
  'AU',
  'NZ'
];

class SearchPage extends StatefulWidget {
  SearchPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final List<String> _tabsTitles = ["trending"];
  AnimationController _animationController;
  Animation _colorTween;

  int _activeTabIndex = 0;

  List<Widget> _tabBarBuilder() {
    List<Widget> tabs = [
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
          child: AnimatedContainer(
              decoration: _activeTabIndex == 0
                  ? BoxDecoration(
                      color: Color(0xFFf1faee),
                      borderRadius: BorderRadius.circular(20.0))
                  : BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10.0)),
              child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: AnimatedBuilder(
                      animation: _colorTween,
                      builder: (BuildContext context, Widget child) {
                        if (_activeTabIndex == 0)
                          _animationController.reverse();
                        else
                          _animationController.forward();
                        return Icon(Icons.search, color: _colorTween.value);
                      })),
              duration: const Duration(seconds: 1)))
    ];
    for (int i = 0; i < _tabsTitles.length; i++) {
      tabs.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        child: AnimatedContainer(
          decoration: _activeTabIndex == i + 1
              ? BoxDecoration(
                  color: Color(0xFFf1faee),
                  borderRadius: BorderRadius.circular(20.0))
              : BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20.0)),
          duration: const Duration(milliseconds: 1200),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(seconds: 1),
              style: _activeTabIndex == i + 1
                  ? TextStyle(
                      fontSize: 16.0,
                      color: Color(0xFFff6b6b),
                      fontFamily: 'Montserrat')
                  : TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFf1faee),
                      fontFamily: 'Montserrat'),
              child: Text(_tabsTitles[i]),
            ),
          )),
        ),
      ));
    }
    return tabs;
  }

  @override
  void initState() {
    _justwatchApi = JustWatch(_selectedDialogCountry.isoCode);
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));
    _colorTween = ColorTween(begin: Color(0xFFff6b6b), end: Color(0xFFf1faee))
        .animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(width: 1080, height: 2280, allowFontScaling: false);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: _tabsTitles.length + 1,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            timeDilation = 1.0;
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
            child: Container(
              decoration: BoxDecoration(color: Color(0xFF525252)),
              child: Column(
                children: <Widget>[
                  Image(
                      image: ExactAssetImage('assets/images/fliccs_baner.png')),
                  SizedBox(
                    width: ScreenUtil().setWidth(500),
                    child: AutoSizeText(
                      'fliccs',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 80.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFFf1faee),
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(0.0, ScreenUtil().setHeight(8.0)),
                              blurRadius: 0.0,
                              color: Color(0xFFff6b6b),
                            )
                          ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TabBar(
                          indicatorColor: Colors.transparent,
                          onTap: (index) {
                            timeDilation = 1.0;
                            setState(() {
                              _activeTabIndex = index;
                            });
                          },
                          isScrollable: true,
                          labelPadding: EdgeInsets.only(left: 0.0),
                          tabs: _tabBarBuilder()),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SearchTab(),
                        ),
                        MoviesTab(),
                      ],
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
}

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _titleController = TextEditingController();
  bool _showClearButton = false;
  final _formKey = GlobalKey<FormState>();

  Widget _buildCountryTile(Country country) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8.0),
          Flexible(
              child: Text(
            country.iso3Code,
            textAlign: TextAlign.right,
          ))
        ],
      );

  Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8.0),
          Flexible(
              child: Text(
            country.name,
          ))
        ],
      );

  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context)
              .copyWith(dialogBackgroundColor: Color(0xFF1c1d1f)),
          child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Color(0xFFf1faee),
            searchInputDecoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFf1faee)),
                ),
                hintText: 'Search...',
                hintStyle: TextStyle(color: Color(0xFFf1faee)),
                hoverColor: Color(0xFFf1faee),
                focusColor: Color(0xFFf1faee)),
            itemFilter: (c) => supportedCountries.contains(c.isoCode),
            isSearchable: true,
            title: Text('Select your country',
                style: TextStyle(color: Color(0xFFf1faee))),
            onValuePicked: (Country country) => setState(() {
              _selectedDialogCountry = country;
              _justwatchApi = JustWatch(country.isoCode);
              Future.delayed(
                  const Duration(milliseconds: 500), () => timeDilation = 1.0);
            }),
            itemBuilder: _buildDialogItem,
            priorityList: [
              CountryPickerUtils.getCountryByIsoCode('PL'),
              CountryPickerUtils.getCountryByIsoCode('US'),
              CountryPickerUtils.getCountryByIsoCode('GB')
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: TextFormField(
                onChanged: (text) => {
                      setState(() {
                        if (text.length > 0)
                          _showClearButton = true;
                        else
                          _showClearButton = false;
                      })
                    },
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
                            icon: Icon(Icons.clear, color: Color(0xFFf1faee)))
                        : null,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFf1faee)),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("select country",
                  style: TextStyle(color: Color(0xFFf1faee))),
              Flexible(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: ListTile(
                    onTap: () {
                      timeDilation = 3.0;
                      FocusScope.of(context).requestFocus(new FocusNode());
                      _openCountryPickerDialog();
                    },
                    title: _buildCountryTile(_selectedDialogCountry),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              color: Color(0xFFff6b6b),
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(height: 2.0),
                      Text(
                        'search',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Color(0xFF5cd1c8)),
                      ),
                    ],
                  ),
                  Text(
                    'search',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Color(0xFFf1faee)),
                  ),
                ],
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchResultsPage(
                            _titleController.text,
                            _selectedDialogCountry.isoCode)),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class MoviesTab extends StatefulWidget {
  const MoviesTab({Key key}) : super(key: key);

  @override
  _MoviesTabState createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab> with TickerProviderStateMixin {
  StreamController<List<Movie>> _movieListStream;

  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context)
              .copyWith(dialogBackgroundColor: Color(0xFF1c1d1f)),
          child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Color(0xFFf1faee),
            searchInputDecoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFf1faee)),
                ),
                hintText: 'Search...',
                hintStyle: TextStyle(color: Color(0xFFf1faee)),
                hoverColor: Color(0xFFf1faee),
                focusColor: Color(0xFFf1faee)),
            itemFilter: (c) => supportedCountries.contains(c.isoCode),
            isSearchable: true,
            title: Text('Select your country',
                style: TextStyle(color: Color(0xFFf1faee))),
            onValuePicked: (Country country) => setState(() {
              _selectedDialogCountry = country;
              _justwatchApi = JustWatch(country.isoCode);
              _loadMovies();
              Future.delayed(
                  const Duration(milliseconds: 500), () => timeDilation = 1.0);
            }),
            itemBuilder: _buildDialogItem,
            priorityList: [
              CountryPickerUtils.getCountryByIsoCode('PL'),
              CountryPickerUtils.getCountryByIsoCode('US'),
              CountryPickerUtils.getCountryByIsoCode('GB')
            ],
          ),
        ),
      );

  Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8.0),
          Flexible(
              child: Text(
            country.name,
          ))
        ],
      );

  Widget _buildCountryTile(Country country) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8.0),
          Flexible(
              child: Text(
            country.iso3Code,
            textAlign: TextAlign.right,
          ))
        ],
      );

  void _loadMovies() async {
    _justwatchApi
        .getPopularMovies()
        .then((val) => _movieListStream.sink.add(val))
        .catchError((err) => _movieListStream.sink.addError(err));
  }

  @override
  void initState() {
    _movieListStream = StreamController<List<Movie>>();
    _loadMovies();
    super.initState();
  }

  @override
  void dispose() {
    _movieListStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(width: 1080, height: 2280, allowFontScaling: false);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            elevation: 5.0,
            color: Color(0xFF424242),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'currently trending in',
                    style: TextStyle(color: Color(0xFFf1faee)),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(20.0),
                  ),
                  InkWell(
                    onTap: () {
                      timeDilation = 3.0;
                      _openCountryPickerDialog();
                    },
                    child: Container(
                        width: ScreenUtil().setWidth(360),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.grey),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child:
                                    _buildCountryTile(_selectedDialogCountry),
                              ),
                              Icon(Icons.arrow_drop_down)
                            ],
                          ),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
        StreamBuilder<List<Movie>>(
            stream: _movieListStream.stream,
            builder:
                (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
              if (snapshot.hasError) {
                return Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                          'oops... something went wrong\nplease try again',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFFf1faee))),
                    ),
                  ),
                );
              } else if (!snapshot.hasData) {
                return Expanded(
                    child: Center(child: CircularProgressIndicator()));
              } else
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.all(ScreenUtil().setHeight(30.0)),
                        child: AnimatedSize(
                            vsync: this,
                            duration: Duration(milliseconds: 500),
                            child: InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MoviePage(
                                        snapshot.data[index], _justwatchApi)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.network(
                                    snapshot.data[index].getPosterUrl()),
                              ),
                            )),
                      );
                    },
                  ),
                );
            })
      ],
    );
  }
}
