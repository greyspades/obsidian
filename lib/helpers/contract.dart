import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

Future<List<String>?> makeContract() async {
      Uri url = Uri.parse(
        // 'https://e360.lapo-nigeria.org/03a3b2c6f7d8e1c4_0a'
        'http://10.0.0.184:8015/03a3b2c6f7d8e1c4_0a'
        );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var data = response.headers['x-lapo-eve-proc']?.split('~');
        return data;
      }
      return [''];
}

Future<List<String>?> renewContract(Map<String, String> headers) async {
      Uri url = Uri.parse('http://10.0.0.184:8015/03a3b2c6f7d8e1c4_0b');
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var data = response.headers['x-lapo-eve-proc']?.split('~');
        return data;
      }
      return [''];
}

class Auth {
  String? aesKey;
  String? iv;
  String? token;
  Auth({this.aesKey, this.iv, this.token});
}

class Screen {
  String? screen;
  Screen({this.screen});
}

class Environment {
  String prod = "https://e360.lapo-nigeria.org";
  String dev = "http://10.0.0.184:8015";
  String current = "http://10.0.0.184:8015";
}


final authProvider = StateProvider<Auth>((_) => Auth());

final screenProvider = StateProvider<Screen>((_) => Screen());

final environment = StateProvider<Environment>((_) => Environment());
