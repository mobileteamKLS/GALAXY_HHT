
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../Ipad/utils/global.dart';

class Api{
  final Dio _dio = Dio();

  Api() {
    _dio.options.baseUrl = galaxyBaseUrl;//GalaxyHHTIPADAPI
    //_dio.options.baseUrl = "http://192.168.1.10/GalaxyHHTAPI/api/";
    _dio.interceptors.add(PrettyDioLogger());
  }

  Dio get sendRequest => _dio;

}