import 'package:flutter/material.dart';

class ReservationPage extends StatefulWidget {
  final String flightNumber, operatingAirlines, dod, edt;
  const ReservationPage(
      {Key? key,
      required this.flightNumber,
      required this.operatingAirlines,
      required this.dod,
      required this.edt})
      : super(key: key);

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Page'),
      ),
      body: Center(
        child: Container(),
      ),
    );
  }
}
