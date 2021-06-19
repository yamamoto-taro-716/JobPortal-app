import 'package:app/apis/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserApi {
  static login(String email, String password) async {
    var res =
        await post('/api/user/login', {'email': email, 'password': password});
    return res;
  }

  static getCategories() async {
    var res = await get('/api/user/getcategories');

    return res;
  }

  static getJobsofDays(DateTime from, DateTime to,
      {String keyword = '',
      int category = 0,
      int filter = 0,
      pageIndex = 0,
      pageSize}) async {
    var res = await post('/api/user/getjobs', {
      'from': from.toUtc().toString(),
      'to': to.toUtc().toString(),
      'keyword': keyword,
      'category': category,
      'filter': filter,
      'pageIndex': pageIndex,
      'pageSize': pageSize
    });
    return res;
  }

  // static getJobsofPast7days() async {
  //   var now = DateTime.now();
  //   var before = now.subtract(Duration(days: 7));
  //   var res = await getJobsofDays(before, now);
  //   return res;
  // }

  static getContract(jobId) async {
    var res = await get('/api/user/contract/$jobId');
    return res;
  }

  static getJobDetail(jobId) async {
    var res = await get('/api/user/getjob/$jobId');
    return res;
  }

  static applyJob(jobId, phoneNumber, budget, message, deadline) async {
    var res = await post('/api/user/apply', {
      'jobId': jobId,
      'budgetApplied': budget,
      'phoneNumber': phoneNumber,
      'message': message,
      'deadline': deadline
    });
    return res;
  }

  static acceptClientOffer(contractId) async {
    var res = await get('/api/user/acceptclientoffer/$contractId');
    return res;
  }

  static requestFinish(contractId) async {
    var res = await get('/api/user/requestfinish/$contractId');
    return res;
  }

  static addFavorite(jobId) async {
    var res = await get('/api/user/addfavorite/$jobId');
    return res;
  }

  static removeFavorite(jobId) async {
    var res = await get('/api/user/removefavorite/$jobId');
    return res;
  }

  static toggleFavorite(jobId) async {
    var res = await get('/api/user/togglefavorite/$jobId');
    return res;
  }
}
