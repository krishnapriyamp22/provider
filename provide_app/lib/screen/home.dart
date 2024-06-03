// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:provide_app/database/crud.dart';
import 'package:provide_app/database/function.dart';
import 'package:provide_app/database/model.dart';
import 'package:provide_app/provider/helperclass.dart';
import 'package:provide_app/screen/add.dart';
import 'package:provide_app/widget/bottomsheet.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    getStudent();
    super.initState();
    searchControler.removeListener(() {
      searchText;
    });
  }
  final searchControler = TextEditingController();
  Timer? debouncer;
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(
                      MediaQuery.of(context).size.width, 70.0))),
        
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: SizedBox(
              height: 100,
              child: Container(
                width: double.infinity,
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    onChanged: (values) {
                      value.getsearchtext(values);
                      onSearchChange(values);
                    },
                    controller: searchControler,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(20)),
                      hintText: 'search Students...❔',
                      hintStyle: TextStyle(color: Colors.white),
                      suffixIcon: IconButton(
                          onPressed: () {
                            searchControler.clear();
                            value.getsearchtext('');
                            getStudent();
                          },
                          icon: Icon(Icons.close)),
                      prefixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {},
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: ValueListenableBuilder(
            valueListenable: studentlist,
            builder: (context, List<Studentupdates> students, Widget? child) {
              return studentlist.value.isEmpty
                  ? Expanded(
                      child: Container(
                        // height: 600,
                        //width: 400,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 1,
                              ),
                              Image.asset(
                                "images/Book.gif",
                                height: 200,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: GridView.builder(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: students.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                        mainAxisExtent: 305,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final studentdata = students.reversed.toList()[index];
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              bottomSheet(
                                  context,
                                  studentdata.name!,
                                  studentdata.course!,
                                  studentdata.sem!,
                                  studentdata.phone!,
                                  studentdata.age!,
                                  studentdata.address!,
                                  studentdata.image!);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: Color.fromARGB(255, 236, 228, 233),
                                ),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16.0),
                                        topRight: Radius.circular(16.0),
                                      ),
                                      child: Container(
                                        color: Colors.grey,
                                        child: Placeholder(
                                          child: Image.file(
                                            File(studentdata.image!),
                                            height: 170,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            studentdata.name!.toUpperCase(),
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          Text(
                                            studentdata.course!.toUpperCase(),
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.edit),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (reg) =>
                                                              DataInsert(
                                                                isEdit: true,
                                                                value:
                                                                    studentdata,
                                                              )));
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () {
                                                  delete(
                                                      context, studentdata.id);
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ));
            }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 87, 85, 254),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (reg) => DataInsert(
                        isEdit: false,
                      )),
            );
          },
        ),
      );
    });
  }


  onSearchChange(
    String values,
  ) {
    final studentdb = Hive.box<Studentupdates>('student');
    final students = studentdb.values.toList();
    values = searchControler.text;

    if (debouncer?.isActive ?? false) debouncer?.cancel();
    debouncer = Timer(Duration(milliseconds: 200), () {
      if (this.searchText != searchControler) {
        final filterdStudent = students
            .where((students) => students.name!
                .toLowerCase()
                .trim()
                .contains(values.toLowerCase().trim()))
            .toList();
        studentlist.value = filterdStudent;
      }
    });
  }
}