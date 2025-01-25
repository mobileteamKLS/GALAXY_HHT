
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import '../auth/auth.dart';
import '../modal/ShipmentAcceptanceModal.dart';
import '../modal/VehicleTrack.dart';
import '../modal/yard_checkin_modal.dart';

List<Commodity> commodityListMaster = [];
List<Customer> customerListMaster = [];
List<OriginDestination> originDestinationMaster = [];
List<FrmAndDcpCode> firmsCodeMaster = [];
List<FrmAndDcpCode> dispositionCodeMaster = [];
List<Door> doorList=[];
Commodity? _selectedCommodity;
bool isCES=true;
int userId=0;
bool isTerminalAlreadySelected = false;
List<WarehouseBaseStationBranch> baseStationBranchList = [];
List<WarehouseTerminals> terminalsList = [];
List<WarehouseTerminals> terminalsListDDL = [];
List<WarehouseBaseStation> baseStationList = [];
String selectedBaseStation = "Select";
int selectedBaseStationBranchID = 0;
int selectedBaseStationID = 0;
int selectedTerminalID = 0;
// String galaxyBaseUrl="https://galaxyqa.kalelogistics.com/GalaxyHHTIPADAPI/api/"; //QA
//String galaxyBaseUrl="https://galaxycesuat.kalelogistics.com/GalaxyHHTIPADAPI/api/"; //UAT
String galaxyBaseUrl="http://cesops.jfkces.com/GalaxyHHTIPADAPI/api/"; //UAT

String acsBaseUrl="https://acs2devapi.azurewebsites.net/api_tsm/SrvMobile/"; //UAT
// String acsBaseUrl="https://acs2usaapigateway.azurewebsites.net/GalaxyHHTIPADAPI/api/"; //UAT

class Utils{
  static Color getStatusColor(String status) {
    switch (status) {
      case 'CREATED':
        return Color(0xffCCDFFA);
      case 'ACCEPTED':
        return Color(0xffB3D8B4);
      case 'REQUESTED FOR EXAMINATION':
        return Color(0xffFFD0D0);
      case 'FORWARDED FOR EXAMINATION':
        return Color(0xffFCDEA0);
      case 'EXAMINATION MARKED COMPLETED':
        return Color(0xffB3D8B4);
      case 'BACK TO STORAGE':
        return Color(0xffFFD7BC);
      case 'DELIVERED':
        return Color(0xffCCF1F6);
      default:
        return Color(0xffFCDEA0);
    }
  }
  static String getStatusAction(String status) {
    switch (status) {
      case 'CREATED':
        return "Accept Shipment";
      case 'ACCEPTED':
        return "";
      case 'REQUESTED FOR EXAMINATION':
        return "Forward For Exam.";
      case 'FORWARDED FOR EXAMINATION':
        return "";
      case 'EXAMINATION MARKED COMPLETED':
        return "Back To Storage";
      case 'BACK TO STORAGE':
        return "";
      case 'DELIVERED':
        return "";
      default:
        return "";
    }
  }
}

class Global {
  Future<Post> postData(service, payload) async {
    print("payload " + payload.toString());
    print("encoded payload " + json.encode(payload));
    return fetchData(service, payload);
  }

  Future<Post> getData(service, payload) async {
    print("payload " + payload.toString());
    print("encoded payload " + json.encode(payload));
    return fetchDataGET(service, payload);
  }

  Future<Post> fetchDataGET(apiname, payload) async {
    var newURL = acsBaseUrl + apiname;
    print("fetch data for API = " + newURL);
    var url = Uri.parse(newURL);
    url = Uri.https(url.authority, url.path, payload);
    return await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }).then((http.Response response) {
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



    //return http.get(Uri.parse('http://113.193.225.56:8080/POCMobile/api/DOAPILogin'));
  }
  Future<Post> fetchData(apiname, payload) async {
    var newURL = acsBaseUrl + apiname;
    print("fetch data for API = " + newURL);
    if (payload == "") {
      print("payload blank");
      return await http.post(
        Uri.parse(newURL),
        body: json.encode({}),
        headers: {
          'Content-Type': 'application/json',
        },
      ).then((http.Response response) {
        print(response.body);
        print(response.statusCode);

        final int statusCode = response.statusCode;
        if (statusCode == 401) {
          return Post.fromJson(response.body, statusCode);
        }
        //  if (statusCode == 404) {
        //   return Post.fromJson(response.body, statusCode);
        // }
        if (statusCode < 200 || statusCode > 400) {
          throw new Exception("Error while fetching data");
        }
        print("sending data to post");
        return Post.fromJson(response.body, statusCode);
      });
    } else {
      return await http.post(
        Uri.parse(newURL),
        body: json.encode(payload),
        headers: {
          'Content-Type': 'application/json',
        },
      ).then((http.Response response) {
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

    //return http.get(Uri.parse('http://113.193.225.56:8080/POCMobile/api/DOAPILogin'));
  }

  Future<Post> setData(apiname, payload) async {
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.none) {
    //   this.showToast("No internet Connection Available !");
    // } else {
    return saveData(apiname, payload);
    //}
  }

  Future<Post> saveData(apiname, payload) async {
    var newURL = acsBaseUrl + apiname;
    print("save data for API = " + newURL);
    // print(newURL);
    print("payload " + json.encode(payload));
    return await http
        .post(
      Uri.parse(newURL),
      body: json.encode(payload),
      headers: {
        'Content-Type': 'application/json',
      },
    )
        .then((http.Response response) {
      print("response received");
      print(response.body);

      final int statusCode = response.statusCode;
      if (statusCode == 401) {
        return Post.fromJson(response.body, statusCode);
      }
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return Post.fromJson(response.body, statusCode);
    })
        .catchError((onError) {})
        .whenComplete(() {
      print("completed");
    })
        .catchError((onError) => print(onError));
  }

  Future<Post> fetchDataLoadUnload(payload) async {
    print("fetchDataLoadUnload payload " + payload.toString());
    print("fetchDataLoadUnload encoded payload " + json.encode(payload));
    var newURL =
        "https://atlacssrv.kalelogistics.com/ACS_ML/api/DockTime/Predict22";
    print("fetch data for API = " + newURL);

    return await http.post(
      Uri.parse(newURL),
      body: json.encode(payload),
      headers: {
        'Content-Type': 'application/json',
      },
    ).then((http.Response response) {
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

