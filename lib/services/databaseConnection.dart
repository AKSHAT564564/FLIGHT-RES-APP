import 'dart:async';
import 'package:mysql1/mysql1.dart';

Future getConnection() async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '10.0.2.2', port: 3306, user: 'root', db: 'reservation'));

  return conn;
}
