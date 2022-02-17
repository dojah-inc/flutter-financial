class DojahConfig {
  bool? debug;
  bool? otp;
  bool? selfie;

  DojahConfig({
    this.debug = false,
    this.otp = false,
    this.selfie = false,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['debug'] = debug;
    data['otp'] = otp;
    data['selfie'] = selfie;
    return data;
  }
}
