class Contract {
  String id;
  String jobId;
  String providerId;
  int status;
  int step;
  DateTime dateApplied;
  DateTime dateEnded;
  String chatId;
  int budgetApplied;
  int budgetAgreed;
  int budgetSafepay;
  int budgetPaid;
  bool clientAgreed;
  bool providerAgreed;
  DateTime deadline;
  String message;
  Contract(
      {this.id,
      this.jobId,
      this.providerId,
      this.status,
      this.step,
      this.dateApplied,
      this.dateEnded,
      this.chatId,
      this.budgetApplied,
      this.budgetAgreed,
      this.budgetSafepay,
      this.budgetPaid,
      this.clientAgreed,
      this.providerAgreed,
      this.deadline,
      this.message});
  fromJson(Map<String, dynamic> json) {
    this.id = json['_id'];
    this.jobId = json['job_id'];
    this.providerId = json['provider_id'];
    this.status = json['status'];
    this.step = json['step'];
    this.dateApplied = json['date_applied'] == null
        ? null
        : DateTime.parse(json['date_applied']);
    this.dateEnded =
        json['date_ended'] == null ? null : DateTime.parse(json['date_ended']);
    this.deadline =
        json['deadline'] == null ? null : DateTime.parse(json['deadline']);
    this.chatId = json['chat_id'];
    this.budgetApplied = json['budget_applied'];
    this.budgetAgreed = json['budget_agreed'];
    this.budgetSafepay = json['budget_safepay'];
    this.budgetPaid = json['budget_paid'];
    this.clientAgreed = json['client_agreed'];
    this.providerAgreed = json['provider_agreed'];
    this.message = json['message'];
  }

  toJson() {
    Map<String, dynamic> json;
    json['_id'] = this.id;
    json['job_id'] = this.jobId;
    json['provider_id'] = this.providerId;
    json['status'] = this.status;
    json['step'] = this.step;
    json['date_applied'] = this.dateApplied;
    json['date_ended'] = this.dateEnded;
    json['chat_id'] = this.chatId;
    json['budget_applied'] = this.budgetApplied;
    json['budget_agreed'] = this.budgetAgreed;
    json['budget_safepay'] = this.budgetSafepay;
    json['budget_paid'] = this.budgetPaid;
    json['client_agreed'] = this.clientAgreed;
    json['provider_agreed'] = this.providerAgreed;
    return json;
  }
}
