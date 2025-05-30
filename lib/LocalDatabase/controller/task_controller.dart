import 'package:get/get.dart';
import 'package:smart_leader/LocalDatabase/Db/dp_helper.dart';
import 'package:smart_leader/LocalDatabase/modals/Task.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {

    print('Task ${task!.toJson()}');
    return await DBHelper.insert(task);
  }

  // get all the data from table

  void getTasks() async {

    print("Printmap");
    List<Map<String, dynamic>> tasks = await DBHelper.getData();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }
}
