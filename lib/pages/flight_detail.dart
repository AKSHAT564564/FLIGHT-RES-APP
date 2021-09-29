// ignore_for_file: non_constant_identifier_names

import 'package:flight_res_system/pages/reservation_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FlightDetail extends StatefulWidget {
  final List<Map<String, dynamic>> flightData;
  final String origin, destination;
  const FlightDetail(
      {Key? key,
      required this.flightData,
      required this.origin,
      required this.destination})
      : super(key: key);

  static String id = 'flight_detail';

  @override
  _FlightDetailState createState() => _FlightDetailState();
}

class _FlightDetailState extends State<FlightDetail> {
  Widget flightDetailCard(
      fligthDataLength, flightNumber, operatingAirline, Dod, EDT) {
    if (fligthDataLength == 0) {
      return Center(
          child: Text(
        'abcd',
        style: TextStyle(fontWeight: FontWeight.w100),
      ));
    }
    String dodTemp = Dod.substring(0, 10);
    String EDTtemp = EDT.substring(10, 19);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: Color(0xff38610B),
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    FontAwesomeIcons.plane,
                    size: 30,
                  ),
                  Text(
                    '$operatingAirline',
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 30),
                    child: Text(
                      '$flightNumber',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // SizedBox(
                  //   width: 110,
                  // ),
                  Text(
                    '$dodTemp',
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 20),
            alignment: Alignment.center,
            child: Row(children: [
              Icon(
                FontAwesomeIcons.planeDeparture,
                size: 16,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                'Deaprture Time',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              Icon(
                FontAwesomeIcons.arrowRight,
                size: 16,
              ),
              Text(
                '$EDTtemp',
                style: TextStyle(fontWeight: FontWeight.w400),
              )
            ]),
          ),
          ButtonBar(
            children: <Widget>[
              ElevatedButton(
                child: Text('Book Flight'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReservationPage(
                                flightNumber: flightNumber,
                                operatingAirlines: operatingAirline,
                                dod: dodTemp,
                                edt: EDTtemp,
                              )));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(children: [
          Text(widget.origin),
          Padding(padding: EdgeInsets.only(right: 8)),
          Icon(FontAwesomeIcons.arrowRight),
          Padding(padding: EdgeInsets.only(left: 8)),
          Text(widget.destination),
        ])),
        body: Center(
            child: ListView.builder(
          itemCount: widget.flightData.length,
          itemBuilder: (context, i) => flightDetailCard(
              widget.flightData.length,
              widget.flightData[i]["flightNumber"],
              widget.flightData[i]["operatingAirlines"],
              widget.flightData[i]["DoD"],
              widget.flightData[i]["EDT"]),
        )));
  }
}
