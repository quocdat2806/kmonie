import 'package:equatable/equatable.dart';

class TransactionCategory extends Equatable {
  const TransactionCategory({
    required this.id,
    required this.title,
    required this.image,
  });

  final String id;
  final String title;
  final String image;

  TransactionCategory copyWith({String? id, String? title, String? image}) {
    return TransactionCategory(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
    );
  }

  factory TransactionCategory.fromJson(Map<String, dynamic> json) {
    return TransactionCategory(
      id: json['id'] as String,
      title: json['title'] as String,
      image: json['image'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'title': title,
    'image': image,
  };

  @override
  List<Object?> get props => <Object?>[id, title, image];
}
