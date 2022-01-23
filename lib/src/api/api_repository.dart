import 'package:dio/dio.dart';

class ApiRepository {
  final String? url;
  Map<String, dynamic>? payload;

  ApiRepository({required this.url, payload});

  Dio dio = Dio();

  void get({
    Function()? beforeSend,
    Function(dynamic data)? onSuccess,
    Function(dynamic error)? onError,
  }) {
    dio.get(url!, queryParameters: payload).then((response) {
      onSuccess!(response.data);
    }).catchError((error) {
      onError!(error);
    });
  }
}
