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
    required this.HMSTR,
    required this.PEPE,
    required this.MNT,
    required this.TRX,
    required this.USDT,
    required this.USDC,
    required this.XRP,
    required this.X,
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
  final double HMSTR;
  final double PEPE;
  final double MNT;
  final double TRX;
  final double USDT;
  final double USDC;
  final double XRP;
  final double X;

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
      'HMSTR': HMSTR,
      'PEPE': PEPE,
      'MNT': MNT,
      'TRX': TRX,
      'USDT' : USDT,
      'USDC': USDC,
      'XRP': XRP,
      'X' : X,
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
      HMSTR: map['HMSTR'] ?? 0,
      PEPE: map['PEPE'] ?? 0,
      MNT: map['MNT'] ?? 0,
      TRX: map['TRX'] ?? 0,
      USDT: map['USDT'] ?? 0,
      USDC: map['USDC'] ?? 0,
      XRP: map['XRP'] ?? 0,
      X: map['X'] ?? 0,
    );
  }
}
