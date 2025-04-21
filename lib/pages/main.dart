import 'package:flutter/material.dart';
import 'package:kelime_ezberleme_uyg/global_widget/app_bar.dart';
import 'package:kelime_ezberleme_uyg/pages/lists.dart';
import 'package:kelime_ezberleme_uyg/pages/multiple_choice.dart';
import 'package:kelime_ezberleme_uyg/pages/words_card.dart';
import 'package:kelime_ezberleme_uyg/sipsak_method.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../global_variable.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

final Uri _url = Uri.parse('https://www.udemy.com');
class _MainPageState extends State<MainPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PackageInfo ?packageInfo;
  String version = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    packageInfoInit();
  }


  void packageInfoInit() async
  {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo!.version;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width*0.5,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image.asset("assets/images/logo.png",height: 80,),
                  Text("QUEZY",style: TextStyle(fontFamily: "RobotoLight",fontSize: 26),),
                  Text("İstediğini öğren",style: TextStyle(fontFamily: "RobotoLight",fontSize: 16),),
                  SizedBox(
                      width: MediaQuery.of(context).size.width*0.35,
                      child: Divider(color: Colors.black,)),
                  Container(
                      margin: EdgeInsets.only(top: 50,right: 8,left: 8),
                      child: Text("Bu uygulamanın nasıl yapıldığını öğrenmek ve bu tarz uygulamalar geliştirmek için ",style: TextStyle(fontFamily: "RobotoLight",fontSize: 16),textAlign: TextAlign.center,)),
                  InkWell(
                      onTap: () async {
                        if (!await launchUrl(_url)) {
                        throw Exception('Could not launch $_url');
                        }
                      },
                      child: Text("Tıkla",style: TextStyle(fontFamily: "RobotoLight",fontSize: 16,color: Color(SipsakMethod.HexaColorConverter("#0a588d"))),)),

                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("v" + version + "\nfurknaylmz@gmail.com",style: TextStyle(fontFamily: "RobotoLight",fontSize: 14,color: Color(SipsakMethod.HexaColorConverter("#0a588d"))),textAlign: TextAlign.center,),
              ),


            ],
          ),
        ),
      ),
      appBar: appBar(context,
          left: const FaIcon(FontAwesomeIcons.bars,color: Colors.black,size: 20,),
          center: Image.asset("assets/images/logo_text.png"),
          leftWidgetOnClick: ()=>{_scaffoldKey.currentState!.openDrawer()}
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                langRadioButton(
                  text: "İngilizce - Türkçe",
                  group: chooseLang,
                  value: Lang.en,
                ),
                langRadioButton(
                  text: "Türkçe - İngilizce",
                  group: chooseLang,
                  value: Lang.tr),
                SizedBox(height: 25,),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const ListsPage()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 55,
                    margin: EdgeInsets.only(bottom: 20),
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Color(SipsakMethod.HexaColorConverter("#7d20a6")),
                          Color(SipsakMethod.HexaColorConverter("#481183")),
                        ],
                        // Gradient from https://learnui.design/tools/gradient-generator.html
                        tileMode: TileMode.mirror,
                      ),
                    ),
                    child: Text(
                      "Listelerim",
                      style: TextStyle(
                        fontSize: 28,
                        fontFamily: "Carter",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      card(
                        context,
                        startColor: "#1dacc9",
                        endColor: "#0c33b2",
                        title: "Kelime\nKartları",click: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const WordsCardsPage()));

                      }



                      ),
                      card(
                        context,
                        startColor: "#ff3348",
                        endColor: "#b029b9",
                        title: "Çoktan\nSeçmeli",click: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const MultipleChoicePage()));

                      }
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell card(
    BuildContext context, {
    @required String? startColor,
    @required String? endColor,
    @required String? title,
    @required Function ?click,
  }) {
    return InkWell(
      onTap: ()=>click!(),
      child: Container(
        alignment: Alignment.center,
        height: 200,
        width: MediaQuery.of(context).size.width * 0.37,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(SipsakMethod.HexaColorConverter(startColor!)),
              Color(SipsakMethod.HexaColorConverter(endColor!)),
            ],
            // Gradient from https://learnui.design/tools/gradient-generator.html
            tileMode: TileMode.mirror,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              title!,
              style: TextStyle(
                fontSize: 28,
                fontFamily: "Carter",
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            Icon(Icons.file_copy, size: 32, color: Colors.white),
          ],
        ),
      ),
    );
  }

  SizedBox langRadioButton({
    @required String? text,
    @required Lang? value,
    @required Lang? group,
  }) {
    return SizedBox(
      width: 250,
      height: 30,
      child: ListTile(
        title: Text(text!,style: TextStyle(fontFamily: "Carter",fontSize: 15),),
        leading: Radio<Lang>(
          value: value!,
          groupValue: chooseLang,
          onChanged: (Lang? value) {
            setState(() {
              chooseLang = value;
            });
          },
        ),
      ),
    );
  }
}
