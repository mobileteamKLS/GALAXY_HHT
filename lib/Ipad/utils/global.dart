
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
