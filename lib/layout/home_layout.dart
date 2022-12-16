import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import '../modules/new_tasks/new_tasks_screen.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];
  late Database database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var titleController = TextEditingController();

  List<String> titles = [
    'Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  late bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetShown) {
            Navigator.pop(context);
            isBottomSheetShown = true;
            setState(() {
              fabIcon = Icons.edit;
            });

          } else {
            scaffoldKey.currentState!.showBottomSheet(
              (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [

              /*  defaultFormField(
                  controller: titleController,
                  type: TextInputType.text ,
                  validate: (String value)
                  {
                    if(value.isEmpty)
                      {
                        return 'title must not be empty';
                      }
                    return value;
                  },
                  label: 'Task Title',
                  prefix: Icons.title ,
                ),
                */



                ],
              ),
            );
            isBottomSheetShown = false ;
            setState(() {
              fabIcon = Icons.add;
            });

          }
        },
        child:  Icon(
          fabIcon,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
            ),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check_circle_outline,
            ),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.archive_outlined,
            ),
            label: 'Archived',
          ),
        ],
      ),
    );
  }

  Future<String> getName() async {
    return '';
  }

  void createDatabase() async {
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
                'create table tasks (id INTEGER PRIMARY KEY, title TEXT, data TEXT, time TEXT, stats TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error When Creating Table');
        });
      },
      onOpen: (database) {
        print('database opened');
      },
    );
  }

  void insertToDatabase() {
    database.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks(title, data,time,status)VALUES("first task ","02222,"88","new")')
          .then((value) {
        print('$value inserted successfully');
      }).catchError((error) {
        print('Error When Inserting NEW Record ${error.toString()}');
      });
    });
  }
}
