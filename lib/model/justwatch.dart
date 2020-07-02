import 'package:requests/requests.dart';
import 'package:intl/intl.dart';

var header = {'User-Agent': 'JustWatch Fliccs client'};

class JustWatch {
  final String country;
  String apiBaseTemplate = "https://apis.justwatch.com/content/";
  var locale;

  JustWatch(this.country);

  setLocale() async {
    String path = 'locales/state';
    String apiUrl = this.apiBaseTemplate + path;
    var r = await Requests.get(apiUrl, headers: header);
    r.raiseForStatus();
    var json = r.json();
    for (var result in json) {
      if (result['iso_3166_2'] == this.country ||
          result['country'] == this.country) {
        return result['full_locale'];
      }
    }
  }

  Future<List<Movie>> searchForItem(String query) async {
    List<Movie> moviesList = List<Movie>();
    this.locale = await setLocale();
    String path = 'titles/' + this.locale + '/popular';
    String apiUrl = this.apiBaseTemplate + path;
    var payload = {
      "age_certifications": null,
      "content_types": null,
      "presentation_types": null,
      "providers": null,
      "genres": null,
      "languages": null,
      "release_year_from": null,
      "release_year_until": null,
      "monetization_types": null,
      "min_price": null,
      "max_price": null,
      "nationwide_cinema_releases_only": null,
      "scoring_filter_types": null,
      "cinema_release": null,
      "query": query,
      "page": null,
      "page_size": null,
      "timeline_type": null
    };

    var r = await Requests.post(apiUrl, headers: header, json: payload);
    await r.raiseForStatus();
    var jsonResults = await r.json();
    for (var result in jsonResults['items']) {
      moviesList.add(Movie(result['poster'], result['title'], result['offers'],
          result['object_type'], result['id']));
    }
    return moviesList;
  }

  Future<List<Movie>> getPopularMovies() async {
    List<Movie> moviesList = List<Movie>();
    this.locale = await setLocale();
    String path = 'titles/' + this.locale + '/popular';
    String apiUrl = this.apiBaseTemplate + path;
    var payload = {
      "age_certifications": null,
      "content_types": null,
      "presentation_types": null,
      "providers": null,
      "genres": null,
      "languages": null,
      "release_year_from": null,
      "release_year_until": null,
      "monetization_types": null,
      "min_price": null,
      "max_price": null,
      "nationwide_cinema_releases_only": null,
      "scoring_filter_types": null,
      "cinema_release": null,
      "query": null,
      "page": null,
      "page_size": null,
      "timeline_type": null
    };

    var r = await Requests.post(apiUrl, headers: header, json: payload);
    await r.raiseForStatus();
    var jsonResults = await r.json();
    for (int i = 0; i < 6; i++) {
      moviesList.add(Movie(
          jsonResults['items'][i]['poster'],
          jsonResults['items'][i]['title'],
          jsonResults['items'][i]['offers'],
          jsonResults['items'][i]['object_type'],
          jsonResults['items'][i]['id']));
    }
    return moviesList;
  }

  Future<Movie> getDetails(Movie movie) async {
    if (this.locale == null) this.locale = await setLocale();
    String path = 'titles/' +
        movie.contentType +
        '/' +
        movie.id.toString() +
        '/locale/' +
        this.locale;
    String apiUrl = this.apiBaseTemplate + path;
    var r = await Requests.get(apiUrl, headers: header);
    await r.raiseForStatus();
    var jsonResults = await r.json();
    movie.providers = jsonResults['offers'];
    movie.description = jsonResults['short_description'];
    movie.originalReleaseYear = jsonResults['original_release_year'];
    for (var scoring in jsonResults['scoring']) {
      if (scoring['provider_type'] == 'imdb:score') {
        movie.imdbScoring = scoring['value'].toDouble();
      }
      if (scoring['provider_type'] == 'tmdb:score') {
        movie.tmdbScoring = scoring['value'].toDouble();
      }
    }
    return movie;
  }

  Future<dynamic> getCinemaTimes(
      Movie movie, double latitude, double longitude, int radius) async {
    if (this.locale == null) this.locale = await setLocale();
    var dateNow = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String dateString = formatter.format(dateNow);
    String apiUrl = this.apiBaseTemplate +
        'titles/' +
        movie.contentType +
        '/' +
        movie.id.toString() +
        '/showtimes';
    var payload = {
      "date": dateString,
      "latitude": latitude,
      "longitude": longitude,
      "radius": radius
    };

    var r = await Requests.get(apiUrl, headers: header, json: payload);
    await r.raiseForStatus();
    var jsonResults = await r.json();
    print(jsonResults);
    return jsonResults;
  }
}

class Movie {
  final String posterUrl;
  final String name;
  List<dynamic> providers;
  final String contentType;
  final int id;
  String description;
  int originalReleaseYear;
  double imdbScoring;
  double tmdbScoring;

  Movie(this.posterUrl, this.name, this.providers, this.contentType, this.id);

  String getThumbnailUrl() {
    String thumbnailUrl =
        "https://res.cloudinary.com/dq7vqxdwd/image/fetch/w_100,h_100,c_fill,g_face,f_auto/" +
            'https://images.justwatch.com' +
            this.posterUrl.replaceAll('{profile}', 's592');
    return (thumbnailUrl);
  }

  String getPosterUrl() {
    String posterUrl =
        "https://res.cloudinary.com/dq7vqxdwd/image/fetch/c_fill,g_face,f_auto/" +
            'https://images.justwatch.com' +
            this.posterUrl.replaceAll('{profile}', 's592');
    return (posterUrl);
  }
}
