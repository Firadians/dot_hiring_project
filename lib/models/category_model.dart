import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String name;
  final double amount;
  final String icon;

  const Category({
    required this.name,
    required this.amount,
    required this.icon,
  });

  @override
  List<Object> get props => [name, amount, icon];
}
