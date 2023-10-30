// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:equatable/equatable.dart';

// class Income extends Equatable {
//   final Timestamp date;
//   final double amount;
//   final String category;
//   final String paymentMode;
//   final String? details;
//   final String photoUrl;
//   final String transactionId;

//   const Income({
//     required this.date,
//     required this.amount,
//     required this.category,
//     required this.paymentMode,
//     this.details,
//     required this.photoUrl,
//     required this.transactionId,
//   });

//   factory Income.fromJson(Map<String, dynamic> json) {
//     return Income(
//       date: json['date'],
//       amount: json['amount'],
//       category: json['category'],
//       paymentMode: json['paymentMode'],
//       details: json['details'] ?? '',
//       photoUrl: json['photoUrl'],
//       transactionId: json['transactionId'],
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'date': date,
//       'amount': amount,
//       'category': category,
//       'paymentMode': paymentMode,
//       'details': details ?? {},
//       'photoUrl': photoUrl,
//       'transactionId': transactionId,
//     };
//   }

//   @override
//   List<Object?> get props => [
//         date,
//         amount,
//         category,
//         paymentMode,
//         details,
//         photoUrl,
//         transactionId,
//       ];
// }
