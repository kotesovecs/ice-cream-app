// import 'dart:convert';
// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
// import 'package:ice_cream/data_models/app_env.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// // class BaseService {
// //   late AppEnv _appEnv;
//   late Dio _client;

//   Dio get client => _client;

//   AppEnv get appEnv => _appEnv;

//   BaseService() {
//     _appEnv = AppEnv.fromEnv(dotenv.env);

//     _client = Dio(BaseOptions(
//       baseUrl: _appEnv.apiUrl,
//       headers: {
//         HttpHeaders.authorizationHeader: getBasicAuthString(),
//       },
//       contentType: Headers.jsonContentType,
//       responseType: ResponseType.json,
//     ))
//       ..interceptors.add(DioCacheInterceptor(
//           options: CacheOptions(
//         store: MemCacheStore(),
//         policy: CachePolicy.request,
//         maxStale: const Duration(days: 7),
//       )))
//       ..interceptors.add(InterceptorsWrapper(
//           onRequest: (RequestOptions options, requestInterceptorHandler) {
//         options.followRedirects = true;
//       }));
//   }

//   String getBasicAuthString() {
//     final token = base64
//         .encode(utf8.encode('${_appEnv.apiUsername}:${_appEnv.apiPassword}'));
//     return 'Basic $token';
//   }

//   Dio _getClient(String url) {
//     print(url);
//     return Dio(BaseOptions(
//       baseUrl: url,
//       headers: {
//         HttpHeaders.authorizationHeader: getBasicAuthString(),
//       },
//       contentType: Headers.jsonContentType,
//       responseType: ResponseType.json,
//     ));
//   }

//   // Future<bool> redirectRequest(
//   //     DioError e, dynamic data, Function callback) async {
//   //   try {
//   //     if (e.response.statusCode == 307 &&
//   //         e.response.headers.map.containsKey("location")) {
//   //       var url = e.response.headers["location"][0];
//   //       var response = await _getClient(url).request("",
//   //           data: data, options: Options(method: e.requestOptions.method));
//   //       if (response.statusCode == 200) {
//   //         if (callback != null) {
//   //           await callback(response);
//   //         }
//   //         return true;
//   //       }
//   //     }
//   //   } on DioError catch (e) {
//   //     print(e);
//   //   }

//   return false;
// }

// Future<bool> redirectPost(DioError e, dynamic data, Function callback) async {
//   try {
//     if (e.response.statusCode == 307 &&
//         e.response.headers.map.containsKey("location")) {
//       var url = e.response.headers["location"][0];
//       var response = await _getClient(url).post("", data: data);
//       if (response.statusCode == 200) {
//         if (callback != null) {
//           await callback(response);
//         }
//         return true;
//       }
//     }
//   } on DioError catch (e) {
//     print(e);
//   }

//   return false;
// }

// Future<bool> redirectPut(DioError e, dynamic data, Function callback) async {
//   try {
//     if (e.response.statusCode == 307 &&
//         e.response.headers.map.containsKey("location")) {
//       var url = e.response.headers["location"][0];
//       var response = await _getClient(url).put("", data: data);
//       if (response.statusCode == 200) {
//         if (callback != null) {
//           await callback(response);
//         }
//         return true;
//       }
//     }
//   } on DioError catch (e) {
//     print(e);
//   }

//   return false;
// }

// Future<bool> redirectDelete(
//     DioError e, dynamic data, Function callback) async {
//   if (e.response.statusCode == 307 &&
//       e.response.headers.map.containsKey("location")) {
//     print(e.response.headers["location"][0]);
//     var redirectClient = Dio(BaseOptions(
//       baseUrl: e.response.headers["location"][0],
//       headers: {
//         HttpHeaders.authorizationHeader: getBasicAuthString(),
//       },
//       contentType: Headers.jsonContentType,
//       responseType: ResponseType.json,
//     ));

//     var response = await redirectClient.delete("", data: data);
//     if (response.statusCode == 200) {
//       if (callback != null) {
//         await callback(response);
//       }
//       return true;
//   //     }
//   // //   }

//   //   return false;
//   // }
// }
