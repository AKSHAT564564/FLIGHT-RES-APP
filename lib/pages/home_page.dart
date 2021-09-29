import 'package:flight_res_system/pages/flight_detail.dart';
import 'package:flight_res_system/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String id = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  DateTime? _selectedDate;

  late TabController _tabController;

  final _formKey = GlobalKey<FormState>();

  final _originStationController = TextEditingController();
  final _destinationController = TextEditingController();

  List<Map<String, dynamic>> flightData = <Map<String, dynamic>>[];

  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 1, initialIndex: 0);
  }

  getData(departure, arrival) async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'sql6.freesqldatabase.com',
        port: 3306,
        user: 'sql6440984',
        db: 'sql6440984',
        password: 'IQFtawYj3k'));

    var result = await conn.query(
        'select FLIGHT_NUMBER ,OPERATING_AIRLINES,DATE_OF_DEPARTURE,ESTIMATED_DEPARTURE_TIME from flight where DEPARTURE_CITY = ? and ARRIVAL_CITY = ?',
        ['$departure', '$arrival']);

    for (var row in result) {
      var data = {
        "flightNumber": "${row[0]}",
        "operatingAirlines": "${row[1]}",
        "DoD": "${row[2]}",
        "EDT": '${row[3]}',
      };
      flightData.add(data);
    }
    await conn.close();
  }

  final List<Tab> topTabs = <Tab>[
    Tab(
      icon: Icon(
        FontAwesomeIcons.plane,
        size: 20,
      ),
    ),
  ];

  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(1950),
            //what will be the previous supported year in picker
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _selectedDate = pickedDate;
      });
    });
  }

  Widget textFormFeild(
    padding,
    feildName,
    controller,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) {},
      decoration: InputDecoration(
        hintText: 'Enter your $feildName',
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Flight Res',
          style: TextStyle(fontFamily: 'Scheherazade New'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
            icon: Icon(FontAwesomeIcons.userCircle),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.lightGreenAccent,
          tabs: topTabs,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(children: [
          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                Card(
                  color: Color(0xffFE2E2E),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(FontAwesomeIcons.plane),
                        title: const Text('Search Flights'),
                        subtitle: Text(
                          'Flight Reservation System',
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(children: [
                    textFormFeild(
                        EdgeInsets.only(
                            top: 20, right: 20, left: 20, bottom: 15),
                        'from',
                        _originStationController),
                    SizedBox(
                      height: 25,
                    ),
                    Transform.rotate(
                      angle: 90 * math.pi / 180,
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.exchangeAlt,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          if (_originStationController.text != '' &&
                              _destinationController.text != '') {
                            var temp = _originStationController.text;
                            _originStationController.text =
                                _destinationController.text;
                            _destinationController.text = temp;
                          }
                        },
                      ),
                    ),
                    textFormFeild(
                        EdgeInsets.only(
                            top: 15, right: 20, left: 20, bottom: 20),
                        'destination',
                        _destinationController),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Row(children: [
                        TextButton(
                            child: Text(
                              'Departure',
                              style: TextStyle(color: Colors.blue),
                            ),
                            onPressed: _pickDateDialog),
                        Text(
                          _selectedDate ==
                                  null //ternary expression to check if date is null
                              ? 'Choose Date'
                              : '${DateFormat.yMMMd().format(_selectedDate!)}',
                          textAlign: TextAlign.center,
                        ),
                      ]),
                    ),
                  ]),
                ),
                SizedBox(
                  height: 18,
                ),
                Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xffFE2E2E), // background
                      // foreground
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await getData(_originStationController.text,
                            _destinationController.text);
                      }

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FlightDetail(
                                    flightData: flightData,
                                    origin: _originStationController.text,
                                    destination: _destinationController.text,
                                  )));
                    },
                    child: Text('Search FLights'),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
