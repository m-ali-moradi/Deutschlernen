// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialogue_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DialogueEntry _$DialogueEntryFromJson(Map<String, dynamic> json) =>
    _DialogueEntry(
      id: (json['id'] as num).toInt(),
      sender: json['sender'] as String,
      role: json['role'] as String,
      german: json['german'] as String,
      english: json['english'] as String,
      audioUrl: json['audioUrl'] as String?,
    );

Map<String, dynamic> _$DialogueEntryToJson(_DialogueEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender': instance.sender,
      'role': instance.role,
      'german': instance.german,
      'english': instance.english,
      'audioUrl': instance.audioUrl,
    };

_DialogueInfo _$DialogueInfoFromJson(Map<String, dynamic> json) =>
    _DialogueInfo(
      id: json['id'] as String,
      title: json['title'] as String,
      englishTitle: json['englishTitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      level: json['level'] as String,
      category: json['category'] as String,
      icon: json['icon'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      entries: (json['entries'] as List<dynamic>)
          .map((e) => DialogueEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DialogueInfoToJson(_DialogueInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'englishTitle': instance.englishTitle,
      'description': instance.description,
      'level': instance.level,
      'category': instance.category,
      'icon': instance.icon,
      'imageUrl': instance.imageUrl,
      'entries': instance.entries,
    };
