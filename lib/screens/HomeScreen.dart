import 'package:eczane/models/eczaneModel.dart';
import 'package:eczane/screens/DetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  String? il;
  String? ilce;


  HomeScreen({required this.il, required this.ilce});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final headers = {
    'authorization': 'apikey 4dXRW9rjmMnIwh4l3jEGsZ:2kHwvI9yMsveUWWv3dq39S',
    'content-type': 'application/json',
  };

  List<ResultClass> eczaneResult = [];

  @override
  void initState() {
    super.initState();
    loadEczane();
    print(widget.il);
    print(widget.ilce);
  }

  Future<void> loadEczane() async {
    final params = {
      'ilce': widget.ilce,
      'il': widget.il,
    };
    final url = Uri.parse('https://api.collectapi.com/health/dutyPharmacy')
        .replace(queryParameters: params);
    try {
      http.Response response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var result = eczaneFromJson(response.body);
        setState(() {
          eczaneResult = result.result.map((item) => ResultClass.fromJson(item)).toList();
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  String? name;
  String? adres;
  String? phone;
  String? loc;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nöbetçi Eczane Uygulaması"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                  itemCount: eczaneResult.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: () {
                          name=eczaneResult[index].name;
                          phone=eczaneResult[index].phone;
                          adres=eczaneResult[index].address;
                          loc=eczaneResult[index].loc;
                          Get.to(()=>DetailScreen(name: name, phone: phone, adres: adres, loc: loc),transition: Transition.downToUp);
                       },
                        child: SizedBox(
                          height: 120,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10,right: 10,top: 10),
                            child: Card(
                              color: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: ListTile(
                                  title: Text(eczaneResult[index].name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                  contentPadding: EdgeInsets.all(15),
                                  subtitle: Padding(padding: EdgeInsets.only(top:10),child: Text(eczaneResult[index].address,style:TextStyle(fontSize: 15))),
                                ),
                              ),
                          ),
                        ),
                        ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
