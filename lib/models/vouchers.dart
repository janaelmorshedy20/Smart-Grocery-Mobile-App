class Voucher {
  final String voucherCode;
  final double discount;


  Voucher({
    required this.voucherCode,
    required this.discount,

  });

  // Convert Voucher object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'voucherCode': voucherCode,
      'discount': discount,

    };
  }
}
