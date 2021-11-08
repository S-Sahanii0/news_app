import 'dart:convert';

import 'package:flutter/services.dart';

void haha() async {
  final String response =
      await rootBundle.loadString('assets/data/news_data.json');
  final data = await json.decode(response);
  List.from(data.keys).forEach((element) {
    print(data[element]);
  });
}
