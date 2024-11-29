class ProjectModel {
  final String? projectId;
  final List<String> userIds;
  final String title;
  final String description;
  final String? image;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final int priority;

  ProjectModel({
    this.projectId,
    required this.userIds,
    required this.title,
    required this.description,
    this.image,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.priority,
  });

  factory ProjectModel.fromMap(Map<String, dynamic> json) {
    return ProjectModel(
      projectId: json['project_id'] as String?,
      userIds: List<String>.from(json['user_ids']),
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] as String?,
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      status: json['status'] as String,
      priority: json['priority'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'project_id': projectId,
      'user_ids': userIds,
      'title': title,
      'description': description,
      'image': image,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
      'priority': priority,
    };
  }
}
