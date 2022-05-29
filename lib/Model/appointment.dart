class Appointment {
  String appointmentType;
  String doctorName;
  String fromUID;
  String toUID;
  String date;
  String time;
  String note;
  String status;
  double totalFee;
  String patientName;
  String? createdAt;
  int patientAge;
  String ref;
  String address;
  Appointment({
    required this.appointmentType,
    required this.doctorName,
    required this.fromUID,
    required this.toUID,
    required this.date,
    required this.time,
    required this.note,
    required this.status,
    required this.totalFee,
    required this.patientName,
    required this.createdAt,
    required this.patientAge,
    required this.ref,
    required this.address,
  });
}
