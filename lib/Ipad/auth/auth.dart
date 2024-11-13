import 'package:http/http.dart' as http;
import 'dart:convert';
class AuthService{

  Future<Post> postData(service, payload) async {
    print("payload $payload");
    print(json.encode(payload));
    return fetchDataPOST(service, payload);
  }
  Future<Post> fetchDataPOST(apiName, payload) async {
    var newURL = "https://galaxyqa.kalelogistics.com/GHAHHTAPI/api/$apiName";

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