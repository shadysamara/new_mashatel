class ComplaintModel {
  String email;
  String mobileNumber;
  String complaintTitle;
  String complaintContent;
  ComplaintModel(
      {this.complaintContent,
      this.complaintTitle,
      this.email,
      this.mobileNumber});
  toJson() {
    return {
      'email': this.email,
      'phoneNumber': this.mobileNumber,
      'complaintTitle': this.complaintTitle,
      'complaintContent': this.complaintContent
    };
  }
}
