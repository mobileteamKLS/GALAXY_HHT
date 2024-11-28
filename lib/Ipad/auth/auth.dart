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

  Future<Post> sendXmlInGetWithBody(apiName, payload) async {
    String url = 'https://galaxyqa.kalelogistics.com/GalaxyHHTIPADAPI/api/$apiName';
  //
  //   String xmlContent = '''
  // <Root>
  //   <AWBPrefix>125</AWBPrefix>
  //   <AWBNo>78787787</AWBNo>
  //   <HAWBNO>HB234</HAWBNO>
  //   <AirportCity>JFK</AirportCity>
  //   <Culture>''</Culture>
  //   <CompanyCode>3</CompanyCode>
  //   <UserId>1</UserId>
  // </Root>
  // ''';
  //
  //   // Create the JSON object
  //   Map<String, dynamic> jsonBody = {
  //     "InputXML": xmlContent,
  //   };

    // Convert the map to JSON
    String jsonString = json.encode(payload);

    // Create a request object for GET method
    var request = http.Request('GET', Uri.parse(url));

    // Set headers to indicate the content type (application/json)
    request.headers['Content-Type'] = 'application/json';

    // Add the JSON string in the request body
    request.body = jsonString;

    try {
      // Send the GET request
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

  print('Response:Successful');
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