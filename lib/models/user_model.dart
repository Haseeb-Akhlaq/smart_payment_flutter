class AppUser {
  String userId;
  String userName;
  String email;
  String walletBalance;

  AppUser({
    this.userId,
    this.userName,
    this.email,
    this.walletBalance,
  });

  AppUser.fromMap(Map<dynamic, dynamic> map) {
    this.userId = map['userId'] ?? '';
    this.userName = map['userName'] ?? '';
    this.email = map['email'] ?? '';
    this.walletBalance = map['walletBalance'] ?? '';
  }
}
