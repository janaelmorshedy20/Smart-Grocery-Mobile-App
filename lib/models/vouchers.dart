class Voucher {
  final String voucherCode;
  final double discount;
  final int quantity;
  final String userId;
  final String userName;

  Voucher({
    required this.voucherCode,
    required this.discount,
    required this.quantity,
    required this.userId,
    required this.userName,
  });

  // Convert Voucher object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'voucherCode': voucherCode,
      'discount': discount,
      'quantity': quantity,
      'userId': userId,
      'userName': userName,
    };
  }
}
