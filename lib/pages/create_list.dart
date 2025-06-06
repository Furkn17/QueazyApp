
import 'package:flutter/material.dart';
import 'package:kelime_ezberleme_uyg/db/db/db.dart';
import 'package:kelime_ezberleme_uyg/db/models/words.dart';
import 'package:kelime_ezberleme_uyg/global_widget/app_bar.dart';
import 'package:kelime_ezberleme_uyg/sipsak_method.dart';
import 'package:fluttertoast/fluttertoast.dart';


import '../db/models/lists.dart';
import '../global_widget/text_field_builder.dart';
import '../global_widget/toast.dart';

class CreateList extends StatefulWidget {
  const CreateList({super.key});

  @override
  State<CreateList> createState() => _CreateListState();
}

class _CreateListState extends State<CreateList> {

  final _listName = TextEditingController();

  List<TextEditingController> wordTextEditingList = [];
  List<Row> wordListField = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < 10; ++i) {
      wordTextEditingList.add(TextEditingController());
    }

    for (int i = 0; i < 5; ++i) {
      wordListField.add(
          Row(
            children: [
              Expanded(child: textFieldBuilder(
                  textEditingController: wordTextEditingList[2 * i])),
              Expanded(child: textFieldBuilder(
                  textEditingController: wordTextEditingList[2 * i + 1])),

            ],
          )
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context,
        left: const Icon(Icons.arrow_back_ios_new, color: Colors.black,
          size: 22,),
        center: Image.asset("assets/images/logo_text.png"),
        right:
        Image.asset("assets/images/logo.png", height: 35, width: 35,),
        leftWidgetOnClick: () => Navigator.pop(context),
      ),


      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              textFieldBuilder(icon: Icon(Icons.list, size: 18),
                  hintText: "Liste Adı",
                  textEditingController: _listName,
                  textAlign: TextAlign.left),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("İngilizce", style: TextStyle(
                        fontSize: 18, fontFamily: "RobotoRegular"),),
                    Text("Türkçe", style: TextStyle(
                        fontSize: 18, fontFamily: "RobotoRegular"))
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: wordListField,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  actionBtn(addRow, Icons.add),
                  actionBtn(save, Icons.save),
                  actionBtn(deleteRow, Icons.remove),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  InkWell actionBtn(Function() click, IconData icon) {
    return InkWell(
      onTap: () => click(),
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.only(bottom: 10, top: 5),
        child: Icon(icon, size: 28,),
        decoration: BoxDecoration(
            color: Color(SipsakMethod.HexaColorConverter("#dcd2ff")),
            shape: BoxShape.circle
        ),
      ),
    );
  }

  void addRow() {
    wordTextEditingList.add(TextEditingController());
    wordTextEditingList.add(TextEditingController());

    wordListField.add(
        Row(
          children: [
            Expanded(child: textFieldBuilder(
                textEditingController: wordTextEditingList[wordTextEditingList
                    .length - 2])),
            Expanded(child: textFieldBuilder(
                textEditingController: wordTextEditingList[wordTextEditingList
                    .length - 1])),

          ],
        )
    );

    setState(() => wordListField);
  }

  void save() async
  {
    if (!_listName.text.isEmpty) {
      int counter = 0;
      bool notEmptyPair = false;

      for (int i = 0; i < wordTextEditingList.length / 2; ++i) {
        String eng = wordTextEditingList[2 * i].text;
        String tr = wordTextEditingList[2 * i + 1].text;

        if (!eng.isEmpty && !tr.isEmpty) {
          counter++;
        }
        else {
          notEmptyPair = true;
        }
      }

      if (counter >= 4) {
        if (!notEmptyPair) {
          Lists addedList = await DB.instance.insertList(
              Lists(name: _listName.text));

          for (int i = 0; i < wordTextEditingList.length / 2; ++i) {
            String eng = wordTextEditingList[2 * i].text;
            String tr = wordTextEditingList[2 * i + 1].text;

            Word word = await DB.instance.insertWord(Word(list_id: addedList.id,
                word_eng: eng,
                word_tr: tr,
                status: false));
            debugPrint(
                word.id.toString() + " " + word.list_id.toString() + " " +
                    word.word_eng.toString() + " " + word.word_tr.toString() +
                    " " + word.status.toString());
          }

          toastMessage("Liste oluşturuldu");

          _listName.clear();
          wordTextEditingList.forEach((element) {
            element.clear();
          });
        }
        else {
          toastMessage("Boş alanları doldurun veya silin");
        }
      }
      else {
        toastMessage("Minimum 4 çift dolu olmalıdır.");
      }
    }

    else {
      toastMessage("Lütfen, liste adını girin.");
    }
  }

  void deleteRow() {
    if (wordListField.length != 4) {
      wordTextEditingList.removeAt(wordTextEditingList.length - 1);
      wordTextEditingList.removeAt(wordTextEditingList.length - 1);

      wordListField.removeAt(wordListField.length - 1);
      setState(() => wordListField);
      ;
    }
    else {
      toastMessage("Minimum 4 çift gereklidir ");
    }
  }

  }

