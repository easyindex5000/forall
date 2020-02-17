import 'package:big/Widgets/dataManager.dart';
import 'package:big/model/wuzzef/job.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

enum CareerLevel { student, entry_level, experienced, manger, ceo }
enum JobType {
  fullTime,
  partTime,
  freelance,
  internship,
  shiftBased,
  volunteer
}

class WuzzefProvider extends ChangeNotifier{
  List<CareerLevel> selectedCareerLevels = [];
  List<JobType> selectedJobTypes = [];
  DatabaseManager db=DatabaseManager();

  Future getFavorite()async
  {
    return (await db.getallRows(db.wuzzefTable)).map((value){
      print(value);
      return value["id"];
    }).toList();

  }


  Future saveItem(Job job)async
  {
await db.insertData(db.wuzzefTable, job.toJson());

  }
  Future deleteItem(int id)async
  {
print(await db.deleteItem(db.wuzzefTable,id));

  }
  onCareerLevelTap(CareerLevel careerLevel) {
    if (selectedCareerLevels.contains(careerLevel)) {
      selectedCareerLevels.remove(careerLevel);
    } else {
      selectedCareerLevels.add(careerLevel);
    }
    notifyListeners();
  }
    onJobTypeTap(JobType jobType) {
    if (selectedJobTypes.contains(jobType)) {
      selectedJobTypes.remove(jobType);
    } else {
      selectedJobTypes.add(jobType);
    }
        notifyListeners();

  }
}
