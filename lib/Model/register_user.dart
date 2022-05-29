class RegisterUser {
  String fullName;
  String email;
  String city;
  String phoneNumber;
  String hourlyRate;
  String specialization;
  String password;

  RegisterUser({
    this.fullName = "",
    this.email = "",
    this.city = "",
    this.phoneNumber = "",
    required this.hourlyRate,
    this.specialization = "",
    this.password = "",
  });
}
