class Job {
  String id;
  String title;
  String description;
  int jobType;
  String typeName;
  List<String> contracts;
  String client;
  String clientName;
  String clientPhotoUrl;
  DateTime date;
  DateTime deadLine;
  int budgetRange;
  bool favorite;
  Job(
      {this.id,
      this.title,
      this.description,
      this.jobType,
      this.typeName,
      this.contracts,
      this.client,
      this.date,
      this.budgetRange,
      this.clientName,
      this.clientPhotoUrl,
      this.deadLine,
      this.favorite = false});
  Job.fromJson(Map<String, dynamic> json) {
    this.id = json['_id'];
    this.title = json['title'];
    this.description = json['description'];
    this.jobType = json['job_type'];
    this.typeName = json['type_name'];
    this.contracts = json['contracts'];
    this.client = json['client_id']['_id'];
    this.clientName = json['client_id']['full_name'];
    this.clientPhotoUrl = json['client_id']['photo_url'];
    this.date = DateTime.parse(json['date']);
    this.budgetRange = json['budget_range'];
    this.deadLine =
        json['dead_line'] == null ? null : DateTime.parse(json['dead_line']);
    this.favorite = json['favorite'] == null ? false : json['favorite'];
  }

  static List<Job> fromJsonList(jsonList) {
    return jsonList.map<Job>((job) => Job.fromJson(job)).toList();
  }

  toJson() {
    Map<String, dynamic> json;
    json['_id'] = this.id;
    json['title'] = this.title;
    json['description'] = this.description;
    json['job_type'] = this.jobType;
    json['contracts'] = this.contracts;
    json['client'] = this.client;
    json['date'] = this.date;
    json['budget_range'] = this.budgetRange;
    json['dead_line'] = this.deadLine;
    return json;
  }
}
