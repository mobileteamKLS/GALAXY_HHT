
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class Api{
  final Dio _dio = Dio();

  Api() {
    _dio.options.baseUrl = "http://galaxycesuat.kalelogistics.com/GalaxyHHTIPADAPI";//GalaxyHHTIPADAPI
    //_dio.options.baseUrl = "http://192.168.1.10/GalaxyHHTAPI/api/";
    _dio.interceptors.add(PrettyDioLogger());
  }

  Dio get sendRequest => _dio;

}