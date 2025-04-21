import 'package:flutter/material.dart';
import 'package:kelime_ezberleme_uyg/db/models/words.dart';
import 'package:kelime_ezberleme_uyg/global_widget/app_bar.dart';
import 'package:kelime_ezberleme_uyg/global_widget/toast.dart';
import 'package:kelime_ezberleme_uyg/sipsak_method.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../db/db/db.dart';
import '../global_variable.dart';

class WordsCardsPage extends StatefulWidget {
  const WordsCardsPage({super.key});

  @override
  _WordsCardsPageState createState() => _WordsCardsPageState();
}

enum Which { learned, unlearned, all }

enum forWhat { forList, forListMixed }

class _WordsCardsPageState extends State<WordsCardsPage> {
  Which? _chooseQueastionType = Which.learned;
  bool listMixed = true;
  List<Map<String, Object?>> _lists = [];
  List<bool> selectedListIndex = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLists();
  }

  void getLists() async {
    _lists = await DB.instance.readListAll();

    for (int i = 0; i < _lists.length; ++i) {
      selectedListIndex.add(false);
    }

    setState(() {
      _lists;
    });
  }
  List<Word> _words = [];
  bool start = false;

  List<bool> changeLang =[];


  void getSelectedWordOfLists(List<int> selectedListID)async
  {
    if(_chooseQueastionType == Which.learned)
      {
        _words=await DB.instance.readWordByLists(selectedListID,status: true);
      }
    else if (_chooseQueastionType == Which.unlearned)
    {
      _words=await DB.instance.readWordByLists(selectedListID,status: false);
    }
    else
      {
        _words=await DB.instance.readWordByLists(selectedListID);
      }

    if(_words.isNotEmpty)
      {

        for(int i=0;i<_words.length;++i)
          {
            changeLang.add(true);
          }


        if(listMixed) _words.shuffle();
        start=true;


        setState(() {
          _words;
          start;
        });
      }
    else
      {
        toastMessage("Seçilen şartlarda liste boş");
      }




  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context,
        left: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 22),
        center: const Text(
          "Kelime kartları",
          style: TextStyle(fontFamily: "Carter", color: Colors.black, fontSize: 22),
        ),
        leftWidgetOnClick: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: start == false? Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
          padding: const EdgeInsets.only(left: 4, top: 10, right: 4),
          decoration: BoxDecoration(
            color: Color(SipsakMethod.HexaColorConverter("#DCD2FF")),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              whichRadioButton(text: "Öğrenmediklerimi sor", value: Which.unlearned),
              whichRadioButton(text: "Öğrendiklerimi sor", value: Which.learned),
              whichRadioButton(text: "Hepsini sor", value: Which.all),
              checkBox(text: "Listeyi karıştır",fWhat: forWhat.forListMixed),
              SizedBox(height: 20),
              const Divider(color: Colors.black, thickness: 1),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  "Listeler",
                  style: const TextStyle(
                    fontFamily: "RobotoRegular",
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8, right: 8, bottom: 10, top: 10),
                height: 200,
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
                child: Scrollbar(
                  thickness: 5,
                  thumbVisibility: true,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return checkBox(index: index,text: _lists[index]['name'].toString());
                    },
                    itemCount: _lists.length,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(right: 20),
                child: InkWell(
                  onTap: () {
                    List<int> selectedIndexNoOfLis = [];
                    for(int i=0; i<selectedListIndex.length;++i)
                      {
                        if(selectedListIndex[i] == true)
                          {
                            selectedIndexNoOfLis.add(i);
                          }
                      }

                    List<int> selectedListIdList = [];

                    for(int i=0; i<selectedIndexNoOfLis.length;++i)
                    {
                      selectedListIdList.add(_lists[selectedIndexNoOfLis[i]]['list_id'] as int);
                    }
                    if(selectedListIdList.isNotEmpty)
                      {
                        getSelectedWordOfLists(selectedListIdList);
                      }
                    else
                      {
                        toastMessage("Lütfen, liste seç");
                      }
                  },
                  child: const Text(
                    "Başla",
                    style: TextStyle(
                      fontFamily: "RobotoRegular",
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ):CarouselSlider.builder(
          options: CarouselOptions(
            height: double.infinity,
          ),
          itemCount: _words.length,
          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex){

            String word = "";

            if(chooseLang == Lang.tr)
              {
                word = changeLang[itemIndex]?(_words[itemIndex].word_tr!):(_words[itemIndex].word_eng!);
              }
            else
              {
                word = changeLang[itemIndex]?(_words[itemIndex].word_eng!):(_words[itemIndex].word_tr!);

              }


            return Column(
              children: [
            Expanded(
              child: Stack(
              children: [
              InkWell(
              onTap: (){
                if(changeLang[itemIndex] == true)
                {
                  changeLang[itemIndex] = false;
                }
                else
                {
                  changeLang[itemIndex] = true;
                }
              
                setState(() {
                  changeLang[itemIndex];
                });
              
              },
              child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              margin: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
              padding: const EdgeInsets.only(left: 4, top: 10, right: 4),
              decoration: BoxDecoration(
              color: Color(SipsakMethod.HexaColorConverter("#DCD2FF")),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Text(word,style: const TextStyle(fontFamily: "RobotoRegular",fontSize: 28,color: Colors.black),),
              
              ),
              ),
              Positioned(child: Text((itemIndex+1).toString()+"/"+(_words.length).toString(),style: TextStyle(fontFamily: "RobotoRegular",fontSize: 16,color: Colors.black),),left: 30,top: 10,)
              ],
              ),
            ),
                SizedBox(
                  width: 170,
                    child: CheckboxListTile(
                      title: Text("Öğrendim"),
                      value: _words[itemIndex].status,
                      onChanged: (value){
                        _words[itemIndex] = _words[itemIndex].copy(status: value);
                        DB.instance.markAsLearned(value!,_words[itemIndex].id as int);
                        toastMessage(value? "Öğrenildi olarak işaretlendi": "Öğrenilmedi olarak işaretlendi");

                        setState(() {
                          _words[itemIndex];
                        });
                      },
                    ),
                )
              ],
            );
    },

      ),)
    );
  }

  SizedBox whichRadioButton({@required String? text, @required Which? value}) {
    return SizedBox(
      width: double.infinity,
      height: 32,
      child: ListTile(
        title: Text(
          text!,
          style: const TextStyle(fontFamily: "RobotoRegular", fontSize: 18),
        ),
        leading: Radio<Which>(
          value: value!,
          groupValue: _chooseQueastionType,
          onChanged: (Which? value) {
            setState(() {
              _chooseQueastionType = value;
            });
          },
        ),
      ),
    );
  }

  SizedBox checkBox({int index=0 ,String? text, forWhat fWhat = forWhat.forList}) {
    return SizedBox(
      width: 270,
      height: 33,
      child: ListTile(
        title: Text(
          text!,
          style: const TextStyle(fontFamily: "RobotoRegular", fontSize: 18),
        ),
        leading: Checkbox(
          checkColor: Colors.white,
          activeColor: Colors.deepPurpleAccent,
          hoverColor: Colors.blueAccent,
          value: fWhat==forWhat.forList ?selectedListIndex[index]:listMixed,
          onChanged: (bool? value) {

            setState(() {
              if(fWhat == forWhat.forList)
              {
                selectedListIndex[index] = value!;
              }
              else
              {
                listMixed = value!;
              }
            });


          },
        ),
      ),
    );
  }
}
