import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_client/common/constants/app_constants.dart';
import 'package:flutter_client/common/manager/network_manager.dart';
import 'package:flutter_client/features/projects/models/project_model.dart';

class ProjectProvider extends ChangeNotifier {
  List<ProjectModel> projects = [];

  Future<void> fetchProjects() async {
    var res =
        await NormalNetworkManager().getResponseFromUrl("$url/your_projects");

    if (res.statusCode != 200) {
      return;
    }

    List<dynamic> d = jsonDecode(res.body) as List<dynamic>;

    projects = List.generate(
      d.length,
      (index) {
        return ProjectModel.fromMap(d[index] as Map<String, dynamic>);
      },
    );
  }

  Future<bool> addProject({
    required String title,
    required List<String> users,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    var res = await NormalNetworkManager()
        .postResponseFromUrl("$url/create_project", data: {
      'user_ids': users,
      'title': title,
      'description': description,
      'image': 'No image for now',
      'start_date': startDate.toString(),
      'end_date': endDate.toString(),
      'status': 'Created',
      'priority': 0,
    });

    log(res.body);

    return res.statusCode == 200;
  }
}
