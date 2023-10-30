// import 'package:equatable/equatable.dart';
// import 'package:finance_management/services/transactions/models/category_wise.dart';

// class MonthlyBudget extends Equatable {
//   final String month;
//   final double totalBudget;
//   final List<CategoryWise>? categoryWise;

//   const MonthlyBudget({
//     required this.month,
//     required this.totalBudget,
//     this.categoryWise,
//   });

//   factory MonthlyBudget.fromJson(Map<String, dynamic> json) {
//     List<CategoryWise> categoryWise = List<CategoryWise>.from(
//       (json['category-wise'] ?? []).map((e) => CategoryWise.fromJson(e)),
//     );

//     return MonthlyBudget(
//       month: json['Month'],
//       totalBudget: json['totalBudget'],
//       categoryWise: categoryWise,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'month': month,
//       'totalBudget': totalBudget,
//       'categoryWise':
//           categoryWise != null ? categoryWise?.map((e) => e.toMap()) : {},
//     };
//   }

//   @override
//   List<Object?> get props => [
//         month,
//         totalBudget,
//         categoryWise,
//       ];
// }
