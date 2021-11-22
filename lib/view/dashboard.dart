import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double temperature = 23;
  double humidity = 78;
  double pm25 = 11;
  double pm10 = 0;
  String lastUpdate = "1970년";

  String host = "http://192.168.126.97:3000/api/devices/6";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("공학설계 17조: 스마트 공기청정기"),
      ),
      body: StreamBuilder<String>(
        stream: _fetchData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return mainWidget("연결중...");
            else
              return mainWidget("연결 실패");
          } else if (snapshot.hasError) {
            return mainWidget("연결 실패");
          } else {
            Map response = json.decode(snapshot.data.toString());
            humidity = response['env']['humidity'];
            temperature = response['env']['temperature'];
            pm25 = response['env']['pm2p5'];
            pm10 = response['env']['pm10'];
            lastUpdate = response['env']['created_at'];

            return mainWidget("연결됨");
          }
        },
      ),
    );
  }

  Container mainWidget(String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                Row(
                  children: [
                    Text("기기 상태", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    Spacer(),
                    Text(status, style: TextStyle(fontSize: 20))
                  ],
                ),
                SizedBox(height: 10),
                Text("마지막 업데이트: " + lastUpdate),
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                Row(
                  children: [
                    Text("온도", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    Spacer(),
                    Text(temperature.toString() + "도", style: TextStyle(fontSize: 20)),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text("습도", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    Spacer(),
                    Text(humidity.toString() + "%", style: TextStyle(fontSize: 20)),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text("미세먼지", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    Spacer(),
                    Column(
                      children: [
                        Text("PM25: " + pm25.toString() + "(㎍/㎥)", style: TextStyle(fontSize: 16)),
                        Text("PM10: " + pm10.toString() + "(㎍/㎥)", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text("미세먼지 상태", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    Spacer(),
                    dustStatus(pm25),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () => setState(() {}),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  Text("갱신", style: TextStyle(fontSize: 24, color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dustStatus(double pm25) {
    if (pm25 <= 15 && pm25 >= 0) {
      return Row(children: [
        Icon(Icons.mood, size: 28, color: Colors.green),
        SizedBox(width: 8),
        Text("좋음", style: TextStyle(fontSize: 20, color: Colors.green))
      ]);
    } else if (pm25 <= 35 && pm25 > 15) {
      return Row(children: [
        Icon(Icons.sentiment_satisfied, size: 28, color: Colors.blue),
        SizedBox(width: 8),
        Text("보통", style: TextStyle(fontSize: 20, color: Colors.blue))
      ]);
    } else if (pm25 >= 75 && pm25 > 35) {
      return Row(children: [
        Icon(Icons.sentiment_very_dissatisfied, size: 28, color: Colors.red),
        SizedBox(width: 8),
        Text("매우 나쁨", style: TextStyle(fontSize: 20, color: Colors.red))
      ]);
    } else {
      return Row(children: [
        Icon(Icons.sick, size: 28, color: Colors.red[900]),
        SizedBox(width: 8),
        Text("나쁨", style: TextStyle(fontSize: 20, color: Colors.red[900]))
      ]);
    }
  }

  Stream<String> _fetchData() async* {
    while (true) {
      http.Response response = await http.get(Uri.parse(host));
      yield response.body;
      sleep(Duration(seconds: 3));
    }
  }
}
