
import 'dart:ui';

import '../modal/ShipmentAcceptanceModal.dart';
import '../modal/VehicleTrack.dart';

List<Commodity> commodityListMaster = [];
List<Customer> customerListMaster = [];
List<OriginDestination> originDestinationMaster = [];
List<FrmAndDcpCode> firmsCodeMaster = [];
List<FrmAndDcpCode> dispositionCodeMaster = [];
List<Door> doorList=[];
Commodity? _selectedCommodity;
bool isCES=true;

// String baseUrl="https://galaxyqa.kalelogistics.com/GalaxyHHTIPADAPI/api/"; //QA
String baseUrl="https://galaxycesuat.kalelogistics.com/GalaxyHHTIPADAPI/api/"; //UAT

class Global{
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
        return "Back To Storage";
      case 'EXAMINATION MARKED COMPLETED':
        return "";
      case 'BACK TO STORAGE':
        return "";
      case 'DELIVERED':
        return "";
      default:
        return "";
    }
  }
}

