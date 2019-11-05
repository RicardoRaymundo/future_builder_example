import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:future_builder_example/resources/loading.dart';
import 'package:http/http.dart' as http;

class ApiConnect {

  ApiConnect();

  static ApiConnect server() {
    return new ApiConnect();
  }

  static Future<List<dynamic>> loadData(String endpoint, dynamic next) async {
    var data = await http.get(endpoint);

    var jsonData = json.decode(data.body);

    return next(jsonData);
  }

  static FutureBuilder getData(dynamic data, dynamic next) {
    return FutureBuilder(
      future: data,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Text('ERROR!!!');
          } else {
            return next(snapshot);
          }
        }
        return null;
      },
    );
  }

  static get(String endpoint, dynamic callback, dynamic next) {
    return ApiConnect.getData(ApiConnect.loadData(endpoint, callback), next);
  }
}