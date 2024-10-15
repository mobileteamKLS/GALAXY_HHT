class FlightFromULDModel {
  int? flightSeqNo;
  int? uLDSeqNo;
  String? flightAirline;
  String? flightNo;
  String? flightDate;
  String? acceptanceStatus;
  String? suggestionCode;
  String? suggestionMessage;
  String? status;
  String? statusMessage;

  FlightFromULDModel(
      {this.flightSeqNo,
        this.uLDSeqNo,
        this.flightAirline,
        this.flightNo,
        this.flightDate,
        this.acceptanceStatus,
        this.suggestionCode,
        this.suggestionMessage,
        this.status,
        this.statusMessage});

  FlightFromULDModel.fromJson(Map<String, dynamic> json) {
    flightSeqNo = json['FlightSeqNo'];
    uLDSeqNo = json['ULDSeqNo'];
    flightAirline = json['FlightAirline'];
    flightNo = json['FlightNo'];
    flightDate = json['FlightDate'];
    acceptanceStatus = json['AcceptanceStatus'];
    suggestionCode = json['SuggestionCode'];
    suggestionMessage = json['SuggestionMessage'];
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FlightSeqNo'] = this.flightSeqNo;
    data['ULDSeqNo'] = this.uLDSeqNo;
    data['FlightAirline'] = this.flightAirline;
    data['FlightNo'] = this.flightNo;
    data['FlightDate'] = this.flightDate;
    data['AcceptanceStatus'] = this.acceptanceStatus;
    data['SuggestionCode'] = this.suggestionCode;
    data['SuggestionMessage'] = this.suggestionMessage;
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}
