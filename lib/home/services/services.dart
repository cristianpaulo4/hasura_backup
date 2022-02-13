import 'package:dio/dio.dart';

class ServicesHasura {
  final dio = Dio();

  Future realizarBackup(
      {required String url,  String? pwd}) async {
    var res = url.split("/");

    String new_url = res.elementAt(2);
    print(new_url);

    try {
      
      var res = await dio.post(
        "http://$new_url/v1alpha1/pg_dump",
        options: pwd !=null? Options(
          headers: {"x-hasura-admin-secret": "${pwd.trim()}"},
        ):null,      
        data: {
          "opts": [
            "-O",
            "-x",
            "--schema",
            "public",
            "--schema",
            "auth",
            "--inserts"
          ],
          "clean_output": true
        },
      );
      return res;
      print(res);
      
    } catch (e) {
      print(e);
    }
  }
}
