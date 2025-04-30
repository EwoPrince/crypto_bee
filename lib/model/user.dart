class User {
  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.photoUrl,
    required this.uid,
    required this.BTC,
    required this.ETH,
    required this.DOGE,
    required this.SOL,
    required this.BNB,
    required this.dollar,
  });

  final String name;
  final String email;
  final String phone;
  final String photoUrl;
  final String uid;
  final double BTC;
  final double ETH;
  final double DOGE;
  final double SOL;
  final double BNB;
  final double dollar;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'BTC': BTC,
      'ETH': ETH,
      'DOGE': DOGE,
      'SOL': SOL,
      'BNB' : BNB,
      'dollar': dollar,
      'uid': uid,
    };
  }

  factory User.fromMap(
    Map<String, dynamic> map,
  ) {
    return User(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      uid: map['uid'] ?? '',
      BTC: map['BTC'] ?? 0,
      ETH: map['ETH'] ?? 0,
      DOGE: map['DOGE'] ?? 0,
      SOL: map['SOL'] ?? 0,
      BNB: map['BNB'] ?? 0,
      dollar: map['dollar'] ?? 0,
    );
  }
}
