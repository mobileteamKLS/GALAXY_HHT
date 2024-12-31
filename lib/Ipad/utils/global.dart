
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
  // static Color getStatusColor(String status) {
  //   switch (status) {
  //     case 'CREATED':
  //       return AppColors.gatedIn;
  //     case 'ACCEPTED':
  //       return AppColors.gateInRed;
  //     case 'REQUESTED FOR EXAMINATION':
  //       return AppColors.draft;
  //     case 'FORWARDED FOR EXAMINATION':
  //       return AppColors.gateInYellow;
  //     case 'EXAMINATION MARKED COMPLETED':
  //       return AppColors.gateInRed;
  //     default:
  //       return AppColors.gateInYellow;
  //   }
  // }
}

