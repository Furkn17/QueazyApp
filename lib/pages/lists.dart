import 'package:flutter/material.dart';
import 'package:kelime_ezberleme_uyg/global_widget/app_bar.dart';
import 'package:kelime_ezberleme_uyg/global_widget/toast.dart';
import 'package:kelime_ezberleme_uyg/pages/create_list.dart';
import 'package:kelime_ezberleme_uyg/pages/words.dart';
import 'package:kelime_ezberleme_uyg/sipsak_method.dart';
import 'package:kelime_ezberleme_uyg/db/db/db.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({super.key});

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {

  List<Map<String,Object?>> _lists = [];

  bool pressController = false;

  List<bool> deleteIndex_List = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLists();
  }

  void getLists() async
  {
  _lists = await DB.instance.readListAll();
  for(int i=0 ; i<_lists.length ; ++i)
    {
      deleteIndex_List.add(false);
    }
  setState(() {
    _lists;
  });

  }

void delete() async
{
  List<int> removeIndexList = [];
  for(int i=0;i<_lists.length;++i)
    {
      if(deleteIndex_List[i] == true)
        {
          removeIndexList.add(i);
        }
    }
  for (int i=removeIndexList.length-1; i>=0;--i)
    {
      DB.instance.deleteListAndWordByList(_lists[removeIndexList[i]]['list_id'] as int);
      _lists.removeAt(removeIndexList[i]);
      deleteIndex_List.removeAt(removeIndexList[i]);
    }

  setState(() {
    _lists;
    deleteIndex_List;
    pressController = false;
  });

  toastMessage("Seçili listeler silindi");
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context,
          left: const Icon(Icons.arrow_back_ios_new,color: Colors.black,size: 22,),
    center: Image.asset("assets/images/lists.png"),
        right: pressController != true? Image.asset("assets/images/logo.png",height: 35,width: 35,):InkWell(
          onTap: delete,
          child: Icon(Icons.delete,color: Colors.deepPurpleAccent,size: 24,),
        ),
leftWidgetOnClick: ()=>{
        Navigator.pop(context)
}
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateList()));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.purple.withOpacity(0.5),
      ),
      body: SafeArea(
        child: ListView.builder(itemBuilder: (context,index){
          return listItem(_lists[index]!['list_id'] as int,index,listName: _lists[index]['name'].toString(),sumWords:_lists[index]['sum_word'].toString(),sumUnlearned: _lists[index]['sum_unlearned'].toString());
        },itemCount: _lists.length,)
      )
    );
  }

  InkWell listItem(int id,int index,{@required String ?listName,@required String ?sumWords, @required String ?sumUnlearned}) {
    return InkWell(
      onTap: (){
        debugPrint(id.toString());
        Navigator.push(context, MaterialPageRoute(builder: (context)=>WordsPage(id,listName))).then((value){
          getLists();
        });
      },

      onLongPress: (){
        setState(() {
          pressController = true;
          deleteIndex_List[index] = true;
        });

      },

      child: Center(
              child: Container(
                width: double.infinity,
                child: Card(
                  color: Color(SipsakMethod.HexaColorConverter("#dcd2ff")),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                  margin: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 15,top: 5),
                              child: Text(listName!,style: TextStyle(color: Colors.black,fontSize: 16,fontFamily: "RobotoMedium"),)),
                          Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Text(sumWords! + " terim ",style: TextStyle(color: Colors.black,fontSize: 14,fontFamily: "RobotoRegular"),)),
                          Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Text((int.parse(sumWords) - int.parse(sumUnlearned!)).toString() + " öğrenildi",style: TextStyle(color: Colors.black,fontSize: 14,fontFamily: "RobotoRegular"),)),
                          Container(
                              margin: EdgeInsets.only(left: 30,bottom: 5),
                              child: Text(sumUnlearned + " öğrenilmedi",style: TextStyle(color: Colors.black,fontSize: 14,fontFamily: "RobotoRegular"),))
                        ],
                      ),
                      pressController==true?Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.deepPurpleAccent,
                        hoverColor: Colors.blueAccent,
                        value: deleteIndex_List[index],
                        onChanged: (bool? value){
                          setState(() {
                            deleteIndex_List[index] = value!;

                            bool deleteProcessController = false;
                            deleteIndex_List.forEach((element){

                              if (element == true )
                                deleteProcessController = true;

                            });

                            if(!deleteProcessController)
                              pressController = false;

                          });

                        },
                      ):Container()
                    ],
                  )
                ),
              ),
            ),
    );
  }
}
