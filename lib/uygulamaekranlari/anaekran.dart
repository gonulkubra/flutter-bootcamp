// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:testui2/servisler/weather_data.dart';
import 'package:testui2/sabitler/sehirler.dart';
import 'package:testui2/sabitler/kalicisabitler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:testui2/servisler/weather_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var city = "Istanbul";
  var data;
  // late Weather passData;
  late Future<Weather> futureWeather;

  info() async {
    data = await getWeather(city);
    return data;
  }

  void updateInfo(city) async {
    futureWeather = getWeather(city);
  }

  @override
  void initState() {
    super.initState();
    futureWeather = getWeather(city);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.blue[100],
        body: FutureBuilder(
          future: futureWeather,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //passData = snapshot.data;
              return Container(
                child: Column(
                  children: [
                    dropdown(),
                    citycard(size, snapshot),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return Text('ya bu isler ne');
            }
          },
        ));
  }

  Padding dropdown() {
    return Padding(
      padding: const EdgeInsets.only(top: 37.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pin_drop),
          SizedBox(width: 5),
          DropdownButtonHideUnderline(
            child: DropdownButton(
                value: city,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: cities.map((String location) {
                  return DropdownMenuItem(
                      value: location, child: Text(location));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    city = newValue!;
                    updateInfo(city);
                  });
                }),
          ),
        ],
      ),
    );
  }

  Padding citycard(Size size, snapshot) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Container(
        height: size.height * 0.8,
        width: size.width,
        margin: EdgeInsets.only(right: 1, left: 1),
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(40),
            gradient: LinearGradient(
                colors: [Color(0xff955cd1), Color(0xff3fa2fa)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.3, 0.7])),
        child: Column(
          children: [
            SizedBox(height: 12),
            sehirisimalani(snapshot),
            ulke(snapshot),
            SizedBox(height: 4),
            tarih(),
            SizedBox(height: 15),
            havaiconu(size, snapshot),
            SizedBox(height: 3),
            havadurumu(snapshot),
            SizedBox(height: 30),
            iconlar(size, snapshot),
            /* SizedBox(height: 12),
            otomattext() */
          ],
        ),
      ),
    );
  }

  Text ulke(snapshot) => Text("${snapshot.data!.country}");

  Padding sehirisimalani(snapshot) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: sehiradi(snapshot),
    );
  }

  Image havaiconu(Size size, snapshot) {
    print(snapshot.data!.icon);
    try {
      String iconUrl = snapshot.data!.icon;
      print(iconUrl);
    } catch (e) {
      print("olduramadim");
    }
    //String iconUrl = data?.icon;
    //String iconPath = iconUrl.substring(iconUrl.length - 7);
    if (snapshot.data!.icon == null) {
      return Image(
        image: AssetImage('assets/weather/day/119.png'),
      );
    } else if (snapshot.data!.isDay == 0) {
      return Image(
        image: AssetImage('assets/weather/night/113.png'),
      );
    } else {
      return Image(
        image: AssetImage('assets/weather/day/113.png'),
      );
    }
  }

  Padding iconlar(Size size, snapshot) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ilksutun(size, snapshot),
          ikincisutun(size, snapshot),
          ucuncusutun(size, snapshot),
        ],
      ),
    );
  }

  /* Padding otomattext() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: TextButton(
          onPressed: () => Navigator.pushNamed(context, "/AutomatScreen"),
          child: Text(
            "Otomatların stok durumunu görmek için tıklayın",
            style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.8)),
          )),
    );
  } */
  Column ilksutun(Size size, snapshot) {
    return Column(
      children: [
        Text(
          "Temperature",
          style: TextStyle(
              fontFamily: 'Archivo',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.5)),
        ),
        SizedBox(height: 8),
        sicaklik(snapshot),
        SizedBox(height: 15),
        ruzgaricon(size),
        SizedBox(height: 10),
        ruzgarhizi(snapshot),
        SizedBox(height: 10),
        ruzgaryazi(),
        SizedBox(height: 15),
        gozlukIcon(size),
        SizedBox(height: 10),
        gozlukDurum(),
        SizedBox(height: 10),
        gozlukYazi(),
      ],
    );
  }

  Column ikincisutun(Size size, snapshot) {
    return Column(
      children: [
        Text(
          "UV",
          style: TextStyle(
              fontFamily: 'Archivo',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.5)),
        ),
        SizedBox(height: 8),
        uvdegeri(snapshot),
        SizedBox(height: 15),
        nemiconu(size),
        SizedBox(height: 10),
        nemdegeri(snapshot),
        SizedBox(height: 10),
        nemyazi(),
        SizedBox(height: 15),
        sapkaIconu(size),
        SizedBox(height: 10),
        sapkaDurum(),
        SizedBox(height: 10),
        sapkaYazi(),
      ],
    );
  }

  Column ucuncusutun(Size size, snapshot) {
    return Column(
      children: [
        Text(
          "SPF",
          style: TextStyle(
              fontFamily: 'Archivo',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.5)),
        ),
        SizedBox(height: 8),
        spfdegeri(snapshot),
        SizedBox(height: 15),
        evdekalicon(size, snapshot),
        SizedBox(height: 10),
        evdekalDurum(snapshot),
        SizedBox(height: 10),
        evdekalYazi(),
        SizedBox(height: 15),
        semsiyeIcon(size),
        SizedBox(height: 10),
        semsiyeDurum(),
        SizedBox(height: 10),
        semsiyeYazi(),
      ],
    );
  }

  Text spfdegeri(snapshot) {
    String spfvalue;
    double uv = snapshot.data!.uv;
    if (uv <= 1) {
      spfvalue = "0";
    } else if (uv < 3) {
      spfvalue = "15";
    } else if (uv <= 5) {
      spfvalue = "30";
    } else if (uv <= 7) {
      spfvalue = "50";
    } else {
      spfvalue = "50+";
    }
    return Text(
      "SPF $spfvalue",
      style: TextStyle(
          fontFamily: 'Archivo',
          fontSize: 37,
          fontWeight: FontWeight.w600,
          color: Colors.white.withOpacity(0.7)),
    );
  }

  Text evdekalYazi() {
    return Text(
      "Status",
      style: TextStyle(
          fontFamily: 'Archivo',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white.withOpacity(0.45)),
    );
  }

  Text semsiyeYazi() {
    return Text(
      "Tip Note",
      style: TextStyle(
          fontFamily: 'Archivo',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white.withOpacity(0.45)),
    );
  }

  Text evdekalDurum(snapshot) {
    String statusText;
    double uv = snapshot.data!.uv;
    int isDay = snapshot.data!.isDay;
    if (isDay == 0) {
      statusText = "Drink Water";
    } else if (uv <= 3) {
      statusText = "Sunbath";
    } else if (uv <= 7) {
      statusText = "Drink Water";
    } else {
      statusText = "Stay at Home";
    }

    return Text(
      statusText,
      style: TextStyle(
          fontFamily: 'Archivo',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white.withOpacity(0.85)),
    );
  }

  Text semsiyeDurum() {
    return Text(
      "Under Shade",
      style: TextStyle(
          fontFamily: 'Archivo',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white.withOpacity(0.85)),
    );
  }

  FaIcon evdekalicon(Size size, snapshot) {
    double uv = snapshot.data!.uv;
    int isDay = snapshot.data!.isDay;
    if (isDay == 0) {
      return FaIcon(
        FontAwesomeIcons.glassWaterDroplet,
        size: 45,
      );
    } else if (uv <= 3) {
      return FaIcon(
        FontAwesomeIcons.sun,
        size: 45,
      );
    } else if (uv <= 7) {
      return FaIcon(
        FontAwesomeIcons.glassWaterDroplet,
        size: 45,
      );
    } else {
      return FaIcon(
        FontAwesomeIcons.couch,
        size: 45,
      );
    }
  }

  FaIcon semsiyeIcon(Size size) {
    return FaIcon(
      FontAwesomeIcons.umbrellaBeach,
      size: 45,
    );
  }

  Text nemyazi() {
    return Text(
      "Humidity",
      style: TextStyle(
          fontFamily: 'Archivo',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white.withOpacity(0.45)),
    );
  }

  Text sapkaYazi() {
    return Text(
      "Tip Note",
      style: TextStyle(
          fontFamily: 'Archivo',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white.withOpacity(0.45)),
    );
  }

  Text nemdegeri(snapshot) {
    return Text(
      "%${snapshot.data!.humidity}",
      style: TextStyle(
          fontFamily: 'Archivo',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white.withOpacity(0.85)),
    );
  }

  Text sapkaDurum() {
    return Text(
      "Wear a Hat",
      style: TextStyle(
          fontFamily: 'Archivo',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white.withOpacity(0.85)),
    );
  }

  Icon nemiconu(Size size) {
    return Icon(
      Icons.water_drop_rounded,
      size: 45,
    );
  }

  FaIcon sapkaIconu(Size size) {
    return FaIcon(
      FontAwesomeIcons.redhat,
      size: 45,
    );
  }

  Text uvdegeri(snapshot) {
    return Text(
      "${snapshot.data!.uv}",
      style: TextStyle(
          fontFamily: 'Archivo',
          fontSize: 37,
          fontWeight: FontWeight.w600,
          color: Colors.white.withOpacity(0.7)),
    );
  }

  Text ruzgaryazi() {
    return Text(
      "Wind",
      style: TextStyle(
          fontFamily: 'Archivo',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white.withOpacity(0.45)),
    );
  }

  Text gozlukYazi() {
    return Text(
      "Tip Note",
      style: TextStyle(
          fontFamily: 'Archivo',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white.withOpacity(0.45)),
    );
  }

  Text ruzgarhizi(snapshot) {
    return Text(
      "${snapshot.data!.wind} km/s",
      style: TextStyle(
        fontFamily: 'Archivo',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white.withOpacity(0.85),
      ),
    );
  }

  Text gozlukDurum() {
    return Text(
      "Sunglasses",
      style: TextStyle(
        fontFamily: 'Archivo',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white.withOpacity(0.85),
      ),
    );
  }

  FaIcon ruzgaricon(Size size) {
    return FaIcon(
      FontAwesomeIcons.wind,
      size: 45,
    );
  }

  FaIcon gozlukIcon(Size size) {
    return FaIcon(
      FontAwesomeIcons.glasses,
      size: 45,
    );
  }

  Text sicaklik(snapshot) {
    return Text(
      "${snapshot.data!.temp}°C",
      style: TextStyle(
        fontFamily: 'Archivo',
        fontSize: 37,
        fontWeight: FontWeight.w600,
        color: Colors.white.withOpacity(0.7),
      ),
    );
  }

  Text havadurumu(snapshot) {
    return Text(
      "${snapshot.data!.condition}",
      style: TextStyle(
          fontFamily: 'Archivo', fontSize: 18, fontWeight: FontWeight.w600),
    );
  }

  Text tarih() {
    return Text(dateformat,
        style: TextStyle(
            fontFamily: 'Archivo', fontSize: 18, fontWeight: FontWeight.w400));
  }

  Text sehiradi(snapshot) {
    return Text(
      "${snapshot.data!.cityname}",
      style: TextStyle(
        fontFamily: 'Rajdhani',
        color: Colors.white,
        fontSize: 40,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
