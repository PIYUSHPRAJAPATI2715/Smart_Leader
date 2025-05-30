class SignupResponse {
  final String result;

  SignupResponse({required this.result});

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      result: json['result'] ?? '',
    );
  }
}
