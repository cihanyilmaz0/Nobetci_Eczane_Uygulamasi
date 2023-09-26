import 'package:eczane/models/citiesModel.dart';
import 'package:eczane/models/districtModel.dart';
import 'package:eczane/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CitiesScreen extends StatefulWidget {
  const CitiesScreen({Key? key}) : super(key: key);

  @override
  State<CitiesScreen> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
  final url = Uri.parse('https://api.kadircolak.com/Konum/JSON/API/ShowAllCity');
  List<Cities> sehirler = [];
  List<District> ilceler = [];

  String secilenSehir="";
  String secilenIlce="";
  String? gonderilecek;


  Future<void> loadCities() async {
    try {
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        var result = citiesFromJson(response.body);
        if (mounted) {
          setState(() {
            sehirler = result;
          });
        }
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> loadDistrict() async {
    try {
      final url2 = Uri.parse("https://api.kadircolak.com/Konum/JSON/API/ShowDistrict?plate=${secilenSehir}");
      http.Response response = await http.get(url2);
      
      if (response.statusCode == 200) {
        var result = districtFromJson(response.body);
        if (result.isNotEmpty) {
          setState(() {
            ilceler = result;
          });
        }
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('catch'+e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    loadCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
        ),
        toolbarHeight: MediaQuery.of(context).size.height*0.40,
        title: Column(
          children: [
            Padding(padding: EdgeInsets.only(bottom: 30),child: Image.asset("assets/logo.jpg",width: 100)),
            Text("Nöbetçi Eczaneler",style: TextStyle(fontSize: 30),),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text("Şehir Seçiniz:",style: TextStyle(color: Colors.black87,fontSize: 18,fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10,),
                    Container(
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(color: Colors.red),
                        color: Colors.transparent,
                      ),
                      child: DropdownButton<String>(
                        hint: Center(child: const Text("Seçiniz",style: TextStyle(color: Colors.black),)),
                        underline: SizedBox(),
                        isExpanded: true,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),
                        dropdownColor: Colors.white,
                        items: sehirler.map<DropdownMenuItem<String>>((Cities e) {
                          return DropdownMenuItem<String>(
                            child: Center(child: Text(e.text)),
                            onTap: () {
                              gonderilecek=e.text;
                              print(gonderilecek);
                            },
                            value: e.id.toString(),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          secilenIlce="";
                          setState(() {
                            secilenSehir=value!;
                            print(secilenSehir);
                            loadDistrict();
                          });
                        },
                        value: secilenSehir.isEmpty ? null : secilenSehir,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text("İlçe Seçiniz:",style: TextStyle(color: Colors.black87,fontSize: 18,fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                      child: DropdownButton<String>(
                        hint: Center(child: const Text("Seçiniz",style: TextStyle(color: Colors.black),)),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        dropdownColor: Colors.white,
                        isExpanded: true,
                        underline: SizedBox(),
                        style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),
                        onChanged: (String? ilce) {
                          setState(() {
                            secilenIlce=ilce!;
                            print(secilenIlce);
                          });
                        },
                        value: secilenIlce.isEmpty ? null : secilenIlce,
                        items: ilceler.map<DropdownMenuItem<String>>((District e) {
                          return DropdownMenuItem<String>(
                            child: Center(child: Text(e.district)),
                            value: e.district,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 130,
                height: 50,
                child: ElevatedButton(
                  child: Text("Ara",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))
                    ),
                    primary: Colors.red,
                  ),
                  onPressed: () {
                    if(secilenSehir=="" || secilenIlce==""){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Lütfen il ve ilçe seçin"),
                          duration: Duration(seconds: 3),
                        )
                      );
                    }else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              HomeScreen(
                                il: gonderilecek, ilce: secilenIlce,)));
                       }
                    },
                ),
              ),
            ],
          ),
        ),
    );
  }
}
