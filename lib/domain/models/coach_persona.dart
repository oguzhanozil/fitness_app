import 'package:equatable/equatable.dart';

class CoachPersona extends Equatable {
  final String id;
  final String name;
  final String title;
  final String description;
  final String avatarAsset;
  final String systemInstruction;

  const CoachPersona({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.avatarAsset,
    required this.systemInstruction,
  });

  CoachPersona copyWith({
    String? id,
    String? name,
    String? title,
    String? description,
    String? avatarAsset,
    String? systemInstruction,
  }) {
    return CoachPersona(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      description: description ?? this.description,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      systemInstruction: systemInstruction ?? this.systemInstruction,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'title': title,
        'description': description,
        'avatarAsset': avatarAsset,
        'systemInstruction': systemInstruction,
      };

  factory CoachPersona.fromJson(Map<String, dynamic> json) => CoachPersona(
        id: json['id'] as String,
        name: json['name'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        avatarAsset: json['avatarAsset'] as String,
        systemInstruction: json['systemInstruction'] as String,
      );

  @override
  List<Object?> get props => [id, name, title, description, avatarAsset, systemInstruction];
}
