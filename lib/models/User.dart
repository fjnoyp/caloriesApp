/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, file_names, unnecessary_new, prefer_if_null_operators, prefer_const_constructors, slash_for_doc_comments, annotate_overrides, non_constant_identifier_names, unnecessary_string_interpolations, prefer_adjacent_string_concatenation, unnecessary_const, dead_code

import 'ModelProvider.dart';
import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the User type in your schema. */
@immutable
class User extends Model {
  static const classType = const _UserModelType();
  final String id;
  final String? _authUserID;
  final int? _calorieLimit;
  final List<FoodEntry>? _foodEntries;
  final bool? _isAdmin;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String get authUserID {
    try {
      return _authUserID!;
    } catch(e) {
      throw new DataStoreException(
      DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
      recoverySuggestion:
        DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
      underlyingException: e.toString()
    );
    }
  }
  
  int get calorieLimit {
    try {
      return _calorieLimit!;
    } catch(e) {
      throw new DataStoreException(
      DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
      recoverySuggestion:
        DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
      underlyingException: e.toString()
    );
    }
  }
  
  List<FoodEntry>? get foodEntries {
    return _foodEntries;
  }
  
  bool? get isAdmin {
    return _isAdmin;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const User._internal({required this.id, required authUserID, required calorieLimit, foodEntries, isAdmin, createdAt, updatedAt}): _authUserID = authUserID, _calorieLimit = calorieLimit, _foodEntries = foodEntries, _isAdmin = isAdmin, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory User({String? id, required String authUserID, required int calorieLimit, List<FoodEntry>? foodEntries, bool? isAdmin}) {
    return User._internal(
      id: id == null ? UUID.getUUID() : id,
      authUserID: authUserID,
      calorieLimit: calorieLimit,
      foodEntries: foodEntries != null ? List<FoodEntry>.unmodifiable(foodEntries) : foodEntries,
      isAdmin: isAdmin);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
      id == other.id &&
      _authUserID == other._authUserID &&
      _calorieLimit == other._calorieLimit &&
      DeepCollectionEquality().equals(_foodEntries, other._foodEntries) &&
      _isAdmin == other._isAdmin;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("User {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("authUserID=" + "$_authUserID" + ", ");
    buffer.write("calorieLimit=" + (_calorieLimit != null ? _calorieLimit!.toString() : "null") + ", ");
    buffer.write("isAdmin=" + (_isAdmin != null ? _isAdmin!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  User copyWith({String? id, String? authUserID, int? calorieLimit, List<FoodEntry>? foodEntries, bool? isAdmin}) {
    return User._internal(
      id: id ?? this.id,
      authUserID: authUserID ?? this.authUserID,
      calorieLimit: calorieLimit ?? this.calorieLimit,
      foodEntries: foodEntries ?? this.foodEntries,
      isAdmin: isAdmin ?? this.isAdmin);
  }
  
  User.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _authUserID = json['authUserID'],
      _calorieLimit = (json['calorieLimit'] as num?)?.toInt(),
      _foodEntries = json['foodEntries'] is List
        ? (json['foodEntries'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => FoodEntry.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _isAdmin = json['isAdmin'],
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'authUserID': _authUserID, 'calorieLimit': _calorieLimit, 'foodEntries': _foodEntries?.map((FoodEntry? e) => e?.toJson()).toList(), 'isAdmin': _isAdmin, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "user.id");
  static final QueryField AUTHUSERID = QueryField(fieldName: "authUserID");
  static final QueryField CALORIELIMIT = QueryField(fieldName: "calorieLimit");
  static final QueryField FOODENTRIES = QueryField(
    fieldName: "foodEntries",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (FoodEntry).toString()));
  static final QueryField ISADMIN = QueryField(fieldName: "isAdmin");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "User";
    modelSchemaDefinition.pluralName = "Users";
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: User.AUTHUSERID,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: User.CALORIELIMIT,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
      key: User.FOODENTRIES,
      isRequired: false,
      ofModelName: (FoodEntry).toString(),
      associatedKey: FoodEntry.USER
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: User.ISADMIN,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _UserModelType extends ModelType<User> {
  const _UserModelType();
  
  @override
  User fromJson(Map<String, dynamic> jsonData) {
    return User.fromJson(jsonData);
  }
}