import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailScreen extends StatefulWidget {
  String? name;
  String? phone;
  String? adres;
  String? loc;


  DetailScreen({required this.name, required this.phone, required this.adres, required this.loc});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller=WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://www.google.com/maps/@${widget.loc},18.76z?entry=ttu"));

    final coordinates = widget.loc!.split(',');

    final LatLng location = LatLng(
      double.parse(coordinates[0]),
      double.parse(coordinates[1]),
    );
    a = location;

  }

  late LatLng a;

  call() async {
    String tel = "tel:0${widget.phone}";
    try{
      await launchUrl(Uri.parse(tel));
    }catch(e){
      print(e.toString());
    }
  }
  void launchMap(String address) async {
    String query = Uri.encodeComponent(address);
    String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Haritalar açılamadı: $googleUrl';
    }
  }
  Completer<GoogleMapController> haritakontrol=Completer();

      @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
          title: const Text("Nöbetçi Eczane Uygulaması"),
      centerTitle: true,
      backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                          child: Image.asset("assets/logo.jpg"),
                        height: 90,
                        width: 80,
                      ),
                      Container(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(height: 5),
                            Text("${widget.name}",style: TextStyle(color: Colors.black87,fontSize: 26)),
                            SizedBox(height: 10),
                            GestureDetector(onTap: () {
                              call();
                            },child: Text("0${widget.phone}",style: TextStyle(color: Colors.blue,fontSize: 16))),
                            SizedBox(height: 10),
                            GestureDetector(onTap: () {
                              launchMap("${widget.loc}");
                            },child: Text("${widget.adres}",style: TextStyle(color: Colors.grey[700],fontSize: 14))),
                          ],
                        ),
                      ),
                    ],
                  ),
            ),
          ],
      )
      ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/2.16,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: a,zoom: 16),
              markers: Set<Marker>.of([
                Marker(markerId: MarkerId('locationMarker'), position: a),
              ]),
              onMapCreated: (GoogleMapController a){
                haritakontrol.complete(a);
              },
            ),
          ),
        ],
      ),
    );
  }
}
