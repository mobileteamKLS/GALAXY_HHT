import 'package:http/http.dart' as http;
import 'dart:convert';
class AuthService{

  Future<Post> postData(service, payload) async {
    print("payload $payload");
    print(json.encode(payload));
    return fetchDataPOST(service, payload);
  }
  Future<Post> fetchDataPOST(apiName, payload) async {
    var newURL = "https://galaxyqa.kalelogistics.com/GalaxyHHTIPADAPI/api/$apiName";
    print("fetch data for API = $newURL");
    // final headers = {
    //   'Content-Type': 'application/json',
    //   'Accept': 'application/json',
    //   'Authorization': 'Bearer ${loginMaster[0].token}',
    // };
    final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
    };


    if (payload == "") {
      print("payload blank");
      return await http
          .post(
        Uri.parse(newURL),
        body: json.encode({}),
        headers: headers,
      )
          .then((http.Response response) {
        print(response.body);
        print(response.statusCode);

        final int statusCode = response.statusCode;
        if (statusCode == 401) {
          return Post.fromJson(response.body, statusCode);
        }
        if (statusCode < 200 || statusCode > 400) {
          throw Exception("Error while fetching data");
        }
        print("sending data to post");
        return Post.fromJson(response.body, statusCode);
      });
    } else {
      return await http
          .post(
        Uri.parse(newURL),
        body: json.encode(payload),
        headers: headers,
      )
          .then((http.Response response) {
        print(response.body);
        print(response.statusCode);

        final int statusCode = response.statusCode;
        if (statusCode == 401) {
          return Post.fromJson(response.body, statusCode);
        }
        if (statusCode < 200 || statusCode > 400) {
          return Post.fromJson(response.body, statusCode);
        }
        print("sending data to post");
        return Post.fromJson(response.body, statusCode);
      });
    }
  }

  Future<Post> getData(service, payload) async {
    print("payload $payload");
    // Utils.printPrettyJson("encoded payload ${json.encode(payload)}");
    return fetchDataGET(service, payload);
  }
  Future<Post> fetchDataGET(apiName, payload) async {
    var newURL = "https://galaxyqa.kalelogistics.com/GalaxyHHTIPADAPI/api/$apiName";
    print("fetch data for API = $newURL");
    var url = Uri.parse(newURL);
    url = Uri.https(url.authority, url.path, payload);
    return await http.get(url,
        headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        }).then((http.Response response) {

      print(response.statusCode);

      final int statusCode = response.statusCode;
      if (statusCode == 401) {
        return Post.fromJson(response.body, statusCode);
      }
      if (statusCode < 200 || statusCode > 400) {
        return Post.fromJson(response.body, statusCode);
      }
      print("sending data to post");
      return Post.fromJson(response.body, statusCode);
    });
  }

  Future<Post> sendGetWithBody(apiName, payload) async {
    print("payload = $payload");
    String url = 'https://galaxyqa.kalelogistics.com/GalaxyHHTIPADAPI/api/$apiName';
    print("fetch data for API = $url");
    String jsonString = json.encode(payload);
    var request = http.Request('GET', Uri.parse(url));
    request.headers['Content-Type'] = 'application/json';
    request.body = jsonString;
    try {
      var response = await request.send();
      return await handleResponse(response);
    } catch (e) {
      throw Exception("Failed request: $e");
    }
  }
  Future<Post> sendPostWithBody(apiName, payload) async {
    print("payload = $payload");
    String url = 'https://galaxyqa.kalelogistics.com/GalaxyHHTIPADAPI/api/$apiName';
    print("fetch data for API = $url");
    String jsonString = json.encode(payload);

    var request = http.Request('POST', Uri.parse(url));
    request.headers['Content-Type'] = 'application/json';
    request.body = jsonString;

    try {
      var response = await request.send();
      return await handleResponse(response);
    } catch (e) {
      throw Exception("Failed request: $e");
    }
  }


}

Future<Post> handleResponse(http.StreamedResponse response) async {
  final int statusCode = response.statusCode;
  final String responseBody = await response.stream.bytesToString();

  print('Status code: $statusCode');

  if (statusCode == 401) {
    return Post.fromJson(responseBody, statusCode);
  }

  if (statusCode < 200 || statusCode > 400) {
    throw Exception("Error while fetching data: $statusCode");
  }

  return Post.fromJson(responseBody, statusCode);
}


class Post {
  final int statusCode;
  final String body;

  Post({required this.statusCode, required this.body});

  factory Post.fromJson(String json, int statusCode) {
    return Post(
      statusCode: statusCode,
      body: json,
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["statusCode"] = statusCode;
    map["body"] = body;
    return map;
  }
}